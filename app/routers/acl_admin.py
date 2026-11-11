"""Access Control admin screens: Users, Roles, Permissions."""
from fastapi import APIRouter, Request
from fastapi.responses import RedirectResponse

from .. import config
from ..audit import log_change
from ..ctx import (client_ip, ctx, current_user, require_perm, set_flash)
from ..database import q, scalar, x
from ..modules import STATUS_OPTIONS
from ..security import hash_password, invalidate_user_cache

router = APIRouter()


def _guard_user(request, manage=False):
    user = current_user(request)
    if user is None:
        return user, ctx(request, None), RedirectResponse("/login", status_code=303)
    if not require_perm(user, "acl.view"):
        set_flash(request, "danger", "You do not have permission for this action.")
        return user, ctx(request, user), RedirectResponse("/", status_code=303)
    if manage and not require_perm(user, "acl.manage"):
        set_flash(request, "danger", "You do not have permission for this action.")
        return user, ctx(request, user), RedirectResponse("/users", status_code=303)
    return user, ctx(request, user), None


def _set_role_perms(cid, role_id, perms, by):
    x("DELETE FROM sm_acl_role_permission WHERE cid=%s AND role_id=%s", (cid, role_id))
    for pid in perms:
        if q("SELECT 1 FROM sm_acl_permission WHERE cid=%s AND perm_id=%s", (cid, pid), one=True):
            x("INSERT INTO sm_acl_role_permission (cid, role_id, perm_id, created_on, created_by)"
              " VALUES (%s,%s,%s,NOW(),%s)", (cid, role_id, pid, by))
    invalidate_user_cache(None)


def _perm_module(pid):
    return pid.split(".")[0] if "." in pid else "other"


# ------------------------------------------------------------------ USERS
@router.get("/users")
async def users_list(request: Request, qk: str = ""):
    user, context, redirect = _guard_user(request)
    if redirect:
        return redirect
    where, params = ["u.cid=%s"], [config.CID]
    if qk:
        where.append("(u.user_id LIKE %s OR u.name LIKE %s OR u.email LIKE %s)")
        params += [f"%{qk}%"] * 3

    rows = q(f"""SELECT u.*,
                    (SELECT GROUP_CONCAT(r.role_id SEPARATOR ', ')
                       FROM sm_acl_user_role ur JOIN sm_acl_role r
                         ON r.cid=ur.cid AND r.role_id=ur.role_id
                      WHERE ur.cid=u.cid AND ur.user_id=u.user_id) roles
                 FROM sm_acl_user u WHERE {' AND '.join(where)}
                 ORDER BY u.id DESC LIMIT 200""", params)
    
    all_roles = q("SELECT * FROM sm_acl_role WHERE cid=%s AND status = 'ACTIVE' AND role_id <> 'super_admin' ORDER BY role_id", (config.CID,))
    context.update({"title": "Users", "rows": rows, "all_roles": all_roles,
                    "statuses": STATUS_OPTIONS, "qk": qk,
                    "can_manage": require_perm(user, "acl.manage")})
    from ..main import templates
    return templates.TemplateResponse(request, "acl/users.html", context)


def _set_user_roles(cid, uid, roles, by):
    x("DELETE FROM sm_acl_user_role WHERE cid=%s AND user_id=%s", (cid, uid))
    for rid in roles:
        if q("SELECT 1 FROM sm_acl_role WHERE cid=%s AND role_id=%s", (cid, rid), one=True):
            x("INSERT INTO sm_acl_user_role (cid, user_id, role_id, created_on, created_by)"
              " VALUES (%s,%s,%s,NOW(),%s)", (cid, uid, rid, by))


