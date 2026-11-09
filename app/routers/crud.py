"""Generic CRUD for every master-data module in app/modules.py.

Features per module: create, view, edit, soft delete (status PENDING),
restore, template-based Excel batch upload + template download, search,
filters and pagination.
"""
import io
import json
import os
import re
from datetime import datetime
from urllib.parse import urlencode

from fastapi import APIRouter, Request
from fastapi.responses import RedirectResponse, Response

from openpyxl import Workbook, load_workbook

from .. import config
from ..audit import log_change
from ..ctx import client_ip, ctx, current_user, require_perm, set_flash
from ..database import q, scalar, x
from ..hooks import HOOKS
from ..modules import (PERM2SLUG, STATUS_OPTIONS, MODULES, get, touch,
                       values_from_form)

router = APIRouter()

_GROUP_BY_MODULE = {
    "brand": "Item Info", "item": "Item Info", "item-batch": "Item Info",
    "distributor": "Distributor Info", "distributor-store": "Distributor Info",
    "category-type": "Settings",
}

_COL_CACHE: dict = {}

# ------------------------------------------------------------- image uploads
_STATIC_DIR = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "static")
UPLOAD_DIR = os.path.join(_STATIC_DIR, "uploads")
ALLOWED_IMAGE_EXT = ("png", "jpg", "jpeg", "gif", "webp")
MAX_IMAGE_MB = 5

# hierarchy depth -> label of the level that can be added as a child
_NEXT_LEVEL = {0: "Brand", 1: "Type", 2: "Flavor"}


def _slugify(text):
    slug = re.sub(r"[^a-z0-9]+", "-", (text or "").lower()).strip("-")
    return slug or "item"


async def _collect_image_uploads(m, form, data, existing=None):
    """Read new image files from the multipart form (inputs named <col>_file).

    Returns (updates, writes, error): updates maps column -> /static/uploads
    URL, writes is [(filename, bytes)]. Files are written to disk only AFTER
    the row was created/updated successfully, so failed validations leave no
    orphan uploads behind. Naming: {table}_{slug}_image_{timestamp}.{ext}."""
    updates, writes = {}, []
    for spec in m["form_fields"]:
        if spec["type"] != "image":
            continue
        col = spec["name"]
        up = form.get(col + "_file")
        if up is None or not getattr(up, "filename", ""):
            continue
        ext = os.path.splitext(up.filename)[1].lower().lstrip(".")
        if ext not in ALLOWED_IMAGE_EXT:
            return None, None, (f"{spec['label']}: only {', '.join(ALLOWED_IMAGE_EXT)} "
                                "files are allowed.")
        blob = await up.read()
        if len(blob) > MAX_IMAGE_MB * 1024 * 1024:
            return None, None, f"{spec['label']}: file is larger than {MAX_IMAGE_MB} MB."
        slug_src = ((data.get("level_name") or "").strip()
                    or ((existing or {}).get("level_name") or "").strip()
                    or (data.get("name") or "").strip()
                    or ((existing or {}).get("name") or "").strip())
        ts = datetime.now().strftime("%Y%m%d%H%M%S%f")[:-3]  # ms precision -> unique
        fname = f"{m['table']}_{_slugify(slug_src)}_image_{ts}.{ext}"
        updates[col] = f"/static/uploads/{fname}"
        writes.append((fname, blob))
    return updates, writes, None


def _write_image_uploads(writes):
    if not writes:
        return
    os.makedirs(UPLOAD_DIR, exist_ok=True)
    for fname, blob in writes:
        with open(os.path.join(UPLOAD_DIR, fname), "wb") as fh:
            fh.write(blob)


def table_cols(m):
    slug = m["perm"]
    if slug not in _COL_CACHE:
        _COL_CACHE[slug] = {r["Field"] for r in q(f"SHOW COLUMNS FROM `{m['table']}`")}
    return _COL_CACHE[slug]


