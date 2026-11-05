"""Password hashing + ACL permission resolution for SSMS."""
import hashlib
import os

from .database import q

_PERM_CACHE = {}


def hash_password(password: str) -> str:
    salt = os.urandom(16)
    digest = hashlib.pbkdf2_hmac("sha256", password.encode("utf-8"), salt, 120_000)
    return f"pbkdf2${salt.hex()}${digest.hex()}"


def verify_password(password: str, stored: str) -> bool:
    try:
        _algo, salt_hex, digest_hex = stored.split("$")
        digest = hashlib.pbkdf2_hmac("sha256", password.encode("utf-8"),
                                     bytes.fromhex(salt_hex), 120_000)
        return digest.hex() == digest_hex
    except Exception:
        return False


def get_user_by_login(user_id: str):
    return q("SELECT * FROM sm_acl_user WHERE cid='SMART' AND user_id=%s AND status='ACTIVE'",
             (user_id,), one=True)


def user_roles(user_id: str):
    return q("""SELECT r.role_id, r.role_name FROM sm_acl_user_role ur
                JOIN sm_acl_role r ON r.cid=ur.cid AND r.role_id=ur.role_id AND r.status='ACTIVE'
                WHERE ur.cid='SMART' AND ur.user_id=%s ORDER BY r.role_id""", (user_id,))


def user_permissions(user):
    """Return (set_of_perm_ids, is_super, roles). Cached per login session."""
    cache_key = ("perm", user["user_id"])
    if cache_key in _PERM_CACHE:
        return _PERM_CACHE[cache_key]
    perms = set()
    for r in user_roles(user["user_id"]):
        for row in q("SELECT perm_id FROM sm_acl_role_permission WHERE cid='SMART' AND role_id=%s",
                     (r["role_id"],)):
            perms.add(row["perm_id"])
    for row in q("""SELECT p.perm_id FROM sm_acl_user_permission up
                    JOIN sm_acl_permission p ON p.cid=up.cid AND p.perm_id=up.perm_id AND p.status='ACTIVE'
                    WHERE up.cid='SMART' AND up.user_id=%s""", (user["user_id"],)):
        perms.add(row["perm_id"])
    is_super = int(user.get("is_super") or 0) == 1
    result = (perms, is_super)
    _PERM_CACHE[cache_key] = result
    return result


def perm_key_cached(user):
    return _PERM_CACHE.get(("perm", user["user_id"]), (set(), False))


def invalidate_user_cache(user_id: str | None = None):
    if user_id is None:
        _PERM_CACHE.clear()
    else:
        _PERM_CACHE.pop(("perm", user_id), None)


def has_perm(user, perm: str) -> bool:
    perms, is_super = perm_key_cached(user)
    return is_super or perm in perms or "*.*" in perms or f"{perm.split('.')[0]}.*" in perms
