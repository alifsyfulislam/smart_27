"""Request context helpers: current user, permission-guarded menu, flashes."""
from fastapi import Request

from . import config
from .audit import log_change
from .database import q
from .modules import MODULES
from .security import has_perm, verify_password
from .security import _PERM_CACHE


def sec_perm_key_cached(user):
    return ("perm", user["user_id"]) in _PERM_CACHE


def sec_user_permissions(user):
    from .security import user_permissions
    user_permissions(user)

CUSTOM_MENU = [
    ("d", "Dashboard", "/", "dashboard", "fa-gauge-high", "Top"),
    ("users", "Users", "/users", "acl", "fa-users", "Administration"),
    ("roles", "Roles", "/roles", "acl", "fa-user-shield", "Administration"),
    ("permissions", "Permissions", "/permissions", "acl", "fa-key", "Administration"),
    ("audit-log", "Audit Log", "/audit-log", "audit", "fa-clipboard-list", "Records"),
]

GROUP_META = [
    ("Top", "fa-house", 0),
    ("Item Info", "fa-boxes-stacked", 1),
    ("Distributor Info", "fa-truck-ramp-box", 2),
    ("Outlet Info", "fa-shop", 3),
    ("Settings", "fa-cogs", 4),
    ("Administration", "fa-gear", 5),
    ("Records", "fa-clock-rotate-left", 6),
]


def ctx(request: Request, user=None):
    """Base dict handed to every template."""
    if user is None:
        user = current_user(request)
    return {
        "request": request,
        "user": user,
        "menu": build_menu(user),
        "flash": pop_flash(request),
        "path": request.url.path,
        "app_name": config.APP_NAME,
        "app_full_name": config.APP_FULL_NAME,
        "version": config.VERSION,
    }


def current_user(request: Request):
    if getattr(request.state, "user", None):
        return request.state.user
    uid = request.session.get("uid")
    if not uid:
        return None
    user = q("SELECT * FROM sm_acl_user WHERE cid=%s AND user_id=%s AND status='ACTIVE'",
             (config.CID, uid), one=True)
    request.state.user = user
    if user is not None and not sec_perm_key_cached(user):
        sec_user_permissions(user)   # prime ACL permission cache once per login
    return user


def authenticate(request: Request, user_id: str, password: str):
    user = q("SELECT * FROM sm_acl_user WHERE cid=%s AND user_id=%s",
             (config.CID, user_id.strip()), one=True)
    if not user or user["status"] != "ACTIVE":
        return None, "User not found or inactive."
    if not verify_password(password, user["password_hash"] or ""):
        return None, "Incorrect password."
    request.session["uid"] = user["user_id"]
    request.session["uname"] = user["name"] or user["user_id"]
    log_change(config.CID, "sm_acl_user", user["user_id"], "LOGIN", user_ip=client_ip(request))
    return user, None


def logout(request: Request, user):
    if user:
        log_change(config.CID, "sm_acl_user", user["user_id"], "LOGOUT", user_ip=client_ip(request))
    request.session.pop("uid", None)
    request.session.pop("uname", None)


def client_ip(request: Request):
    fwd = request.headers.get("x-forwarded-for")
    return (fwd.split(",")[0].strip() if fwd else None) or request.client.host if request.client else "localhost"


def build_menu(user):
    """Menu groups filtered by the user's permissions."""
    groups = {title: {"title": title, "icon": icon, "order": order, "entries": []}
              for title, icon, order in GROUP_META}
    # dashboard
    if user and (has_perm(user, "dashboard.view") or int(user.get("is_super") or 0)):
        groups["Top"]["entries"].append(
            {"title": "Dashboard", "url": "/", "icon": "fa-gauge-high", "key": "dashboard"})
    # master modules
    for slug in ("brand", "item", "item-batch", "distributor", "distributor-store",
                 "outlet", "category-type"):
        m = MODULES.get(slug)
        if not m:
            continue
        if user and (has_perm(user, f"{m['perm']}.view") or int(user.get("is_super") or 0)):
            target_group = m["group"]
            if target_group not in groups:
                target_group = "Settings"
            groups[target_group]["entries"].append(
                {"title": m["title"], "url": f"/{slug}", "icon": m["icon"], "key": slug})
    # custom admin/records entries
    for _key, title, url, perm, icon, group in CUSTOM_MENU:
        if _key == "d":
            continue
        if user and (has_perm(user, f"{perm}.view") or int(user.get("is_super") or 0)):
            groups[group]["entries"].append({"title": title, "url": url, "icon": icon, "key": _key})
    out = [g for g in sorted(groups.values(), key=lambda g: g["order"]) if g["entries"]]
    return out


def set_flash(request: Request, category: str, text: str):
    request.session["flash"] = [category, text]


def pop_flash(request: Request):
    fl = request.session.pop("flash", None)
    return fl


def require_user(request: Request):
    user = current_user(request)
    if not user:
        return None
    return user


def require_perm(user, perm: str):
    """Return True when user may act; callers decide response."""
    return bool(user and (int(user.get("is_super") or 0) or has_perm(user, perm)))