@router.post("/users/create")
async def user_create(request: Request):
    user, context, redirect = _guard_user(request, manage=True)
    if redirect:
        return redirect
    form = await request.form()
    uid = (form.get("user_id") or "").strip()
    name = (form.get("name") or "").strip()
    password = form.get("password") or ""
    if not uid or not name or not password:
        set_flash(request, "danger", "User ID, Name and Password are required.")
        return RedirectResponse("/users", status_code=303)
    if q("SELECT 1 FROM sm_acl_user WHERE cid=%s AND user_id=%s", (config.CID, uid), one=True):
        set_flash(request, "danger", f"User '{uid}' already exists.")
        return RedirectResponse("/users", status_code=303)
    x("""INSERT INTO sm_acl_user
         (cid, user_id, name, email, password_hash, is_super, status, created_on, created_by)
         VALUES (%s,%s,%s,%s,%s,%s,%s,NOW(),%s)""",
      (config.CID, uid, name, (form.get("email") or "-").strip() or "-",
       hash_password(password), 1 if (form.get("is_super") or "0") == "1" else 0,
       form.get("status") or "ACTIVE", user["user_id"]))
    _set_user_roles(config.CID, uid, form.getlist("roles"), user["user_id"])
    invalidate_user_cache(uid)
    row = q("SELECT * FROM sm_acl_user WHERE cid=%s AND user_id=%s", (config.CID, uid), one=True)
    log_change(config.CID, "sm_acl_user", uid, "CREATE", new=row,
               changed_by=user["user_id"], user_ip=client_ip(request))
    set_flash(request, "success", f"User '{uid}' created.")
    return RedirectResponse("/users", status_code=303)


@router.post("/users/edit/{uid}")
async def user_edit(request: Request, uid: str):
    user, context, redirect = _guard_user(request, manage=True)
    if redirect:
        return redirect
    old = q("SELECT * FROM sm_acl_user WHERE cid=%s AND user_id=%s", (config.CID, uid), one=True)
    if not old:
        set_flash(request, "danger", "User not found.")
        return RedirectResponse("/users", status_code=303)
    form = await request.form()
    name = (form.get("name") or "").strip() or old["name"]
    email = (form.get("email") or "-").strip() or "-"
    status = form.get("status") or old["status"]
    is_super = 1 if (form.get("is_super") or "0") == "1" else 0
    password = form.get("password") or None
    ph = hash_password(password) if password else old["password_hash"]
    x("""UPDATE sm_acl_user SET name=%s, email=%s, status=%s, is_super=%s,
         password_hash=%s, updated_on=NOW(), updated_by=%s
         WHERE cid=%s AND user_id=%s""",
      (name, email, status, is_super, ph, user["user_id"], config.CID, uid))
    _set_user_roles(config.CID, uid, form.getlist("roles"), user["user_id"])
    invalidate_user_cache(uid)
    new = q("SELECT * FROM sm_acl_user WHERE cid=%s AND user_id=%s", (config.CID, uid), one=True)
    log_change(config.CID, "sm_acl_user", uid, "UPDATE", old=old, new=new,
               changed_by=user["user_id"], user_ip=client_ip(request),
               note="password changed" if password else "")
    set_flash(request, "success", f"User '{uid}' updated.")
    return RedirectResponse("/users", status_code=303)


@router.post("/users/delete/{uid}")
async def user_delete(request: Request, uid: str):
    user, context, redirect = _guard_user(request, manage=True)
    if redirect:
        return redirect
    if uid == user["user_id"]:
        set_flash(request, "danger", "You cannot deactivate your own account.")
        return RedirectResponse("/users", status_code=303)
    old = q("SELECT * FROM sm_acl_user WHERE cid=%s AND user_id=%s", (config.CID, uid), one=True)
    if not old:
        set_flash(request, "danger", "User not found.")
        return RedirectResponse("/users", status_code=303)
    form = await request.form()
    to_status = "ACTIVE" if (form.get("restore") == "1") else "PENDING"
    x("UPDATE sm_acl_user SET status=%s, updated_on=NOW(), updated_by=%s WHERE cid=%s AND user_id=%s",
      (to_status, user["user_id"], config.CID, uid))
    invalidate_user_cache(uid)
    log_change(config.CID, "sm_acl_user", uid, "RESTORE" if to_status == "ACTIVE" else "DELETE",
               old=old, changed_by=user["user_id"], user_ip=client_ip(request))
    set_flash(request, "success", f"User '{uid}' {'restored' if to_status == 'ACTIVE' else 'set to INACTIVE'}.")
    return RedirectResponse("/users", status_code=303)


