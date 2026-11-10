"""Create the smart_27 database (schema + seed data).

Run:  ./venv/Scripts/python scripts/setup_database.py
Also used automatically by the FastAPI app at startup if tables are missing.
"""
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

import pymysql

from app import config

DDL_FILE = Path(__file__).with_name("ddl.sql")

SEED_PERMISSIONS = [
    # (perm_id, perm_name, module)
    ("dashboard.view", "View dashboard", "dashboard"),
    ("brand.view", "View item hierarchy (brand)", "brand"),
    ("brand.create", "Create item hierarchy (brand)", "brand"),
    ("brand.edit", "Edit item hierarchy (brand)", "brand"),
    ("brand.delete", "Soft delete item hierarchy (brand)", "brand"),
    ("brand.import", "Excel upload item hierarchy (brand)", "brand"),
    ("item.view", "View items", "item"),
    ("item.create", "Create items", "item"),
    ("item.edit", "Edit items", "item"),
    ("item.delete", "Soft delete items", "item"),
    ("item.import", "Excel upload items", "item"),
    ("item_batch.view", "View item batches", "item_batch"),
    ("item_batch.create", "Create item batches", "item_batch"),
    ("item_batch.edit", "Edit item batches", "item_batch"),
    ("item_batch.delete", "Soft delete item batches", "item_batch"),
    ("item_batch.import", "Excel upload item batches", "item_batch"),
    ("distributor.view", "View distributors", "distributor"),
    ("distributor.create", "Create distributors", "distributor"),
    ("distributor.edit", "Edit distributors", "distributor"),
    ("distributor.delete", "Soft delete distributors", "distributor"),
    ("distributor.import", "Excel upload distributors", "distributor"),
    ("depot_store.view", "View distributor stores", "depot_store"),
    ("depot_store.create", "Create distributor stores", "depot_store"),
    ("depot_store.edit", "Edit distributor stores", "depot_store"),
    ("depot_store.delete", "Soft delete distributor stores", "depot_store"),
    ("depot_store.import", "Excel upload distributor stores", "depot_store"),
    ("outlet.view", "View outlets", "outlet"),
    ("outlet.create", "Create outlets", "outlet"),
    ("outlet.edit", "Edit outlets", "outlet"),
    ("outlet.delete", "Soft delete outlets", "outlet"),
    ("outlet.import", "Excel upload outlets", "outlet"),
    ("category_type.view", "View category types", "category_type"),
    ("category_type.create", "Create category types", "category_type"),
    ("category_type.edit", "Edit category types", "category_type"),
    ("category_type.delete", "Soft delete category types", "category_type"),
    ("category_type.import", "Excel upload category types", "category_type"),
    ("acl.view", "View access control", "acl"),
    ("acl.manage", "Manage users, roles and permissions", "acl"),
    ("audit.view", "View central audit log", "audit"),
]

SEED_ROLES = [
    ("SUPER_ADMIN", "Super Administrator", "Full access to every module"),
    ("MANAGER", "Sales Manager", "Manage items, batches and distributors"),
    ("VIEWER", "Read Only", "View only access to master data"),
]

SEED_USER = ("admin", "Administrator", "admin@ssms.local", config.DEFAULT_ADMIN_PASSWORD, 1)

SEED_CATEGORY_TYPES = [
    # type_name, cat_type_id, cat_type_name
    ("DISTRIBUTOR_CATEGORY", "DISTRIBUTOR", "Distributor"),
    ("DISTRIBUTOR_CATEGORY", "SUP DISTRIBUTOR", "Sup Distributor"),
    ("STORE_TYPE", "COMMERCIAL", "Commercial"),
    ("STORE_TYPE", "DAMAGE", "Damage"),
    ("ITEM_CATEGORY", "REGULAR", "Regular"),
    ("ITEM_CATEGORY", "SPECIAL", "Special"),
    ("ITEM_CATEGORY", "FOCUS", "Focus"),
    ("ITEM_UNIT", "PCS", "Pieces"),
    ("ITEM_UNIT", "KG", "Kilogram"),
    ("ITEM_UNIT", "LTR", "Litre"),
    ("ITEM_UNIT", "BOX", "Box"),
    ("ITEM_UNIT", "PACK", "Pack"),
    ("ITEM_PACK", "SMALL", "Small"),
    ("ITEM_PACK", "MEDIUM", "Medium"),
    ("ITEM_PACK", "LARGE", "Large"),
    ("OUTLET_CATEGORY", "OC001", "KR0"),
    ("OUTLET_SUB_CATEGORY", "OSC001", "KR0-1"),
]

SEED_HIERARCHY = [
    # level_id, level_name, parent_level_id
    ("CG001", "TCPL Products", "0"),
    ("BG001", "Kurkure", "CG001"),
    ("TG001", "Collet", "BG001"),
    ("FG001", "American Style Cream & Onion", "TG001"),
    ("FG002", "Masala Munch", "TG001"),
]

ROLE_PERM_MATRIX = {
    "SUPER_ADMIN": None,  # None => every permission (is_super also set)
    "MANAGER": [p[0] for p in SEED_PERMISSIONS if p[2] in
                ("dashboard", "brand", "item", "item_batch", "distributor",
                 "depot_store", "outlet", "category_type", "audit") and p[0].split(".")[-1] != "import"],
    "VIEWER": [p[0] for p in SEED_PERMISSIONS if p[0].endswith(".view")],
}


