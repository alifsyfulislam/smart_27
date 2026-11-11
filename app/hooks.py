"""Business-rule hooks for SSMS modules (invoked by the generic CRUD router)."""
from . import config
from .database import q, x, scalar

MAX_DEPTH = 3  # company(0) > brand(1) > type(2) > flavor(3)
LEVEL_PREFIX = {0: "MG", 1: "BG", 2: "CG", 3: "FG"}


# ----------------------------------------------------------------- hierarchy
def hierarchy_prepare(cid, data, existing=None, user=None):
    """Create/edit an sm_item_hierarchy row.

    On create: auto-generate level_id (MG/BG/CG/FG + padded number per
    LEVEL_PREFIX), fill the
    full path columns (level0..level3), depth and is_leaf — exactly the sample
    rows described in the requirements.
    """
    name = (data.get("level_name") or "").strip()
    if not name:
        return "Level name is required."

    if existing is not None:
        # rename (level_id / path never change)
        data["level_name"] = name
        return _hierarchy_rename_check(cid, existing, data)

    parent_id = (data.get("parent_level_id") or "0").strip() or "0"
    if parent_id == "0":
        parent = None
        depth = 0
    else:
        parent = q("SELECT * FROM sm_item_hierarchy WHERE cid=%s AND level_id=%s",
                   (cid, parent_id), one=True)
        if not parent or parent["status"] != "ACTIVE":
            return "Parent level not found or inactive."
        depth = int(parent["depth"] or 0) + 1
        if depth > MAX_DEPTH:
            return f"Cannot create a level below '{LEVEL_PREFIX[MAX_DEPTH]}' — hierarchy limit is Company > Brand > Type > Flavor."

    dup = q(f"""SELECT id FROM sm_item_hierarchy
                WHERE cid=%s AND status='ACTIVE' AND level_name=%s
                  {"AND parent_level_id=%s" if parent else "AND parent_level_id='0'"}
                LIMIT 1""",
            (cid, name) + ((parent_id,) if parent else ()), one=True)
    if dup:
        return "A level with this name already exists under the same parent."

    prefix = LEVEL_PREFIX[depth]
    code = _next_code(cid, prefix)
    data["level_id"] = code
    data["depth"] = depth
    data["is_leaf"] = "1"
    data["parent_level_id"] = parent_id
    data["parent_level_name"] = (parent["level_name"] if parent else "-") or "-"
    # full path fill
    for i in range(4):
        data[f"level{i}"] = "-"
        data[f"level{i}_name"] = "-"
        if i < depth and parent:  # ancestors path inherited from parent row
            data[f"level{i}"] = parent[f"level{i}"] or ""
            data[f"level{i}_name"] = parent[f"level{i}_name"] or ""
        elif i == depth:
            data[f"level{i}"] = code
            data[f"level{i}_name"] = name
        else:
            data[f"level{i}"] = ""
            data[f"level{i}_name"] = ""
        # '-' placeholders follow the sample for levels below the root
        if i > depth:
            data[f"level{i}"] = ""
            data[f"level{i}_name"] = ""
    # root row sample uses '-' placeholders for the deeper levels
    for i in range(depth + 1, 4):
        data[f"level{i}"] = "-" if depth > 0 else "-"
        data[f"level{i}_name"] = "-" if depth > 0 else "-"
    data["status"] = "ACTIVE"
    return None


def _hierarchy_rename_check(cid, existing, data):
    name = data["level_name"]
    dup = q("""SELECT id FROM sm_item_hierarchy
               WHERE cid=%s AND status='ACTIVE' AND level_name=%s
                 AND parent_level_id=%s AND id<>%s LIMIT 1""",
            (cid, name, existing["parent_level_id"], existing["id"]), one=True)
    if dup:
        return "A level with this name already exists under the same parent."
    return None


def _next_code(cid, prefix):
    rows = q("SELECT level_id FROM sm_item_hierarchy WHERE cid=%s AND level_id LIKE %s",
             (cid, prefix + "%"))
    max_no = 0
    for r in rows:
        tail = r["level_id"][len(prefix):]
        if tail.isdigit():
            max_no = max(max_no, int(tail))
    return f"{prefix}{max_no + 1:03d}"