def _access(request, slug, action):
    """Return (module, user, context) or (None, user, RedirectResponse)."""
    user = current_user(request)
    if not user:
        return None, None, RedirectResponse("/login", status_code=303)
    m = get(slug)
    if not m:
        return None, user, RedirectResponse("/", status_code=303)
    if not require_perm(user, f"{m['perm']}.{action}"):
        set_flash(request, "danger", "You do not have permission for this action.")
        target = "/" if action == "view" else f"/{slug}"
        return None, user, RedirectResponse(target, status_code=303)
    context = ctx(request, user)
    context["perms"] = {a: require_perm(user, f"{m['perm']}.{a}")
                        for a in ("view", "create", "edit", "delete", "import")}
    return m, user, context


# ------------------------------------------------------------------ helpers
def _insert(m, data, user):
    allowed = table_cols(m)
    data = {k: v for k, v in data.items() if k in allowed and k != "id"}
    cols = list(data.keys())
    col_sql = ", ".join(f"`{c}`" for c in cols)
    val_sql = ", ".join("NOW()" if v == "NOW()" else "%s" for v in data.values())
    params = [v for v in data.values() if v != "NOW()"]
    rid, _ = x(f"INSERT INTO `{m['table']}` ({col_sql}) VALUES ({val_sql})", params)
    return rid


def _update(m, rid, data, user):
    allowed = table_cols(m)
    sets, params = [], []
    for k, v in data.items():
        if k not in allowed or k == "id":
            continue
        sets.append(f"`{k}`=%s")
        params.append(None if v == "NOW()" and False else v)  # timestamps use NOW()
    sets.append("updated_on=NOW()")
    sets.append("updated_by=%s")
    params.append(user)
    params.append(rid)
    x(f"UPDATE `{m['table']}` SET {', '.join(sets)} WHERE id=%s", params)


def _hierarchy_parent_opts():
    """Parent choices for the brand create form — ACTIVE Company nodes only
    (depth < 1); deeper levels are created as children from the edit page."""
    return q("""SELECT id, level_id, level_name, level1_name, depth FROM sm_item_hierarchy
                WHERE cid=%s AND status='ACTIVE' AND depth < 1
                ORDER BY depth, level_id""", (config.CID,))


def _hierarchy_children(level_id):
    """Direct child levels of a hierarchy node (brand edit page section)."""
    return q("""SELECT id, level_id, level_name, depth, is_leaf, status
                FROM sm_item_hierarchy
                WHERE cid=%s AND parent_level_id=%s
                ORDER BY level_id""", (config.CID, level_id))


def _build_tree(rows):
    """Nest flat hierarchy rows under their parents (brand tree view)."""
    nodes = {r["level_id"]: {**r, "children": []} for r in rows}
    roots = []
    for r in rows:
        node = nodes[r["level_id"]]
        pid = r.get("parent_level_id") or "0"
        if pid in nodes and pid != r["level_id"]:
            nodes[pid]["children"].append(node)
        else:
            roots.append(node)
    return roots


def _cat_options(type_name):
    return [(r["cat_type_id"], r["cat_type_name"] or r["cat_type_id"])
            for r in q("""SELECT cat_type_id, cat_type_name FROM sm_category_type
                          WHERE cid=%s AND type_name=%s AND status='ACTIVE'
                          ORDER BY cat_type_id""", (config.CID, type_name))]


def _filter_options(m):
    out = []
    for f in m["filters"]:
        name, label, kind = f[0], f[1], f[2]
        opts = _cat_options(f[3]) if kind == "cat" else STATUS_OPTIONS
        out.append({"name": name, "label": label, "options": opts})
    return out


def _record_key(m, row):
    key_map = {"brand": "level_id", "item": "item_id", "item-batch": "batch_id",
               "distributor": "depot_id", "distributor-store": "store_id",
               "category-type": "id"}
    col = {v: k for k, v in key_map.items()}  # not used; direct below
    return row.get(key_map.get(next((s for s, mm in MODULES.items() if mm is m), ""), "id")) or row["id"]


