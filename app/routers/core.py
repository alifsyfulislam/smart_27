"""Login / logout / dashboard routes."""
from fastapi import APIRouter, Request
from fastapi.responses import RedirectResponse

from .. import config
from ..ctx import (authenticate, build_menu, client_ip, ctx, current_user,
                   logout, pop_flash, require_perm, set_flash)
from ..database import q, scalar

router = APIRouter()


def _render_login(request, error=None):
    context = {"request": request, "app_name": config.APP_NAME,
               "app_full_name": config.APP_FULL_NAME, "flash": pop_flash(request),
               "error": error}
    from ..main import templates
    return templates.TemplateResponse(request, "login.html", context)


@router.get("/login")
async def login_page(request: Request):
    if current_user(request):
        return RedirectResponse("/", status_code=303)
    return _render_login(request)


@router.post("/login")
async def login_submit(request: Request):
    form = await request.form()
    user, err = authenticate(request, form.get("user_id") or "", form.get("password") or "")
    if err:
        return _render_login(request, err)
    set_flash(request, "success", f"Welcome {user['name'] or user['user_id']}! You are logged in.")
    return RedirectResponse("/", status_code=303)


@router.get("/logout")
async def do_logout(request: Request):
    logout(request, current_user(request))
    return RedirectResponse("/login", status_code=303)


@router.get("/")
async def dashboard(request: Request):
    user = current_user(request)
    if not user:
        return RedirectResponse("/login", status_code=303)
    stats = {
        "items_active": scalar("SELECT COUNT(*) c FROM sm_item WHERE cid=%s AND status='ACTIVE'", (config.CID,), 0),
        "items_inactive": scalar("SELECT COUNT(*) c FROM sm_item WHERE cid=%s AND status<>'ACTIVE'", (config.CID,), 0),
        "batches": scalar("SELECT COUNT(*) c FROM sm_item_batch WHERE cid=%s AND status='ACTIVE'", (config.CID,), 0),
        "depots_active": scalar("SELECT COUNT(*) c FROM sm_depot WHERE cid=%s AND status='ACTIVE'", (config.CID,), 0),
        "depots_inactive": scalar("SELECT COUNT(*) c FROM sm_depot WHERE cid=%s AND status<>'ACTIVE'", (config.CID,), 0),
        "stores": scalar("SELECT COUNT(*) c FROM sm_depot_store WHERE cid=%s AND status='ACTIVE'", (config.CID,), 0),
        "users": scalar("SELECT COUNT(*) c FROM sm_acl_user WHERE cid=%s AND status='ACTIVE'", (config.CID,), 0),
        "roles": scalar("SELECT COUNT(*) c FROM sm_acl_role WHERE cid=%s", (config.CID,), 0),
    }
    by_depth = q("""SELECT depth, COUNT(*) c FROM sm_item_hierarchy
                    WHERE cid=%s AND status='ACTIVE' GROUP BY depth ORDER BY depth""", (config.CID,))
    level_map = {0: "Company", 1: "Brand", 2: "Type", 3: "Flavor"}
    hierarchy = [(level_map.get(int(r["depth"]), f"Level {r['depth']}"), r["c"]) for r in by_depth]
    max_level_count = max((c for _n, c in hierarchy), default=0)
    recent = q("SELECT * FROM sm_audit_log WHERE cid=%s ORDER BY id DESC LIMIT 8", (config.CID,))
    context = ctx(request, user)
    context.update({"title": "Dashboard", "stats": stats, "hierarchy": hierarchy,
                    "max_level_count": max_level_count, "recent_audit": recent})
    from ..main import templates
    return templates.TemplateResponse(request, "dashboard.html", context)


# ---------------- audit log viewer (self-contained list with filters) --------
@router.get("/audit-log")
async def audit_log(request: Request, page: int = 1, qk: str = "", f_table: str = "",
                    f_action: str = "", f_user: str = "", page_size: int = 15):
    user = current_user(request)
    if not user:
        return RedirectResponse("/login", status_code=303)
    if not require_perm(user, "audit.view"):
        from ..main import forbidden
        return forbidden(request)
    where, params = ["cid=%s"], [config.CID]
    if qk:
        where.append("(record_key LIKE %s OR note LIKE %s OR changed_by LIKE %s)")
        params += [f"%{qk}%"] * 3
    if f_table:
        where.append("table_name=%s"); params.append(f_table)
    if f_action:
        where.append("action=%s"); params.append(f_action)
    if f_user:
        where.append("changed_by=%s"); params.append(f_user)
    wsql = " AND ".join(where)
    total = scalar(f"SELECT COUNT(*) c FROM sm_audit_log WHERE {wsql}", params, 0)
    pages = max(1, (total + page_size - 1) // page_size)
    page = min(max(1, page), pages)
    rows = q(f"SELECT * FROM sm_audit_log WHERE {wsql} ORDER BY id DESC LIMIT %s OFFSET %s",
             params + [page_size, (page - 1) * page_size])
    context = ctx(request, user)
    context.update({
        "title": "Audit Log", "rows": rows, "total": total, "page": page,
        "pages": pages, "page_size": page_size, "qk": qk,
        "f_table": f_table, "f_action": f_action, "f_user": f_user,
        "tables": [r["table_name"] for r in
                   q("SELECT DISTINCT table_name FROM sm_audit_log WHERE cid=%s", (config.CID,))],
        "actions": sorted({r["action"] for r in
                           q("SELECT DISTINCT action FROM sm_audit_log WHERE cid=%s", (config.CID,))}),
        "users": [r["changed_by"] for r in
                  q("SELECT DISTINCT changed_by FROM sm_audit_log WHERE cid=%s", (config.CID,))],
    })
    from ..main import templates
    return templates.TemplateResponse(request, "audit/list.html", context)