def _recompute_is_leaf(cid, level_id):
    """Maintain the is_leaf invariant: '1' when the level has no ACTIVE child,
    '0' when it has at least one. Called on create, update, soft delete and
    restore of hierarchy rows."""
    if not level_id or level_id == "0":
        return
    n = scalar("SELECT COUNT(*) c FROM sm_item_hierarchy "
               "WHERE cid=%s AND parent_level_id=%s AND status='ACTIVE'",
               (cid, level_id), 0)
    x("UPDATE sm_item_hierarchy SET is_leaf=%s WHERE cid=%s AND level_id=%s",
      ("0" if n else "1", cid, level_id))


def hierarchy_after_create(cid, row, user=None):
    # a parent that now has a child is no longer a leaf
    _recompute_is_leaf(cid, row.get("parent_level_id"))


def hierarchy_after_update(cid, old, new, user=None):
    # propagate a rename to all descendant rows' path columns
    if (old.get("level_name") or "") != (new.get("level_name") or ""):
        x("UPDATE sm_item_hierarchy SET parent_level_name=%s WHERE cid=%s AND parent_level_id=%s",
          (new["level_name"], cid, new["level_id"]))
        depth = int(new.get("depth") or 0)
        x(f"UPDATE sm_item_hierarchy SET level{depth}_name=%s WHERE cid=%s AND level{depth}=%s",
          (new["level_name"], cid, new["level_id"]))
    # re-derive leaf flag from the current ACTIVE children (and the parent,
    # which cannot change on edit but is recomputed for safety)
    _recompute_is_leaf(cid, new.get("level_id"))
    _recompute_is_leaf(cid, new.get("parent_level_id"))


def hierarchy_soft_delete(cid, rid, user=None):
    """Leaf-only delete: a level with at least one ACTIVE child cannot be
    soft deleted — the user must delete (deactivate) the children first."""
    row = q("SELECT * FROM sm_item_hierarchy WHERE cid=%s AND id=%s", (cid, rid), one=True)
    if not row:
        return None, "Record not found."
    nchild = scalar("SELECT COUNT(*) c FROM sm_item_hierarchy WHERE cid=%s AND parent_level_id=%s AND status='ACTIVE'",
                    (cid, row["level_id"]), 0)
    if nchild:
        return None, (f"Cannot delete '{row['level_name']}' ({row['level_id']}) — it has "
                      f"{nchild} active child level(s). Delete the child levels first.")
    _, n = x("UPDATE sm_item_hierarchy SET status='PENDING', updated_on=NOW(), updated_by=%s "
             "WHERE cid=%s AND id=%s AND status='ACTIVE'", (user, cid, rid))
    # with this child gone the parent may become a leaf again
    _recompute_is_leaf(cid, row.get("parent_level_id"))
    return n, None


def hierarchy_restore(cid, rid, user=None):
    row = q("SELECT * FROM sm_item_hierarchy WHERE cid=%s AND id=%s", (cid, rid), one=True)
    if not row:
        return None, "Record not found."
    pid = row.get("parent_level_id")
    if pid and pid != "0":
        parent = q("SELECT status FROM sm_item_hierarchy WHERE cid=%s AND level_id=%s",
                   (cid, pid), one=True)
        if not parent or parent["status"] != "ACTIVE":
            return None, "Parent level is pending — restore the parent first."
    _, n = x("UPDATE sm_item_hierarchy SET status='ACTIVE', updated_on=NOW(), updated_by=%s "
             "WHERE cid=%s AND id=%s AND status='PENDING'", (user, cid, rid))
    # the parent gains an ACTIVE child again; the restored row is also re-derived
    _recompute_is_leaf(cid, pid)
    _recompute_is_leaf(cid, row.get("level_id"))
    return n, None