# ------------------------------------------------------------------ ROLES
@router.get("/roles")
async def roles_list(request: Request, qk: str = ""):
    user, context, redirect = _guard_user(request)
    if redirect:
        return redirect
    where, params = ["r.cid=%s"], [config.CID]
    if qk:
        where.append("(r.role_id LIKE %s OR r.role_name LIKE %s)")
        params += [f"%{qk}%"] * 2
    rows = q(f"""SELECT r.*,
                    (SELECT COUNT(*) FROM sm_acl_user_role ur WHERE ur.cid=r.cid AND ur.role_id=r.role_id) n_users
                 FROM sm_acl_role r WHERE {' AND '.join(where)} ORDER BY r.id DESC""", params)
    perms_by_module = _grouped_perms()
    role_perms = {r["role_id"]: {p["perm_id"] for p in
                  q("SELECT perm_id FROM sm_acl_role_permission WHERE cid=%s AND role_id=%s",
                    (config.CID, r["role_id"]))} for r in rows}
    context.update({"title": "Roles", "rows": rows, "qk": qk,
                    "perms_by_module": perms_by_module, "role_perms": role_perms,
                    "can_manage": require_perm(user, "acl.manage")})
    from ..main import templates
    return templates.TemplateResponse(request, "acl/roles.html", context)


@router.post("/roles/create")
async def role_create(request: Request):
    user, context, redirect = _guard_user(request, manage=True)
    if redirect:
        return redirect
    form = await request.form()
    rid = (form.get("role_id") or "").strip().upper().replace(" ", "_")
    name = (form.get("role_name") or "").strip()
    if not rid or not name:
        set_flash(request, "danger", "Role ID and Role Name are required.")
        return RedirectResponse("/roles", status_code=303)
    if q("SELECT 1 FROM sm_acl_role WHERE cid=%s AND role_id=%s", (config.CID, rid), one=True):
        set_flash(request, "danger", f"Role '{rid}' already exists.")
        return RedirectResponse("/roles", status_code=303)
    x("INSERT INTO sm_acl_role (cid, role_id, role_name, status, created_on, created_by)"
      " VALUES (%s,%s,%s,%s,NOW(),%s)", (config.CID, rid, name, "ACTIVE", user["user_id"]))
    _set_role_perms(config.CID, rid, form.getlist("perms"), user["user_id"])
    row = q("SELECT * FROM sm_acl_role WHERE cid=%s AND role_id=%s", (config.CID, rid), one=True)
    log_change(config.CID, "sm_acl_role", rid, "CREATE", new=row,
               changed_by=user["user_id"], user_ip=client_ip(request))
    set_flash(request, "success", f"Role '{rid}' created.")
    return RedirectResponse("/roles", status_code=303)


@router.post("/roles/edit/{rid}")
async def role_edit(request: Request, rid: str):
    user, context, redirect = _guard_user(request, manage=True)
    if redirect:
        return redirect
    old = q("SELECT * FROM sm_acl_role WHERE cid=%s AND role_id=%s", (config.CID, rid), one=True)
    if not old:
        set_flash(request, "danger", "Role not found.")
        return RedirectResponse("/roles", status_code=303)
    form = await request.form()
    name = (form.get("role_name") or "").strip() or old["role_name"]
    x("UPDATE sm_acl_role SET role_name=%s, updated_on=NOW(), updated_by=%s WHERE cid=%s AND role_id=%s",
      (name, user["user_id"], config.CID, rid))
    _set_role_perms(config.CID, rid, form.getlist("perms"), user["user_id"])
    new = q("SELECT * FROM sm_acl_role WHERE cid=%s AND role_id=%s", (config.CID, rid), one=True)
    log_change(config.CID, "sm_acl_role", rid, "UPDATE", old=old, new=new,
               changed_by=user["user_id"], user_ip=client_ip(request))
    set_flash(request, "success", f"Role '{rid}' updated.")
    return RedirectResponse("/roles", status_code=303)