def ensure_database():
    conn = pymysql.connect(host=config.DB_HOST, port=config.DB_PORT,
                           user=config.DB_USER, password=config.DB_PASS or None,
                           charset="utf8mb4", autocommit=True)
    try:
        with conn.cursor() as cur:
            cur.execute(
                f"CREATE DATABASE IF NOT EXISTS `{config.DB_NAME}` "
                f"DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci")
        conn.select_db(config.DB_NAME)
        sql = DDL_FILE.read_text(encoding="utf-8")
        for stmt in [s.strip() for s in sql.split(";") if s.strip()]:
            with conn.cursor() as cur:
                cur.execute(stmt)
    finally:
        conn.close()


def is_empty(table):
    try:
        from app.database import q
        row = q(f"SELECT 1 AS x FROM `{table}` LIMIT 1", one=True)
        return not row
    except Exception:
        return True


def seed():
    from app.database import q, x
    from app.security import hash_password

    now = "NOW()"
    cid = config.CID

    # ---- permissions (idempotent per row: new module permissions such as
    # outlet.* reach already-seeded databases on re-run)
    for pid, pname, module in SEED_PERMISSIONS:
        if not q("SELECT id FROM sm_acl_permission WHERE cid=%s AND perm_id=%s",
                 (cid, pid), one=True):
            x("INSERT INTO sm_acl_permission (cid, perm_id, perm_name, module, status, created_on, created_by)"
              f" VALUES (%s,%s,%s,%s,'ACTIVE',{now},'SYSTEM')", (cid, pid, pname, module))

    # ---- roles
    if is_empty("sm_acl_role"):
        for rid, rname, rnote in SEED_ROLES:
            x("INSERT INTO sm_acl_role (cid, role_id, role_name, status, note, created_on, created_by)"
              f" VALUES (%s,%s,%s,'ACTIVE',%s,{now},'SYSTEM')", (cid, rid, rname, rnote))

    # ---- role permissions
    if is_empty("sm_acl_role_permission"):
        for rid, _rname, _rnote in SEED_ROLES:
            perms = ROLE_PERM_MATRIX.get(rid) or [p[0] for p in SEED_PERMISSIONS]
            for pid in perms:
                x("INSERT INTO sm_acl_role_permission (cid, role_id, perm_id, created_on, created_by)"
                  f" VALUES (%s,%s,%s,{now},'SYSTEM')", (cid, rid, pid))

    # ---- default super admin
    if is_empty("sm_acl_user"):
        uid, uname, uemail, upass, is_super = SEED_USER
        x("INSERT INTO sm_acl_user (cid, user_id, name, email, password_hash, is_super, status, created_on, created_by)"
          f" VALUES (%s,%s,%s,%s,%s,%s,'ACTIVE',{now},'SYSTEM')",
          (cid, uid, uname, uemail, hash_password(upass), is_super))
        x("INSERT INTO sm_acl_user_role (cid, user_id, role_id, created_on, created_by)"
          f" VALUES (%s,%s,'SUPER_ADMIN',{now},'SYSTEM')", (cid, uid))

    # ---- category types (idempotent per row: adds missing value definitions
    # even when the table already has data, so new groups reach existing DBs)
    for tname, ctid, ctname in SEED_CATEGORY_TYPES:
        if not q("SELECT id FROM sm_category_type WHERE cid=%s AND type_name=%s AND cat_type_id=%s",
                 (cid, tname, ctid), one=True):
            x("INSERT INTO sm_category_type (cid, type_name, cat_type_id, cat_type_name, status, created_on, created_by)"
              f" VALUES (%s,%s,%s,%s,'ACTIVE',{now},'SYSTEM')", (cid, tname, ctid, ctname))

    # ---- sample item hierarchy (TCPL example from requirements)
    if is_empty("sm_item_hierarchy"):
        names = {lid: (lid, lname, plid) for lid, lname, plid in SEED_HIERARCHY}

        def path_of(lid):
            """Return [(level0, name), (level1, name), ...] incl. self, root first."""
            chain = []
            cur_id = lid
            while cur_id and cur_id != "0":
                lid_, lname_, plid_ = names[cur_id]
                chain.append((lid_, lname_))
                cur_id = plid_
            chain.reverse()
            return chain

        for lid, lname, plid in SEED_HIERARCHY:
            chain = path_of(lid)
            depth = len(chain) - 1
            lvl = {}
            for i in range(4):
                if i < len(chain):
                    lvl[f"level{i}"], lvl[f"level{i}_name"] = chain[i]
                else:
                    lvl[f"level{i}"], lvl[f"level{i}_name"] = "", ""
            is_leaf = "1" if len(chain) == 4 else "0"
            parent_name = "-" if plid == "0" else names[plid][1]
            x("""INSERT INTO sm_item_hierarchy
                 (cid, level_id, level_name, parent_level_id, parent_level_name,
                  level0, level0_name, level1, level1_name, level2, level2_name,
                  level3, level3_name, is_leaf, depth, status, created_on, created_by)
               VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,'ACTIVE',NOW(),'SYSTEM')""",
              (cid, lid, lname, plid, parent_name,
               lvl["level0"], lvl["level0_name"],
               lvl["level1"], lvl["level1_name"],
               lvl["level2"], lvl["level2_name"],
               lvl["level3"], lvl["level3_name"],
               is_leaf, depth))
        # parents that got a child are no longer leaf
        for _lid, _lname, plid in SEED_HIERARCHY:
            if plid != "0":
                x("UPDATE sm_item_hierarchy SET is_leaf='0' WHERE cid=%s AND level_id=%s",
                  (cid, plid))


def main():
    print(f"Ensuring database `{config.DB_NAME}` at {config.DB_HOST}:{config.DB_PORT} ...")
    ensure_database()
    print("Schema created/verified (scripts/ddl.sql).")
    print("Seeding ACL, category types and sample hierarchy ...")
    seed()
    print("Done. Default login -> user id: admin  password: admin123")


if __name__ == "__main__":
    main()