# ----------------------------------------------------------------- item
def item_prepare(cid, data, existing=None, user=None):
    item_id = (data.get("item_id") or "").strip()
    name = (data.get("name") or "").strip()
    if not item_id or not name:
        return "Item ID and Name are required."
    dup_sql = "SELECT id FROM sm_item WHERE cid=%s AND item_id=%s"
    dup_params = [cid, item_id]
    if existing is not None:
        dup_sql += " AND id<>%s"
        dup_params.append(existing["id"])
    if q(dup_sql, dup_params, one=True):
        return "An item with this Item ID already exists."

    # value-list codes are stored canonically (uppercase) — keeps filters and
    # edit preselects exact even when legacy rows hold display names
    for k in ("item_category", "unit_type"):
        if (data.get(k) or "").strip():
            data[k] = data[k].strip().upper()

    # total_amount = price + VAT when the form did not send one (JS normally
    # computes it live; this covers no-JS / API / excel paths)
    try:
        total = float(data.get("total_amt") or 0)
    except (TypeError, ValueError):
        total = 0.0
    if not total:
        try:
            data["total_amt"] = round(float(data.get("price") or 0) + float(data.get("vat_amt") or 0), 2)
        except (TypeError, ValueError):
            data["total_amt"] = 0.0

    # resolve hierarchy names from the ids collected by the cascade form
    from .modules import MODULES
    for fid in ("company", "brand", "type", "flavor"):
        id_col, name_col = f"{fid}_id", f"{fid}_name"
        code = (data.get(id_col) or "").strip()
        if code and code not in ("-",):
            node = q("SELECT level_name FROM sm_item_hierarchy WHERE cid=%s AND level_id=%s AND status='ACTIVE'",
                     (cid, code), one=True)
            data[id_col] = code
            data[name_col] = node["level_name"] if node else "-"
        else:
            data[id_col] = "-"
            data[name_col] = "-"
    return None


def item_after_create(cid, row, user=None):
    """Every item automatically gets a default batch: batch_id '1',
    expiary_date 2100-12-31 (per requirements). The batch mirrors the
    item's own status."""
    x("""INSERT INTO sm_item_batch
         (cid, item_id, name, batch_id, expiary_date, status, note, created_on, created_by)
         VALUES (%s,%s,%s,'1','2100-12-31',%s,'Default batch (auto)',NOW(),%s)
         ON DUPLICATE KEY UPDATE name=VALUES(name)""",
      (cid, row["item_id"], row["name"], (row.get("status") or "ACTIVE"), user or "SYSTEM"))


def _cascade_item_status(cid, item_id, status, user=None):
    """An item's status is always reflected on its batches: whatever status the
    item carries (INACTIVE/PENDING/REJECTED/...) is pushed to every batch row."""
    if not item_id or not status:
        return
    x("""UPDATE sm_item_batch SET status=%s, updated_on=NOW(), updated_by=%s
         WHERE cid=%s AND item_id=%s AND status<>%s""",
      (status, user or "SYSTEM", cid, item_id, status))


def item_after_update(cid, old, new, user=None):
    if (old.get("status") or "") != (new.get("status") or ""):
        _cascade_item_status(cid, new.get("item_id"), new.get("status"), user)


def item_soft_delete(cid, rid, user=None):
    row = q("SELECT * FROM sm_item WHERE cid=%s AND id=%s", (cid, rid), one=True)
    if not row:
        return None, "Record not found."
    _, n = x("UPDATE sm_item SET status='PENDING', updated_on=NOW(), updated_by=%s "
             "WHERE cid=%s AND id=%s AND status='ACTIVE'", (user, cid, rid))
    if n:
        _cascade_item_status(cid, row["item_id"], "PENDING", user)
    return n, None


def item_restore(cid, rid, user=None):
    row = q("SELECT * FROM sm_item WHERE cid=%s AND id=%s", (cid, rid), one=True)
    if not row:
        return None, "Record not found."
    _, n = x("UPDATE sm_item SET status='ACTIVE', updated_on=NOW(), updated_by=%s "
             "WHERE cid=%s AND id=%s AND status<>'ACTIVE'", (user, cid, rid))
    if n:
        _cascade_item_status(cid, row["item_id"], "ACTIVE", user)
    return n, None


# ----------------------------------------------------------------- batch
def item_batch_prepare(cid, data, existing=None, user=None):
    item_id = (data.get("item_id") or "").strip()
    batch_id = (data.get("batch_id") or "").strip()
    if not item_id or not batch_id:
        return "Item and Batch ID are required."
    item = q("SELECT name FROM sm_item WHERE cid=%s AND item_id=%s", (cid, item_id), one=True)
    if not item:
        return f"Item '{item_id}' not found."
    if not (data.get("name") or "").strip():
        data["name"] = item["name"] or "-"
    exp = data.get("expiary_date")
    if not exp:
        return "Expiry date is required."
    dup_sql = "SELECT id FROM sm_item_batch WHERE cid=%s AND item_id=%s AND batch_id=%s"
    dup_params = [cid, item_id, batch_id]
    if existing is not None:
        dup_sql += " AND id<>%s"
        dup_params.append(existing["id"])
    if q(dup_sql, dup_params, one=True):
        return "This batch already exists for the item."
    return None