@router.post("/roles/delete/{rid}")
async def role_delete(request: Request, rid: str):
    user, context, redirect = _guard_user(request, manage=True)
    if redirect:
        return redirect
    old = q("SELECT * FROM sm_acl_role WHERE cid=%s AND role_id=%s", (config.CID, rid), one=True)
    if not old:
        set_flash(request, "danger", "Role not found.")
        return RedirectResponse("/roles", status_code=303)
    form = await request.form()
    to_status = "ACTIVE" if (form.get("restore") == "1") else "PENDING"
    x("UPDATE sm_acl_role SET status=%s, updated_on=NOW(), updated_by=%s WHERE cid=%s AND role_id=%s",
      (to_status, user["user_id"], config.CID, rid))
    log_change(config.CID, "sm_acl_role", rid, "RESTORE" if to_status == "ACTIVE" else "DELETE",
                   old=old, changed_by=user["user_id"], user_ip=client_ip(request))
    set_flash(request, "success", f"Role '{rid}' {'restored' if to_status == 'ACTIVE' else 'set to INACTIVE'}.")
    return RedirectResponse("/roles", status_code=303)


# -------------------------------------------------------- PERMISSIONS
def _grouped_perms():
    groups = {}
    for p in q("SELECT * FROM sm_acl_permission WHERE cid=%s AND status='ACTIVE' ORDER BY perm_id",
               (config.CID,)):
        groups.setdefault(_perm_module(p["perm_id"]), []).append(p)
    return groups


@router.get("/permissions")
async def permissions_list(request: Request, qk: str = ""):
    user, context, redirect = _guard_user(request)
    if redirect:
        return redirect
    where, params = ["cid=%s"], [config.CID]
    if qk:
        where.append("(perm_id LIKE %s OR perm_name LIKE %s OR module LIKE %s)")
        params += [f"%{qk}%"] * 3
    rows = q(f"SELECT * FROM sm_acl_permission WHERE {' AND '.join(where)} ORDER BY id DESC LIMIT 300", params)
    context.update({"title": "Permissions", "rows": rows, "qk": qk,
                    "perms_by_module": _grouped_perms(),
                    "can_manage": require_perm(user, "acl.manage")})
    from ..main import templates
    return templates.TemplateResponse(request, "acl/permissions.html", context)


@router.post("/permissions/create")
async def permission_create(request: Request):
    user, context, redirect = _guard_user(request, manage=True)
    if redirect:
        return redirect
    form = await request.form()
    pid = (form.get("perm_id") or "").strip().lower().replace(" ", "_")
    pname = (form.get("perm_name") or "").strip()
    module = (form.get("module") or "-").strip() or "-"
    if not pid or not pname:
        set_flash(request, "danger", "Permission ID and Name are required.")
        return RedirectResponse("/permissions", status_code=303)
    if q("SELECT 1 FROM sm_acl_permission WHERE cid=%s AND perm_id=%s", (config.CID, pid), one=True):
        set_flash(request, "danger", f"Permission '{pid}' already exists.")
        return RedirectResponse("/permissions", status_code=303)
    x("""INSERT INTO sm_acl_permission (cid, perm_id, perm_name, module, status, created_on, created_by)
         VALUES (%s,%s,%s,%s,'ACTIVE',NOW(),%s)""", (config.CID, pid, pname, module, user["user_id"]))
    row = q("SELECT * FROM sm_acl_permission WHERE cid=%s AND perm_id=%s", (config.CID, pid), one=True)
    log_change(config.CID, "sm_acl_permission", pid, "CREATE", new=row,
               changed_by=user["user_id"], user_ip=client_ip(request))
    set_flash(request, "success", f"Permission '{pid}' created.")
    return RedirectResponse("/permissions", status_code=303)