def key_col_of(m):
    return {"brand": "level_id", "item": "item_id", "item-batch": "batch_id",
            "distributor": "depot_id", "distributor-store": "store_id",
            "category-type": "id"}.get(m["perm"], "id")


# ------------------------------------------------------------------- list
@router.get("/{slug}")
async def module_list(request: Request, slug: str, page: int = 1, qk: str = "",
                      page_size: int = 10, status: str = "", sort: str = ""):
    result = _access(request, slug, "view")
    m, user, context = result[0], result[1], result[2]
    if isinstance(context, RedirectResponse):
        return context
    if m is None:
        return RedirectResponse("/", status_code=303)

    where, params = [f"t.cid=%s"], [config.CID]

    if qk:
        likes = []
        for c in m["search_cols"]:
            likes.append(f"t.{c} LIKE %s")
            params.append(f"%{qk}%")
        where.append("(" + " OR ".join(likes) + ")")
    filt_vals = {f[0]: request.query_params.get(f[0], "") for f in m["filters"]}
    for f in m["filters"]:
        name, _label, kind = f[0], f[1], f[2]
        val = (filt_vals.get(name) or "").strip()
        if not val:
            continue
        # column always `name` except status filter on tables whose column name is status
        col = name if name in table_cols(m) else "status"
        where.append(f"t.{col}=%s")
        params.append(val)
    wsql = " AND ".join(where)

    total = scalar(f"SELECT COUNT(*) c FROM `{m['table']}` t WHERE {wsql}", params, 0)
    page_size = max(5, min(page_size, 100))
    pages = max(1, (total + page_size - 1) // page_size)
    page = min(max(1, page), pages)
    order = sort if (sort and "{" not in sort) else m["order"]

    rows = q(f"""SELECT t.* FROM `{m['table']}` t WHERE {wsql}
                 ORDER BY {order} LIMIT %s OFFSET %s""",
             params + [page_size, (page - 1) * page_size])

    # brand renders a parent->child tree (full result set, no pagination);
    # when searching/filtering, pull in the ancestor chain so matches keep
    # their tree context
    tree = None
    if slug == "brand":
        rows = q(f"""SELECT t.* FROM `{m['table']}` t WHERE {wsql}
                     ORDER BY depth ASC, level_id ASC""", params)
        
        if qk or any(filt_vals.values()):
            seen = list(set([r["level_id"] for r in rows]))
            seen_str = str(seen).strip().replace('[','(').replace(']',')')
            # return seen

            anc = q(f"""SELECT * FROM sm_item_hierarchy WHERE cid=%s AND level_id=%s""",
                    (config.CID, seen_str))
            if anc:
                rows = anc

            rows = sorted(
                rows,
                key=lambda r: (
                    int(r["depth"] or 0),
                    r["level_id"] or ""
                )
            )
            # rows.sort(key=lambda r: (int(r["depth"] or 0), r["level_id"] or ""))
        tree = _build_tree(rows)
    item_opts = None
    if slug == "item-batch":
        item_opts = q("""SELECT item_id, name FROM sm_item WHERE cid=%s AND status='ACTIVE'
                         ORDER BY name LIMIT 300""", (config.CID,))
    depot_opts = None
    if slug == "distributor-store":
        depot_opts = q("""SELECT depot_id, name FROM sm_depot WHERE cid=%s AND status='ACTIVE'
                          ORDER BY name LIMIT 300""", (config.CID,))

    keep = {"qk": qk, "page_size": page_size, "status": status}
    keep.update(filt_vals)
    query = urlencode({"k": v for k, v in keep.items() if v})

    context.update({
        "m": m, "slug": slug, "title": m["title"], "rows": rows, "fcols": m["list_cols"],
        "total": total, "page": page, "pages": pages, "page_size": page_size,
        "qk": qk, "filters": _filter_options(m), "filt_vals": filt_vals,
        "query": query, "tree": tree,
        "item_opts": item_opts or [], "depot_opts": depot_opts or [],
    })
    from ..main import templates
    return templates.TemplateResponse(request, "generic/list.html", context)


# ---------------------------------------------------------------- create
def _form_context(m, context, action, row=None, data=None, error=None, parent_opts=None,
                  item_opts=None, depot_opts=None, children=None, next_level=None):
    field_opts = {}
    for spec in m["form_fields"]:
        if spec["cat"]:
            field_opts[spec["name"]] = _cat_options(spec["cat"])
    context.update({
        "m": m, "slug": PERM2SLUG.get(m["perm"], m["perm"]),
        "title": f"{m['title']} — {action}", "row": row, "data": data or {},
        "error": error, "a": action, "field_opts": field_opts,
        "parent_opts": parent_opts or [], "item_opts": item_opts or [], "depot_opts": depot_opts or [],
        "children": children if children is not None else [],
        "next_level": next_level or "",
    })
    return context


@router.get("/{slug}/create")
async def module_create_form(request: Request, slug: str):
    result = _access(request, slug, "create")
    m, user, context = result[0], result[1], result[2]
    if isinstance(context, RedirectResponse):
        return context
    parent_opts, item_opts, depot_opts = [], [], []
    if slug == "brand":
        parent_opts = _hierarchy_parent_opts()
    if slug == "item-batch":
        item_opts = q("""SELECT item_id, name FROM sm_item WHERE cid=%s AND status='ACTIVE'
                         ORDER BY name LIMIT 300""", (config.CID,))
    if slug == "distributor-store":
        depot_opts = q("""SELECT depot_id, name FROM sm_depot WHERE cid=%s AND status='ACTIVE'
                          ORDER BY name LIMIT 300""", (config.CID,))
    if slug == "category-type":
        context["type_names"] = [r["type_name"] for r in
                                 q("SELECT DISTINCT type_name FROM sm_category_type WHERE cid=%s ORDER BY type_name",
                                   (config.CID,))]
    from ..main import templates
    return templates.TemplateResponse(
        request, "generic/form.html",
        _form_context(m, context, "Create", data={s["name"]: (s["default"] if s["type"] in ("select", "int", "float") else "")
                                                 for s in m["form_fields"]},
                      parent_opts=parent_opts, item_opts=item_opts, depot_opts=depot_opts))


async def _do_create(request, slug, data, user, source="form", row_label=""):
    """Shared by form create + excel upload. Returns error string or None."""
    m = get(slug)
    hook = HOOKS.get(m["create_hook"], {})
    err = hook["prepare"](config.CID, data, None, user["user_id"]) if hook.get("prepare") else None
    if err:
        return err
    touch(data, user["user_id"], is_create=True)
    rid = _insert(m, data, user["user_id"])
    row = q(f"SELECT * FROM `{m['table']}` WHERE id=%s", (rid,), one=True)
    if hook.get("after_create"):
        hook["after_create"](config.CID, row, user["user_id"])
    log_change(config.CID, m["table"], str(row.get(key_col_of(m), rid)), "CREATE",
               old=None, new=row, changed_by=user["user_id"], user_ip=client_ip(request),
               note=source)
    return None


@router.post("/{slug}/create")
async def module_create(request: Request, slug: str):
    result = _access(request, slug, "create")
    m, user, context = result[0], result[1], result[2]
    if isinstance(context, RedirectResponse):
        return context
    form = await request.form()
    data = values_from_form(m, form, None, is_create=True)
    if slug == "item" or (m.get("create_hook") == "item"):
        for fkey in ("company_id", "brand_id", "type_id", "flavor_id"):
            data[fkey] = (form.get(fkey) or "").strip()
    img_updates, img_writes, img_err = await _collect_image_uploads(m, form, data)
    if img_err:
        err = img_err
    else:
        data.update(img_updates)
        err = await _do_create(request, slug, data, user, source="Manual create")
    if not err:
        _write_image_uploads(img_writes)   # persist files only after the row exists
    if err:
        context["error"] = err
        parent_opts = item_opts = depot_opts = []
        if slug == "brand":
            parent_opts = _hierarchy_parent_opts()
        elif slug == "item-batch":
            item_opts = q("""SELECT item_id, name FROM sm_item WHERE cid=%s AND status='ACTIVE'
                             ORDER BY name LIMIT 300""", (config.CID,))
        elif slug == "distributor-store":
            depot_opts = q("""SELECT depot_id, name FROM sm_depot WHERE cid=%s AND status='ACTIVE'
                              ORDER BY name LIMIT 300""", (config.CID,))
        from ..main import templates
        return templates.TemplateResponse(
            request, "generic/form.html",
            _form_context(m, context, "Create", data={**{s["name"]: "" for s in m["form_fields"]}, **data},
                          error=err, parent_opts=parent_opts, item_opts=item_opts, depot_opts=depot_opts))
    set_flash(request, "success", f"{m['title']} created successfully.")
    return RedirectResponse(f"/{slug}", status_code=303)


# ---------------------------------------------------------------- edit
@router.get("/{slug}/view/{rid}")
async def module_view(request: Request, slug: str, rid: int):
    result = _access(request, slug, "view")
    m, user, context = result[0], result[1], result[2]
    if isinstance(context, RedirectResponse):
        return context
    row = q(f"SELECT * FROM `{m['table']}` WHERE cid=%s AND id=%s", (config.CID, rid), one=True)
    if not row:
        set_flash(request, "danger", "Record not found.")
        return RedirectResponse(f"/{slug}", status_code=303)
    children, next_level = [], ""
    if slug == "brand":
        children = _hierarchy_children(row["level_id"])
        next_level = _NEXT_LEVEL.get(int(row["depth"] or 0), "")
    from ..main import templates
    return templates.TemplateResponse(
        request, "generic/form.html",
        _form_context(m, context, "View", row=row,
                      data={k: ("" if v is None else v) for k, v in row.items()},
                      children=children, next_level=next_level))


@router.get("/{slug}/edit/{rid}")
async def module_edit_form(request: Request, slug: str, rid: int):
    result = _access(request, slug, "edit")
    m, user, context = result[0], result[1], result[2]
    if isinstance(context, RedirectResponse):
        return context
    row = q(f"SELECT * FROM `{m['table']}` WHERE cid=%s AND id=%s", (config.CID, rid), one=True)
    if not row:
        set_flash(request, "danger", "Record not found.")
        return RedirectResponse(f"/{slug}", status_code=303)
    children, next_level = [], ""
    if slug == "brand":
        children = _hierarchy_children(row["level_id"])
        next_level = _NEXT_LEVEL.get(int(row["depth"] or 0), "")
    from ..main import templates
    return templates.TemplateResponse(
        request, "generic/form.html",
        _form_context(m, context, "Edit", row=row,
                      data={k: ("" if v is None else v) for k, v in row.items()},
                      children=children, next_level=next_level))


@router.post("/{slug}/edit/{rid}")
async def module_edit(request: Request, slug: str, rid: int):
    # return response.json(request)
    result = _access(request, slug, "edit")
    m, user, context = result[0], result[1], result[2]
    if isinstance(context, RedirectResponse):
        return context
    row = q(f"SELECT * FROM `{m['table']}` WHERE cid=%s AND id=%s", (config.CID, rid), one=True)
    if not row:
        set_flash(request, "danger", "Record not found.")
        return RedirectResponse(f"/{slug}", status_code=303)
    form = await request.form()
    data = {k: v for k, v in row.items() if k != "id"}
    data.update(values_from_form(m, form, row, is_create=False))
    if m["create_hook"] == "item":
        for fkey in ("company_id", "brand_id", "type_id", "flavor_id"):
            data[fkey] = (form.get(fkey) or (row.get(fkey) or "-")).strip()
    img_updates, img_writes, img_err = await _collect_image_uploads(m, form, data, existing=row)
    children, next_level = [], ""
    if slug == "brand":
        children = _hierarchy_children(row["level_id"])
        next_level = _NEXT_LEVEL.get(int(row["depth"] or 0), "")
    hook = HOOKS.get(m["create_hook"], {})
    err = img_err or (hook["prepare"](config.CID, data, row, user["user_id"]) if hook.get("prepare") else None)
    if err:
        from ..main import templates
        return templates.TemplateResponse(
            request, "generic/form.html",
            _form_context(m, context, "Edit", row=row, data={k: ("" if v is None else v) for k, v in data.items()},
                          error=err, children=children, next_level=next_level))
    if img_updates:                      # no new file -> keep the existing image_path
        data.update(img_updates)
    _update(m, rid, data, user["user_id"])
    _write_image_uploads(img_writes)     # persist files only after the update succeeded
    new = q(f"SELECT * FROM `{m['table']}` WHERE id=%s", (rid,), one=True)
    if hook.get("after_update"):
        hook["after_update"](config.CID, row, new, user["user_id"])
    log_change(config.CID, m["table"], str(new.get(key_col_of(m), rid)), "UPDATE",
               old=row, new=new, changed_by=user["user_id"], user_ip=client_ip(request))
    set_flash(request, "success", f"{m['title']} updated successfully.")
    return RedirectResponse(f"/{slug}", status_code=303)


# ---------------------------------------------------------- add child levels
@router.post("/{slug}/add-children/{rid}")
async def module_add_children(request: Request, slug: str, rid: int):
    """Brand edit page: create one or many child levels under this node in a
    single submit. Each child flows through _do_create -> hierarchy hook
    (auto-code, path fill, is_leaf) + central audit log."""
    result = _access(request, slug, "create")
    m, user, context = result[0], result[1], result[2]
    if isinstance(context, RedirectResponse):
        return context
    row = q(f"SELECT * FROM `{m['table']}` WHERE cid=%s AND id=%s", (config.CID, rid), one=True)
    if not row:
        set_flash(request, "danger", "Record not found.")
        return RedirectResponse(f"/{slug}", status_code=303)
    form = await request.form()
    names, seen = [], set()
    for raw in form.getlist("child_names"):
        n = (raw or "").strip()
        if n and n.lower() not in seen:
            names.append(n)
            seen.add(n.lower())
    if not names:
        set_flash(request, "danger", "Enter at least one child level name.")
        return RedirectResponse(f"/{slug}/edit/{rid}", status_code=303)
    ok, errors = 0, []
    for name in names:
        data = {"parent_level_id": row["level_id"], "level_name": name}
        try:
            err = await _do_create(request, slug, data, user,
                                   source=f"Child level of {row['level_id']} (edit page)")
        except Exception as e:  # malformed row
            err = str(e)[:200]
        if err:
            errors.append(f"{name}: {err}")
        else:
            ok += 1
    if ok and not errors:
        set_flash(request, "success",
                  f"{ok} child level(s) added under '{row['level_name']}' ({row['level_id']}).")
    elif ok:
        set_flash(request, "success",
                  f"{ok} child level(s) added under '{row['level_name']}' ({row['level_id']}). "
                  "Not added: " + " | ".join(errors[:5]))
    else:
        set_flash(request, "danger", "No child level added. " + " | ".join(errors[:5]))
    return RedirectResponse(f"/{slug}/edit/{rid}", status_code=303)


# ------------------------------------------------------- delete / restore
@router.post("/{slug}/delete/{rid}")
async def module_delete(request: Request, slug: str, rid: int):
    result = _access(request, slug, "delete")
    m, user, context = result[0], result[1], result[2]
    if isinstance(context, RedirectResponse):
        return context
    old = q(f"SELECT * FROM `{m['table']}` WHERE cid=%s AND id=%s", (config.CID, rid), one=True)
    if not old:
        set_flash(request, "danger", "Record not found.")
        return RedirectResponse(f"/{slug}", status_code=303)
    n, err = _soft_delete(m, config.CID, rid, user["user_id"])
    if err:
        set_flash(request, "danger", err)
    else:
        log_change(config.CID, m["table"], str(old.get(key_col_of(m), rid)), "DELETE",
                   old=old, new=None, changed_by=user["user_id"],
                   user_ip=client_ip(request), note=f"{n} row(s) affected")
        set_flash(request, "success", f"{m['title']} set to PENDING (soft deleted).")
    return RedirectResponse(f"/{slug}", status_code=303)


def _soft_delete(m, cid, rid, user_id):
    hook = HOOKS.get(m["create_hook"], {})
    if hook.get("soft_delete"):
        return hook["soft_delete"](cid, rid, user_id)
    _, n = x(f"UPDATE `{m['table']}` SET status='PENDING', updated_on=NOW(), updated_by=%s "
             f"WHERE cid=%s AND id=%s", (user_id, cid, rid))
    return n, None


@router.post("/{slug}/restore/{rid}")
async def module_restore(request: Request, slug: str, rid: int):
    result = _access(request, slug, "delete")
    m, user, context = result[0], result[1], result[2]
    if isinstance(context, RedirectResponse):
        return context
    old = q(f"SELECT * FROM `{m['table']}` WHERE cid=%s AND id=%s", (config.CID, rid), one=True)
    if not old:
        set_flash(request, "danger", "Record not found.")
        return RedirectResponse(f"/{slug}", status_code=303)
    hook = HOOKS.get(m["create_hook"], {})
    if hook.get("restore"):
        n, err = hook["restore"](config.CID, rid, user["user_id"])
        if err:
            set_flash(request, "danger", err)
            return RedirectResponse(f"/{slug}", status_code=303)
    else:
        _, _ = x(f"UPDATE `{m['table']}` SET status='ACTIVE', updated_on=NOW(), updated_by=%s "
                 f"WHERE cid=%s AND id=%s", (user["user_id"], config.CID, rid))
    log_change(config.CID, m["table"], str(old.get(key_col_of(m), rid)), "RESTORE",
               old=old, new=None, changed_by=user["user_id"], user_ip=client_ip(request))
    set_flash(request, "success", f"{m['title']} restored to ACTIVE.")
    return RedirectResponse(f"/{slug}", status_code=303)


# -------------------------------------------------- excel template + upload
@router.get("/{slug}/template")
async def module_template(request: Request, slug: str):
    result = _access(request, slug, "import")
    m, user, context = result[0], result[1], result[2]
    if isinstance(context, RedirectResponse):
        return context
    wb = Workbook()
    ws = wb.active
    ws.title = "TEMPLATE"
    ws.append([s.replace("_", " ").upper() for s in m["excel_cols"]])
    ws.append([s.upper() for s in m["excel_cols"]])
    for col in range(1, len(m["excel_cols"]) + 1):
        ws.cell(row=1, column=col).font = ws.cell(row=1, column=col).font.copy(bold=True)
    # example row
    example = {"item": {"item_id": "1101", "name": "Sample Item", "unit_type": "PCS",
                        "pack_size": "10x50g", "weight": 50,
                        "company_id": "CG001", "brand_id": "BG001", "type_id": "TG001",
                        "flavor_id": "-"},
               "brand": {"parent_level_id": "0", "level_name": "TCPL Products"},
               "item-batch": {"item_id": "1101", "batch_id": "1", "expiary_date": "2100-12-31"},
               "distributor": {"depot_id": "131313", "name": "Sample Distributor"},
               "distributor-store": {"depot_id": "131313", "store_id": "131313140",
                                     "store_name": "Commercial", "store_type": "COMMERCIAL"},
               "category-type": {"type_name": "STORE_TYPE", "cat_type_id": "EXAMPLE",
                                 "cat_type_name": "Example"}}
    ws.append([example.get(slug, {}).get(c, "") for c in m["excel_cols"]])
    buf = io.BytesIO()
    wb.save(buf)
    return Response(
        content=buf.getvalue(),
        media_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        headers={"Content-Disposition": f'attachment; filename="{slug}_template.xlsx"'})


@router.post("/{slug}/upload")
async def module_upload(request: Request, slug: str):
    result = _access(request, slug, "import")
    m, user, context = result[0], result[1], result[2]
    if isinstance(context, RedirectResponse):
        return context
    form = await request.form()
    upload = form.get("file")
    if upload is None or not upload.filename:
        set_flash(request, "danger", "Choose an .xlsx file first.")
        return RedirectResponse(f"/{slug}", status_code=303)
    try:
        wb = load_workbook(io.BytesIO(await upload.read()), data_only=True, read_only=True)
        ws = wb.active
        rows = list(ws.iter_rows(values_only=True))
    finally:
        try:
            wb.close()
        except Exception:
            pass
    if not rows:
        set_flash(request, "danger", "The uploaded file is empty.")
        return RedirectResponse(f"/{slug}", status_code=303)
    header = [str(h or "").strip().lower().replace(" ", "_") for h in rows[0]]
    idx = {c: i for i, c in enumerate(m["excel_cols"]) if c in header}
    missing = [c for c in m["excel_cols"] if c not in idx]
    if missing:
        set_flash(request, "danger", f"Template mismatch — missing column(s): {', '.join(missing)}. Download the template again.")
        return RedirectResponse(f"/{slug}", status_code=303)

    ok, fail, errors = 0, 0, []
    for i, raw in enumerate(rows[1:], start=2):
        if raw is None or all(v is None or str(v).strip() == "" for v in raw):
            continue
        data = {}
        for col, ci in idx.items():
            val = raw[ci]
            spec = next((s for s in m["form_fields"] if s["name"] == col), None)
            if spec and spec["type"] == "int":
                try:
                    val = int(float(val)) if val not in (None, "") else 0
                except (TypeError, ValueError):
                    val = 0
            elif spec and spec["type"] == "float":
                try:
                    val = float(val) if val not in (None, "") else 0.0
                except (TypeError, ValueError):
                    val = 0.0
            else:
                val = "" if val is None else str(val).strip()
            data[col] = val
            if col == "status" and not val:
                data[col] = "ACTIVE"
        # some hooks need extra keys even outside the template
        if slug == "brand":
            data.setdefault("parent_level_id", "0")
        try:
            err = await _do_create(request, slug, data, user, source=f"Excel upload row {i}")
        except Exception as e:  # malformed row
            err = str(e)[:200]
        if err:
            fail += 1
            if len(errors) < 15:
                errors.append(f"Row {i}: {err}")
        else:
            ok += 1
    if ok:
        set_flash(request, "success", f"Import finished: {ok} row(s) created, {fail} failed.")
        if errors:
            set_flash(request, "danger", "Errors: " + " | ".join(errors))
    else:
        set_flash(request, "danger", "No row was imported." + (" " + " | ".join(errors) if errors else ""))
    return RedirectResponse(f"/{slug}", status_code=303)


# --------------------------------------------------------- tiny JSON API
@router.get("/api/hierarchy/children")
async def hierarchy_children(request: Request, parent: str = "0"):
    user = current_user(request)
    if not user:
        return {"items": []}
    rows = q("""SELECT level_id, level_name, depth, is_leaf,
                   (SELECT COUNT(*) FROM sm_item_hierarchy s2
                     WHERE s2.cid=h.cid AND s2.parent_level_id=h.level_id AND s2.status='ACTIVE') nchild
                FROM sm_item_hierarchy h
                WHERE cid=%s AND status='ACTIVE' AND parent_level_id=%s""",
             (config.CID, parent or "0"))
    return {"items": rows}