# ----------------------------------------------------------------- depot
def depot_prepare(cid, data, existing=None, user=None):
    depot_id = (data.get("depot_id") or "").strip()
    name = (data.get("name") or "").strip()
    if not depot_id or not name:
        return "Distributor ID and Name are required."
    dup_sql = "SELECT id FROM sm_depot WHERE cid=%s AND depot_id=%s"
    dup_params = [cid, depot_id]
    if existing is not None:
        dup_sql += " AND id<>%s"
        dup_params.append(existing["id"])
    if q(dup_sql, dup_params, one=True):
        return "A distributor with this Depot ID already exists."
    if not (data.get("depot_category") or "").strip():
        data["depot_category"] = "DISTRIBUTOR"
    return None


def depot_after_create(cid, row, user=None):
    """Every distributor automatically gets two default stores:
       {depot_id}140 -> Commercial, {depot_id}170 -> Damage (per requirements)."""
    user = user or "SYSTEM"
    pairs = [(f"{row['depot_id']}140", "Commercial", "COMMERCIAL"),
             (f"{row['depot_id']}170", "Damage", "DAMAGE")]
    for store_id, store_name, store_type in pairs:
        x("""INSERT INTO sm_depot_store
             (cid, depot_id, store_id, store_name, store_type, status, note, created_on, created_by)
             VALUES (%s,%s,%s,%s,%s,'ACTIVE','Default store (auto)',NOW(),%s)
             ON DUPLICATE KEY UPDATE store_name=VALUES(store_name)""",
          (cid, row["depot_id"], store_id, store_name[:100], store_type, user))


# ----------------------------------------------------------------- store
def depot_store_prepare(cid, data, existing=None, user=None):
    depot_id = (data.get("depot_id") or "").strip()
    store_id = (data.get("store_id") or "").strip()
    store_name = (data.get("store_name") or "").strip()
    if not depot_id or not store_id or not store_name:
        return "Distributor, Store ID and Store Name are required."
    if not q("SELECT id FROM sm_depot WHERE cid=%s AND depot_id=%s", (cid, depot_id), one=True):
        return f"Distributor '{depot_id}' not found."
    dup_sql = "SELECT id FROM sm_depot_store WHERE cid=%s AND depot_id=%s AND store_id=%s"
    dup_params = [cid, depot_id, store_id]
    if existing is not None:
        dup_sql += " AND id<>%s"
        dup_params.append(existing["id"])
    if q(dup_sql, dup_params, one=True):
        return "This store already exists for the distributor."
    return None


# ----------------------------------------------------------------- category
def category_type_prepare(cid, data, existing=None, user=None):
    type_name = (data.get("type_name") or "").strip().upper()
    cat_type_id = (data.get("cat_type_id") or "").strip().upper()
    if not type_name or not cat_type_id:
        return "Type Name and Category ID are required."
    data["type_name"] = type_name
    data["cat_type_id"] = cat_type_id
    dup_sql = "SELECT id FROM sm_category_type WHERE cid=%s AND type_name=%s AND cat_type_id=%s"
    dup_params = [cid, type_name, cat_type_id]
    if existing is not None:
        dup_sql += " AND id<>%s"
        dup_params.append(existing["id"])
    if q(dup_sql, dup_params, one=True):
        return "This category definition already exists."
    return None


# ----------------------------------------------------------------- outlet
OUTLET_CAT_TYPE = "OUTLET_CATEGORY"        # e.g. OC001 — KR0
OUTLET_SUBCAT_TYPE = "OUTLET_SUB_CATEGORY"  # e.g. OSC001 — KR0-1


def _cat_type_name(cid, type_name, cat_type_id):
    node = q("SELECT cat_type_name FROM sm_category_type "
             "WHERE cid=%s AND type_name=%s AND cat_type_id=%s",
             (cid, type_name, cat_type_id), one=True)
    return (node["cat_type_name"] if node else "-") or "-"


def outlet_prepare(cid, data, existing=None, user=None):
    """Create/edit an sm_client (Outlet) row.

    Auto-fill rules: category/sub-category names resolve from sm_category_type,
    customer_type is generated as 'CATEGORY_ID|CATEGORY_NAME', depot/store names
    resolve from sm_depot / sm_depot_store, and (cid, client_id) is unique."""
    client_id = (data.get("client_id") or "").strip()
    name = (data.get("name") or "").strip()
    if not client_id or not name:
        return "Outlet ID and Outlet Name are required."
    dup_sql = "SELECT id FROM sm_client WHERE cid=%s AND client_id=%s"
    dup_params = [cid, client_id]
    if existing is not None:
        dup_sql += " AND id<>%s"
        dup_params.append(existing["id"])
    if q(dup_sql, dup_params, one=True):
        return "An outlet with this Outlet ID already exists."

    cat_id = (data.get("category_id") or "").strip()
    data["category_id"] = cat_id or "-"
    data["category_name"] = _cat_type_name(cid, OUTLET_CAT_TYPE, cat_id) if cat_id else "-"
    sub_id = (data.get("sub_category_id") or "").strip()
    data["sub_category_id"] = sub_id or "-"
    data["sub_category_name"] = _cat_type_name(cid, OUTLET_SUBCAT_TYPE, sub_id) if sub_id else "-"
    # customer_type is auto-generated, never typed by the user
    data["customer_type"] = f"{data['category_id']}|{data['category_name']}" if cat_id else "-"

    depot_id = (data.get("depot_id") or "").strip()
    data["depot_id"] = depot_id or "-"
    if depot_id and depot_id != "-":
        depot = q("SELECT name FROM sm_depot WHERE cid=%s AND depot_id=%s",
                  (cid, depot_id), one=True)
        if not depot:
            return f"Distributor '{depot_id}' not found."
        data["depot_name"] = (depot["name"] or "-") or "-"
    else:
        data["depot_name"] = "-"

    store_id = (data.get("store_id") or "").strip()
    data["store_id"] = store_id or "-"
    if store_id and store_id != "-":
        if not (depot_id and depot_id != "-"):
            return "Select a distributor before choosing a store."
        store = q("SELECT store_name FROM sm_depot_store WHERE cid=%s AND depot_id=%s AND store_id=%s",
                  (cid, depot_id, store_id), one=True)
        if not store:
            return f"Store '{store_id}' not found under distributor '{depot_id}'."
        data["store_name"] = (store["store_name"] or "-") or "-"
    else:
        data["store_name"] = "-"

    if not (data.get("status") or "").strip():
        data["status"] = "ACTIVE"
    return None


# ----------------------------------------------------------------- registry
HOOKS = {
    "hierarchy": {
        "prepare": hierarchy_prepare,
        "after_create": hierarchy_after_create,
        "after_update": hierarchy_after_update,
        "soft_delete": hierarchy_soft_delete,
        "restore": hierarchy_restore,
    },
    "item": {
        "prepare": item_prepare,
        "after_create": item_after_create,
        "after_update": item_after_update,
        "soft_delete": item_soft_delete,
        "restore": item_restore,
    },
    "item_batch": {"prepare": item_batch_prepare},
    "depot": {
        "prepare": depot_prepare,
        "after_create": depot_after_create,
    },
    "depot_store": {"prepare": depot_store_prepare},
    "outlet": {"prepare": outlet_prepare},
    "category_type": {"prepare": category_type_prepare},
}


def generic_soft_delete(m, cid, rid, user=None):
    _, n = x(f"UPDATE `{m['table']}` SET status='PENDING', updated_on=NOW(), updated_by=%s WHERE cid=%s AND id=%s",
             (user, cid, rid))
    return n, None


def generic_restore(m, cid, rid, user=None):
    _, n = x(f"UPDATE `{m['table']}` SET status='ACTIVE', updated_on=NOW(), updated_by=%s WHERE cid=%s AND id=%s",
             (user, cid, rid))
    return n, None


def soft_delete(m, cid, rid, user=None):
    hook = HOOKS.get(m["create_hook"], {})
    fn = hook.get("soft_delete") or (lambda c, r, u=None: generic_soft_delete(m, c, r, u))
    return fn(cid, rid, user)


def restore(m, cid, rid, user=None):
    hook = HOOKS.get(m["create_hook"], {})
    fn = hook.get("restore") or (lambda c, r, u=None: generic_restore(m, c, r, u))
    return fn(cid, rid, user)
