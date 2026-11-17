"""Business-rule hooks for SSMS modules (invoked by the generic CRUD router)."""
import hashlib

from . import config
from .database import q, x, scalar

MAX_DEPTH = 3  # company(0) > brand(1) > type(2) > flavor(3)
LEVEL_PREFIX = {0: "MG", 1: "BG", 2: "CG", 3: "FG"}

TOP_LEVEL_PREFIX = {0: "H", 1: "A", 2: "Z", 3: "T"}
FIELD_LEVEL_PREFIX = {0: "T", 1: "TW", 2: "R", 3: "B"}

NEXT_DAY = {
    "Saturday": "Sunday", "Sunday": "Monday", "Monday": "Tuesday",
    "Tuesday": "Wednesday", "Wednesday": "Thursday", "Thursday": "Friday",
    "Friday": "Saturday",
}


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
    if existing is not None:
        data["item_id"] = existing["item_id"]
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
            data["total_amt"] = round(float(data.get("price") or 0) + float(data.get("vat_amt") or 0), 4)
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
    item's own status.
    Auto-provisions sm_depot_stock_balance rows across all stores with qty 0."""
    user = user or "SYSTEM"
    x("""INSERT INTO sm_item_batch
         (cid, item_id, name, batch_id, expiary_date, status, note, created_on, created_by)
         VALUES (%s,%s,%s,'1','2100-12-31',%s,'Default batch (auto)',NOW(),%s)
         ON DUPLICATE KEY UPDATE name=VALUES(name)""",
      (cid, row["item_id"], row["name"], (row.get("status") or "ACTIVE"), user))
    # Auto-provision stock rows across all stores
    stores = q("SELECT depot_id, store_id, store_name FROM sm_depot_store WHERE cid=%s", (cid,))
    for st in stores:
        x("""INSERT IGNORE INTO sm_depot_stock_balance
             (cid, depot_id, store_id, store_name, item_id, batch_id, expiary_date, quantity, block_qty, created_on, created_by)
             VALUES (%s,%s,%s,%s,%s,'1','2100-12-31',0,0,NOW(),%s)""",
          (cid, st["depot_id"], st["store_id"], st.get("store_name", "-"), row["item_id"], user))


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
    if existing is not None:
        data["item_id"] = existing["item_id"]
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


# ----------------------------------------------------------------- rack
def rack_prepare(cid, data, existing=None, user=None):
    if existing is not None:
        data["rack_id"] = existing["rack_id"]
    rack_id = (data.get("rack_id") or "").strip()
    rack_name = (data.get("rack_name") or "").strip()
    if not rack_id or not rack_name:
        return "Rack ID and Rack Name are required."
    dup_sql = "SELECT id FROM sm_rack WHERE cid=%s AND rack_id=%s"
    dup_params = [cid, rack_id]
    if existing is not None:
        dup_sql += " AND id<>%s"
        dup_params.append(existing["id"])
    if q(dup_sql, dup_params, one=True):
        return "A rack with this Rack ID already exists."
    return None


# ----------------------------------------------------------------- depot
def depot_prepare(cid, data, existing=None, user=None):
    if existing is not None:
        data["depot_id"] = existing["depot_id"]
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
    town_name = (data.get("town_name") or "").strip()
    town_id = (data.get("town_id") or "").strip()
    lookup = town_name if (town_name and town_name != "-") else town_id
    if lookup and lookup != "-":
        town_row = q("SELECT level_id, level_name FROM sm_level WHERE cid=%s AND depth=1 AND (level_name=%s OR level_id=%s) LIMIT 1",
                     (cid, lookup, lookup), one=True)
        if town_row:
            data["town_id"] = town_row["level_id"]
            data["town_name"] = town_row["level_name"]
        else:
            data["town_id"] = town_id or "-"
            data["town_name"] = town_name or "-"
    else:
        data["town_id"] = "-"
        data["town_name"] = "-"
    return None


def _cascade_depot_status(cid, depot_id, status, user=None):
    """A distributor's status is always reflected on its stores: whatever status
    the distributor carries (INACTIVE/PENDING/REJECTED/...) is pushed to every store row."""
    if not depot_id or not status:
        return
    x("""UPDATE sm_depot_store SET status=%s, updated_on=NOW(), updated_by=%s
         WHERE cid=%s AND depot_id=%s AND status<>%s""",
      (status, user or "SYSTEM", cid, depot_id, status))


def depot_after_update(cid, old, new, user=None):
    if (old.get("status") or "") != (new.get("status") or ""):
        _cascade_depot_status(cid, new.get("depot_id"), new.get("status"), user)


def depot_soft_delete(cid, rid, user=None):
    row = q("SELECT * FROM sm_depot WHERE cid=%s AND id=%s", (cid, rid), one=True)
    if not row:
        return None, "Record not found."
    _, n = x("UPDATE sm_depot SET status='PENDING', updated_on=NOW(), updated_by=%s "
             "WHERE cid=%s AND id=%s AND status<>'PENDING'", (user, cid, rid))
    if n:
        _cascade_depot_status(cid, row["depot_id"], "PENDING", user)
    return n, None


def depot_restore(cid, rid, user=None):
    row = q("SELECT * FROM sm_depot WHERE cid=%s AND id=%s", (cid, rid), one=True)
    if not row:
        return None, "Record not found."
    _, n = x("UPDATE sm_depot SET status='ACTIVE', updated_on=NOW(), updated_by=%s "
             "WHERE cid=%s AND id=%s AND status<>'ACTIVE'", (user, cid, rid))
    if n:
        _cascade_depot_status(cid, row["depot_id"], "ACTIVE", user)
    return n, None


def depot_after_create(cid, row, user=None):
    """Every distributor automatically gets two default stores:
       {depot_id}140 -> Commercial, {depot_id}170 -> Damage (per requirements).
       Auto-provisions sm_depot_stock_balance rows across default stores * all items with qty 0."""
    user = user or "SYSTEM"
    pairs = [(f"{row['depot_id']}140", "Commercial", "COMMERCIAL"),
             (f"{row['depot_id']}170", "Damage", "DAMAGE")]
    for store_id, store_name, store_type in pairs:
        x("""INSERT INTO sm_depot_store
             (cid, depot_id, store_id, store_name, store_type, status, note, created_on, created_by)
             VALUES (%s,%s,%s,%s,%s,'ACTIVE','Default store (auto)',NOW(),%s)
             ON DUPLICATE KEY UPDATE store_name=VALUES(store_name)""",
          (cid, row["depot_id"], store_id, store_name[:100], store_type, user))
    # Auto-provision stock rows across default stores * all items
    items = q("SELECT item_id FROM sm_item WHERE cid=%s", (cid,))
    for store_id, store_name, _ in pairs:
        for it in items:
            x("""INSERT IGNORE INTO sm_depot_stock_balance
                 (cid, depot_id, store_id, store_name, item_id, batch_id, expiary_date, quantity, block_qty, created_on, created_by)
                 VALUES (%s,%s,%s,%s,%s,'1','2100-12-31',0,0,NOW(),%s)""",
              (cid, row["depot_id"], store_id, store_name, it["item_id"], user))


# ----------------------------------------------------------------- store
def depot_store_prepare(cid, data, existing=None, user=None):
    if existing is not None:
        data["depot_id"] = existing["depot_id"]
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


def depot_store_after_create(cid, row, user=None):
    """When a new distributor store is created, auto-provisions sm_depot_stock_balance
    rows for that store * all items with quantity 0, block_qty 0."""
    user = user or "SYSTEM"
    items = q("SELECT item_id FROM sm_item WHERE cid=%s", (cid,))
    for it in items:
        x("""INSERT IGNORE INTO sm_depot_stock_balance
             (cid, depot_id, store_id, store_name, item_id, batch_id, expiary_date, quantity, block_qty, created_on, created_by)
             VALUES (%s,%s,%s,%s,%s,'1','2100-12-31',0,0,NOW(),%s)""",
          (cid, row["depot_id"], row["store_id"], row.get("store_name", "-"), it["item_id"], user))


# ----------------------------------------------------------------- stock balance
def depot_stock_balance_prepare(cid, data, existing=None, user=None):
    depot_id = (data.get("depot_id") or "").strip()
    store_id = (data.get("store_id") or "").strip()
    item_id = (data.get("item_id") or "").strip()
    batch_id = (data.get("batch_id") or "").strip()
    if not depot_id or not store_id or not item_id or not batch_id:
        return "Distributor, Store, Item and Batch ID are required."

    depot = q("SELECT id FROM sm_depot WHERE cid=%s AND depot_id=%s", (cid, depot_id), one=True)
    if not depot:
        return f"Distributor '{depot_id}' not found."

    store = q("SELECT id, store_name FROM sm_depot_store WHERE cid=%s AND depot_id=%s AND store_id=%s",
              (cid, depot_id, store_id), one=True)
    if not store:
        return f"Store '{store_id}' not found for distributor '{depot_id}'."
    if not (data.get("store_name") or "").strip() or data.get("store_name") == "-":
        data["store_name"] = store["store_name"] or "-"

    item = q("SELECT id FROM sm_item WHERE cid=%s AND item_id=%s", (cid, item_id), one=True)
    if not item:
        return f"Item '{item_id}' not found."

    batch = q("SELECT id, expiary_date FROM sm_item_batch WHERE cid=%s AND item_id=%s AND batch_id=%s",
              (cid, item_id, batch_id), one=True)
    if not batch:
        return f"Batch '{batch_id}' not found for item '{item_id}'."
    if not (data.get("expiary_date") or "").strip():
        data["expiary_date"] = str(batch["expiary_date"]) if batch["expiary_date"] else "2100-12-31"

    try:
        data["quantity"] = max(0, int(data.get("quantity") or 0))
    except (TypeError, ValueError):
        data["quantity"] = 0
    try:
        data["block_qty"] = max(0, int(data.get("block_qty") or 0))
    except (TypeError, ValueError):
        data["block_qty"] = 0

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


# ------------------------------------------------------------- top_level (National Structure)
def _next_top_level_code(cid, prefix):
    rows = q("SELECT level_id FROM sm_top_level WHERE cid=%s AND level_id LIKE %s",
             (cid, prefix + "%"))
    max_no = 0
    for r in rows:
        tail = (r["level_id"] or "")[len(prefix):]
        if tail.isdigit():
            max_no = max(max_no, int(tail))
    return f"{prefix}{max_no + 1:04d}"


def top_level_prepare(cid, data, existing=None, user=None):
    name = (data.get("level_name") or "").strip()
    if not name:
        return "Level name is required."

    if existing is not None:
        data["level_name"] = name
        dup = q("""SELECT id FROM sm_top_level
                   WHERE cid=%s AND status='ACTIVE' AND level_name=%s
                     AND parent_level_id=%s AND id<>%s LIMIT 1""",
                (cid, name, existing.get("parent_level_id") or "0", existing["id"]), one=True)
        if dup:
            return "A national level with this name already exists under the same parent."
        return None

    parent_id = (data.get("parent_level_id") or "0").strip() or "0"
    if parent_id == "0":
        parent = None
        depth = 0
    else:
        parent = q("SELECT * FROM sm_top_level WHERE cid=%s AND level_id=%s",
                   (cid, parent_id), one=True)
        if not parent or parent["status"] != "ACTIVE":
            return "Parent level not found or inactive."
        depth = int(parent["depth"] or 0) + 1
        if depth > 3:
            return "Cannot create a level below 'Territory' (depth 3) in National Structure."

    dup = q(f"""SELECT id FROM sm_top_level
                WHERE cid=%s AND status='ACTIVE' AND level_name=%s
                  {"AND parent_level_id=%s" if parent else "AND parent_level_id='0'"}
                LIMIT 1""",
            (cid, name) + ((parent_id,) if parent else ()), one=True)
    if dup:
        return "A national level with this name already exists under the same parent."

    prefix = TOP_LEVEL_PREFIX[depth]
    code = _next_top_level_code(cid, prefix)
    data["level_id"] = code
    data["depth"] = depth
    data["is_leaf"] = "1"
    data["parent_level_id"] = parent_id
    data["parent_level_name"] = (parent["level_name"] if parent else "-") or "-"
    for i in range(4):
        if i < depth and parent:
            data[f"level{i}"] = parent.get(f"level{i}") or ""
            data[f"level{i}_name"] = parent.get(f"level{i}_name") or ""
        elif i == depth:
            data[f"level{i}"] = code
            data[f"level{i}_name"] = name
        else:
            data[f"level{i}"] = "-"
            data[f"level{i}_name"] = "-"
    data["status"] = "ACTIVE"
    return None


def _recompute_top_level_is_leaf(cid, level_id):
    if not level_id or level_id == "0":
        return
    n = scalar("SELECT COUNT(*) c FROM sm_top_level "
               "WHERE cid=%s AND parent_level_id=%s AND status='ACTIVE'",
               (cid, level_id), 0)
    x("UPDATE sm_top_level SET is_leaf=%s WHERE cid=%s AND level_id=%s",
      ("0" if n else "1", cid, level_id))


def top_level_after_create(cid, row, user=None):
    _recompute_top_level_is_leaf(cid, row.get("parent_level_id"))


def top_level_after_update(cid, old, new, user=None):
    if (old.get("level_name") or "") != (new.get("level_name") or ""):
        x("UPDATE sm_top_level SET parent_level_name=%s WHERE cid=%s AND parent_level_id=%s",
          (new["level_name"], cid, new["level_id"]))
        depth = int(new.get("depth") or 0)
        x(f"UPDATE sm_top_level SET level{depth}_name=%s WHERE cid=%s AND level{depth}=%s",
          (new["level_name"], cid, new["level_id"]))
    _recompute_top_level_is_leaf(cid, new.get("level_id"))
    _recompute_top_level_is_leaf(cid, new.get("parent_level_id"))


def top_level_soft_delete(cid, rid, user=None):
    row = q("SELECT * FROM sm_top_level WHERE cid=%s AND id=%s", (cid, rid), one=True)
    if not row:
        return None, "Record not found."
    nchild = scalar("SELECT COUNT(*) c FROM sm_top_level WHERE cid=%s AND parent_level_id=%s AND status='ACTIVE'",
                    (cid, row["level_id"]), 0)
    if nchild:
        return None, (f"Cannot delete '{row['level_name']}' ({row['level_id']}) — it has "
                      f"{nchild} active child level(s). Delete the child levels first.")
    _, n = x("UPDATE sm_top_level SET status='PENDING', updated_on=NOW(), updated_by=%s "
             "WHERE cid=%s AND id=%s AND status='ACTIVE'", (user, cid, rid))
    _recompute_top_level_is_leaf(cid, row.get("parent_level_id"))
    return n, None


def top_level_restore(cid, rid, user=None):
    row = q("SELECT * FROM sm_top_level WHERE cid=%s AND id=%s", (cid, rid), one=True)
    if not row:
        return None, "Record not found."
    pid = row.get("parent_level_id")
    if pid and pid != "0":
        parent = q("SELECT status FROM sm_top_level WHERE cid=%s AND level_id=%s",
                   (cid, pid), one=True)
        if not parent or parent["status"] != "ACTIVE":
            return None, f"Cannot restore — parent level '{pid}' is not ACTIVE."
    _, n = x("UPDATE sm_top_level SET status='ACTIVE', updated_on=NOW(), updated_by=%s "
             "WHERE cid=%s AND id=%s", (user, cid, rid))
    _recompute_top_level_is_leaf(cid, pid)
    return n, None


# ------------------------------------------------------------- level (Field Structure)
def _next_field_level_code(cid, prefix):
    rows = q("SELECT level_id FROM sm_level WHERE cid=%s AND level_id LIKE %s",
             (cid, prefix + "%"))
    max_no = 0
    for r in rows:
        tail = (r["level_id"] or "")[len(prefix):]
        if tail.isdigit():
            max_no = max(max_no, int(tail))
    pad = 7 if prefix in ("R", "B") else 4
    return f"{prefix}{max_no + 1:0{pad}d}"


def level_prepare(cid, data, existing=None, user=None):
    name = (data.get("level_name") or "").strip()
    if not name:
        return "Level name is required."

    # Parse potential "ID | Name" format if passed from dropdown/datalist
    clean_name = name
    if " | " in clean_name:
        clean_name = clean_name.split(" | ", 1)[1].strip()

    if existing is not None:
        depth = int(existing.get("depth") or 0)
        if depth == 0:
            # Editing Territory root: sync with sm_top_level depth 3, parent zone from sm_top_level depth 2
            zone_id = (data.get("parent_level_id") or "").strip()
            zone = None
            if zone_id and zone_id != "0":
                zone = q("SELECT level_id, level_name FROM sm_top_level WHERE cid=%s AND depth=2 AND status='ACTIVE' AND level_id=%s",
                         (cid, zone_id), one=True)
            if zone:
                terr = q("""SELECT level_id, level_name, parent_level_id, parent_level_name
                            FROM sm_top_level
                            WHERE cid=%s AND depth=3 AND status='ACTIVE' AND parent_level_id=%s
                              AND (level_id=%s OR level_name=%s OR level_id=%s OR level_name=%s)
                            LIMIT 1""",
                         (cid, zone["level_id"], name, name, clean_name, clean_name), one=True)
                if not terr:
                    return f"Territory '{clean_name}' does not belong to Zone '{zone['level_name']}' ({zone['level_id']})."
            else:
                terr = q("""SELECT level_id, level_name, parent_level_id, parent_level_name
                            FROM sm_top_level
                            WHERE cid=%s AND depth=3 AND status='ACTIVE'
                              AND (level_id=%s OR level_name=%s OR level_id=%s OR level_name=%s)
                            LIMIT 1""",
                         (cid, name, name, clean_name, clean_name), one=True)
            if terr:
                data["level_id"] = terr["level_id"]
                data["level_name"] = terr["level_name"]
                data["parent_level_id"] = zone["level_id"] if zone else terr["parent_level_id"]
                data["parent_level_name"] = zone["level_name"] if zone else terr["parent_level_name"]
                data["level0"] = terr["level_id"]
                data["level0_name"] = terr["level_name"]
            else:
                data["level_name"] = name
                if zone:
                    data["parent_level_id"] = zone["level_id"]
                    data["parent_level_name"] = zone["level_name"]
            data["depot_id"] = "-"
            data["depot_name"] = "-"
            dup = q("""SELECT id FROM sm_level
                       WHERE cid=%s AND status='ACTIVE' AND (level_id=%s OR level_name=%s)
                         AND id<>%s LIMIT 1""",
                    (cid, data.get("level_id", existing["level_id"]), data["level_name"], existing["id"]), one=True)
            if dup:
                return f"A field territory with this code or name already exists: {data['level_name']}."
            return None
        elif depth == 1:
            # Editing Town: distributor tagging is active
            data["level_name"] = name
            dup = q("""SELECT id FROM sm_level
                       WHERE cid=%s AND status='ACTIVE' AND level_name=%s
                         AND parent_level_id=%s AND id<>%s LIMIT 1""",
                    (cid, name, existing.get("parent_level_id") or "0", existing["id"]), one=True)
            if dup:
                return "A field level with this name already exists under the same parent."
            depot_id = (data.get("depot_id") or "").strip()
            if depot_id and depot_id != "-":
                depot = q("SELECT name FROM sm_depot WHERE cid=%s AND depot_id=%s", (cid, depot_id), one=True)
                data["depot_id"] = depot_id
                data["depot_name"] = (depot["name"] if depot else "-") or "-"
            else:
                data["depot_id"] = "-"
                data["depot_name"] = "-"
            return None
        else:
            # Editing Route (depth 2) or Beat (depth 3): keep inherited distributor
            data["level_name"] = name
            dup = q("""SELECT id FROM sm_level
                       WHERE cid=%s AND status='ACTIVE' AND level_name=%s
                         AND parent_level_id=%s AND id<>%s LIMIT 1""",
                    (cid, name, existing.get("parent_level_id") or "0", existing["id"]), one=True)
            if dup:
                return "A field level with this name already exists under the same parent."
            if not data.get("depot_id") or data.get("depot_id") == "-":
                data["depot_id"] = existing.get("depot_id") or "-"
                data["depot_name"] = existing.get("depot_name") or "-"
            return None

    # CREATE MODE
    parent_id = (data.get("parent_level_id") or "0").strip() or "0"
    zone = None
    if parent_id != "0":
        zone = q("SELECT level_id, level_name FROM sm_top_level WHERE cid=%s AND depth=2 AND status='ACTIVE' AND level_id=%s",
                 (cid, parent_id), one=True)

    if parent_id == "0" or zone:
        parent = None
        depth = 0
        if zone:
            terr = q("""SELECT level_id, level_name, parent_level_id, parent_level_name
                        FROM sm_top_level
                        WHERE cid=%s AND depth=3 AND status='ACTIVE' AND parent_level_id=%s
                          AND (level_id=%s OR level_name=%s OR level_id=%s OR level_name=%s)
                        LIMIT 1""",
                     (cid, zone["level_id"], name, name, clean_name, clean_name), one=True)
            if not terr:
                return f"Selected Territory '{clean_name}' does not belong to Zone '{zone['level_name']}' ({zone['level_id']})."
        else:
            terr = q("""SELECT level_id, level_name, parent_level_id, parent_level_name
                        FROM sm_top_level
                        WHERE cid=%s AND depth=3 AND status='ACTIVE'
                          AND (level_id=%s OR level_name=%s OR level_id=%s OR level_name=%s)
                        LIMIT 1""",
                     (cid, name, name, clean_name, clean_name), one=True)
        if terr:
            code = terr["level_id"]
            name = terr["level_name"]
            data["level_name"] = name
            parent_level_id = (zone["level_id"] if zone else terr["parent_level_id"]) or "0"
            parent_level_name = (zone["level_name"] if zone else terr["parent_level_name"]) or "-"
        else:
            has_top_terrs = scalar("SELECT COUNT(*) FROM sm_top_level WHERE cid=%s AND depth=3 AND status='ACTIVE'", (cid,), 0)
            if has_top_terrs > 0:
                return f"Root Field Structure level must match an active Territory (depth 3) from National Structure. Territory '{name}' was not found."
            code = _next_field_level_code(cid, "T")
            parent_level_id = zone["level_id"] if zone else "0"
            parent_level_name = zone["level_name"] if zone else "-"

        dup = q("""SELECT id FROM sm_level
                   WHERE cid=%s AND status='ACTIVE' AND (level_id=%s OR level_name=%s)
                   LIMIT 1""",
                (cid, code, name), one=True)
        if dup:
            return f"A field territory with this code or name already exists: '{name}' ({code})."

        data["depot_id"] = "-"
        data["depot_name"] = "-"
    else:
        parent = q("SELECT * FROM sm_level WHERE cid=%s AND level_id=%s",
                   (cid, parent_id), one=True)
        if not parent or parent["status"] != "ACTIVE":
            return "Parent level not found or inactive."
        depth = int(parent["depth"] or 0) + 1
        if depth > 3:
            return "Cannot create a level below 'Beat' (depth 3) in Field Structure."
        prefix = FIELD_LEVEL_PREFIX[depth]
        custom_code = (data.get("level_id") or "").strip()
        if custom_code and custom_code.upper().startswith(prefix):
            tail = custom_code[len(prefix):]
            if tail.isdigit():
                pad = 7 if prefix in ("R", "B") else 4
                code = f"{prefix}{int(tail):0{pad}d}"
            else:
                code = custom_code
        else:
            code = _next_field_level_code(cid, prefix)
        parent_level_id = parent_id
        parent_level_name = parent["level_name"] or "-"

        dup = q("""SELECT id FROM sm_level
                   WHERE cid=%s AND status='ACTIVE' AND level_name=%s
                     AND parent_level_id=%s
                   LIMIT 1""",
                (cid, name, parent_id), one=True)
        if dup:
            return "A field level with this name already exists under the same parent."

        if depth == 1:
            # Town: distributor is explicitly chosen on form
            depot_id = (data.get("depot_id") or "").strip()
            if depot_id and depot_id != "-":
                depot = q("SELECT name FROM sm_depot WHERE cid=%s AND depot_id=%s", (cid, depot_id), one=True)
                data["depot_id"] = depot_id
                data["depot_name"] = (depot["name"] if depot else "-") or "-"
            else:
                data["depot_id"] = "-"
                data["depot_name"] = "-"
        else:
            # Route (depth 2) or Beat (depth 3): auto-inherit from parent
            data["depot_id"] = parent.get("depot_id") or "-"
            data["depot_name"] = parent.get("depot_name") or "-"

    data["level_id"] = code
    data["depth"] = depth
    data["is_leaf"] = "1"
    data["parent_level_id"] = parent_level_id
    data["parent_level_name"] = parent_level_name
    for i in range(4):
        if i < depth and parent:
            data[f"level{i}"] = parent.get(f"level{i}") or ""
            data[f"level{i}_name"] = parent.get(f"level{i}_name") or ""
        elif i == depth:
            data[f"level{i}"] = code
            data[f"level{i}_name"] = name
        else:
            data[f"level{i}"] = "-"
            data[f"level{i}_name"] = "-"
    data["status"] = "ACTIVE"
    return None


def _recompute_level_is_leaf(cid, level_id):
    if not level_id or level_id == "0":
        return
    n = scalar("SELECT COUNT(*) c FROM sm_level "
               "WHERE cid=%s AND parent_level_id=%s AND status='ACTIVE'",
               (cid, level_id), 0)
    x("UPDATE sm_level SET is_leaf=%s WHERE cid=%s AND level_id=%s",
      ("0" if n else "1", cid, level_id))


def level_after_create(cid, row, user=None):
    _recompute_level_is_leaf(cid, row.get("parent_level_id"))


def level_after_update(cid, old, new, user=None):
    if (old.get("level_name") or "") != (new.get("level_name") or ""):
        x("UPDATE sm_level SET parent_level_name=%s WHERE cid=%s AND parent_level_id=%s",
          (new["level_name"], cid, new["level_id"]))
        depth = int(new.get("depth") or 0)
        x(f"UPDATE sm_level SET level{depth}_name=%s WHERE cid=%s AND level{depth}=%s",
          (new["level_name"], cid, new["level_id"]))

    # If Town (depth 1) updated distributor, cascade to child routes and beats
    if int(new.get("depth") or 0) == 1:
        if (old.get("depot_id") or "-") != (new.get("depot_id") or "-"):
            new_depot_id = new.get("depot_id") or "-"
            new_depot_name = new.get("depot_name") or "-"
            x("""UPDATE sm_level
                 SET depot_id=%s, depot_name=%s
                 WHERE cid=%s AND level1=%s""",
              (new_depot_id, new_depot_name, cid, new["level_id"]))

    _recompute_level_is_leaf(cid, new.get("level_id"))
    _recompute_level_is_leaf(cid, new.get("parent_level_id"))


def level_soft_delete(cid, rid, user=None):
    row = q("SELECT * FROM sm_level WHERE cid=%s AND id=%s", (cid, rid), one=True)
    if not row:
        return None, "Record not found."
    nchild = scalar("SELECT COUNT(*) c FROM sm_level WHERE cid=%s AND parent_level_id=%s AND status='ACTIVE'",
                    (cid, row["level_id"]), 0)
    if nchild:
        return None, (f"Cannot delete '{row['level_name']}' ({row['level_id']}) — it has "
                      f"{nchild} active child level(s). Delete the child levels first.")
    _, n = x("UPDATE sm_level SET status='PENDING', updated_on=NOW(), updated_by=%s "
             "WHERE cid=%s AND id=%s AND status='ACTIVE'", (user, cid, rid))
    _recompute_level_is_leaf(cid, row.get("parent_level_id"))
    return n, None


def level_restore(cid, rid, user=None):
    row = q("SELECT * FROM sm_level WHERE cid=%s AND id=%s", (cid, rid), one=True)
    if not row:
        return None, "Record not found."
    pid = row.get("parent_level_id")
    if int(row.get("depth") or 0) == 0:
        if pid and pid != "0":
            parent = q("SELECT status FROM sm_top_level WHERE cid=%s AND level_id=%s",
                       (cid, pid), one=True)
            if parent and parent["status"] != "ACTIVE":
                return None, f"Cannot restore — parent Zone '{pid}' in National Structure is not ACTIVE."
    elif pid and pid != "0":
        parent = q("SELECT status FROM sm_level WHERE cid=%s AND level_id=%s",
                   (cid, pid), one=True)
        if not parent or parent["status"] != "ACTIVE":
            return None, f"Cannot restore — parent level '{pid}' is not ACTIVE."
    _, n = x("UPDATE sm_level SET status='ACTIVE', updated_on=NOW(), updated_by=%s "
             "WHERE cid=%s AND id=%s", (user, cid, rid))
    _recompute_level_is_leaf(cid, pid)
    return n, None


# ------------------------------------------------------------- rep (Employee Master)
def _next_rep_code(cid, prefix):
    rows = q("SELECT rep_id FROM sm_rep WHERE cid=%s AND rep_id LIKE %s",
             (cid, prefix + "%"))
    max_no = 0
    for r in rows:
        tail = (r["rep_id"] or "")[len(prefix):]
        if tail.isdigit():
            max_no = max(max_no, int(tail))
    return f"{prefix}{max_no + 1:04d}"


def rep_prepare(cid, data, existing=None, user=None):
    name = (data.get("name") or "").strip()
    if not name:
        return "Employee name is required."

    user_type = (data.get("user_type") or "").strip().lower()
    if not user_type:
        return "User Type is required."
    if user_type not in ("rep", "sup", "dm"):
        return f"User type '{user_type}' is invalid. Allowed types: rep, sup, dm."
    data["user_type"] = user_type

    desig_id = (data.get("designation_id") or "").strip().upper()
    if not desig_id:
        return "Designation is required."

    desig = q("""SELECT cat_type_id, cat_type_name FROM sm_category_type
                 WHERE cid=%s AND type_name='EMP_DESIGNATION' AND cat_type_id=%s AND status='ACTIVE'""",
              (cid, desig_id), one=True)
    if not desig:
        desig = q("""SELECT cat_type_id, cat_type_name FROM sm_category_type
                     WHERE cid=%s AND type_name='DESIGNATION' AND cat_type_id=%s AND status='ACTIVE'""",
                  (cid, desig_id), one=True)
    if not desig:
        return f"Designation '{desig_id}' not found in active category definitions."
    data["designation_id"] = desig["cat_type_id"]
    data["designation_name"] = desig["cat_type_name"] or desig["cat_type_id"]

    # Cascading compatibility rules between User Type and Designation
    if user_type == "rep" and desig_id != "PSR":
        return "Pre Sales Executive / PSR (user_type='rep') must have Designation 'PSR'."
    if user_type == "dm" and desig_id != "DM":
        return "Delivery Man / DM (user_type='dm') must have Designation 'DM'."
    if user_type == "sup" and desig_id in ("PSR", "DM"):
        return f"Supervisor / Manager (user_type='sup') cannot have Designation '{desig_id}'. Allowed designations are all except PSR and DM."

    dob = str(data.get("dob") or "").strip()
    dob = dob.split()[0].strip() if " " in dob else dob
    data["dob"] = dob if dob and dob != "-" else None
    doj = str(data.get("doj") or "").strip()
    doj = doj.split()[0].strip() if " " in doj else doj
    data["doj"] = doj if doj and doj != "-" else None

    depot_id = (data.get("depot_id") or "").strip()
    if depot_id and depot_id != "-":
        depot = q("SELECT name FROM sm_depot WHERE cid=%s AND depot_id=%s", (cid, depot_id), one=True)
        data["depot_id"] = depot_id
        data["depot_name"] = (depot["name"] if depot else "-") or "-"
    else:
        data["depot_id"] = "-"
        data["depot_name"] = "-"

    if existing is not None:
        data["rep_id"] = existing["rep_id"]
        rep_un = (data.get("rep_username") or "").strip() or existing.get("rep_username") or existing["rep_id"]
        if q("SELECT id FROM sm_rep WHERE cid=%s AND rep_username=%s AND id != %s", (cid, rep_un, existing["id"]), one=True):
            return f"Username '{rep_un}' already exists."
        data["rep_username"] = rep_un
    else:
        raw_rep_id = data.get("rep_id")
        if raw_rep_id is not None and str(raw_rep_id).strip() and not str(raw_rep_id).strip().startswith("("):
            rep_id = str(raw_rep_id).strip()
            if q("SELECT id FROM sm_rep WHERE cid=%s AND rep_id=%s", (cid, rep_id), one=True):
                return f"Employee ID '{rep_id}' already exists."
            data["rep_id"] = rep_id
        elif raw_rep_id is None and "rep_id" in data and data.get("_is_integration"):
            data["rep_id"] = None
        else:
            data["rep_id"] = _next_rep_code(cid, desig_id.upper())
        rep_un = (data.get("rep_username") or "").strip() or (None if data.get("_is_integration") else data["rep_id"])
        if rep_un and q("SELECT id FROM sm_rep WHERE cid=%s AND rep_username=%s", (cid, rep_un), one=True):
            return f"Username '{rep_un}' already exists."
        data["rep_username"] = rep_un

    raw_pw = (data.get("password") or "").strip()
    if existing is not None:
        if raw_pw:
            data["password"] = hashlib.md5(raw_pw.encode("utf-8")).hexdigest()
        else:
            data["password"] = existing.get("password")
    else:
        if raw_pw:
            data["password"] = hashlib.md5(raw_pw.encode("utf-8")).hexdigest()
        else:
            data["password"] = hashlib.md5(b"123456").hexdigest()

    if not (data.get("status") or "").strip():
        data["status"] = "ACTIVE"
    return None


# ------------------------------------------------------------- supervisor_level (Supervisor Area Assignment)
def supervisor_level_prepare(cid, data, existing=None, user=None):
    sup_id = (data.get("sup_id") or "").strip()
    if not sup_id:
        return "Supervisor ID is required."
    sup = q("SELECT rep_id, name, user_type FROM sm_rep WHERE cid=%s AND rep_id=%s AND status='ACTIVE'",
            (cid, sup_id), one=True)
    if not sup:
        return f"Supervisor '{sup_id}' not found or inactive."
    if (sup.get("user_type") or "").lower() != "sup":
        return f"Employee '{sup_id}' has user_type '{sup.get('user_type')}' — only supervisors (user_type='sup') can be assigned supervisor levels."
    data["sup_id"] = sup["rep_id"]
    data["sup_name"] = sup["name"]

    level_id = (data.get("level_id") or "").strip()
    if not level_id:
        return "Hierarchy level ID is required."
    lvl = q("SELECT level_id, level_name, depth FROM sm_top_level WHERE cid=%s AND level_id=%s AND status='ACTIVE'",
            (cid, level_id), one=True)
    if not lvl:
        lvl = q("SELECT level_id, level_name, depth FROM sm_level WHERE cid=%s AND level_id=%s AND status='ACTIVE'",
                (cid, level_id), one=True)
    if not lvl:
        return f"Hierarchy level '{level_id}' not found in active National or Field structure."
    data["level_id"] = lvl["level_id"]
    data["level_name"] = lvl["level_name"]
    data["level_depth_no"] = int(lvl.get("depth") or 0)

    dup_where = "AND id<>%s" if existing else ""
    dup_params = (cid, data["sup_id"], data["level_id"]) + ((existing["id"],) if existing else ())
    dup = q(f"SELECT id FROM sm_supervisor_level WHERE cid=%s AND sup_id=%s AND level_id=%s AND status='ACTIVE' {dup_where} LIMIT 1",
            dup_params, one=True)
    if dup:
        return f"Supervisor '{sup_id}' is already assigned to level '{level_id}'."

    if not (data.get("status") or "").strip():
        data["status"] = "ACTIVE"
    return None


# ------------------------------------------------------------- rep_area (PSR Area Assignment)
def rep_area_prepare(cid, data, existing=None, user=None):
    rep_id = (data.get("rep_id") or "").strip()
    if not rep_id:
        return "Representative ID is required."
    rep = q("SELECT rep_id, name, user_type FROM sm_rep WHERE cid=%s AND rep_id=%s AND status='ACTIVE'",
            (cid, rep_id), one=True)
    if not rep:
        return f"Representative '{rep_id}' not found or inactive."
    data["rep_id"] = rep["rep_id"]
    data["rep_name"] = rep["name"]
    data["rep_category"] = rep.get("user_type") or "rep"

    area_id = (data.get("area_id") or "").strip()
    if not area_id:
        return "Area (Route or Beat) is required."
    area = q("SELECT level_id, level_name, depth, depot_id, depot_name FROM sm_level WHERE cid=%s AND level_id=%s AND status='ACTIVE'",
             (cid, area_id), one=True)
    if not area:
        return f"Area '{area_id}' not found in active Field Structure."
    data["area_id"] = area["level_id"]
    data["area_name"] = area["level_name"]
    data["depot_id"] = (area.get("depot_id") or "-") or "-"
    data["depot_name"] = (area.get("depot_name") or "-") or "-"

    dup_where = "AND id<>%s" if existing else ""
    dup_params = (cid, data["rep_id"], data["area_id"]) + ((existing["id"],) if existing else ())
    dup = q(f"SELECT id FROM sm_rep_area WHERE cid=%s AND rep_id=%s AND area_id=%s AND status='ACTIVE' {dup_where} LIMIT 1",
            dup_params, one=True)
    if dup:
        return f"Representative '{rep_id}' is already assigned to area '{area_id}'."

    if not (data.get("status") or "").strip():
        data["status"] = "ACTIVE"
    return None


def rep_area_after_create(cid, row, user=None):
    area_id = row.get("area_id")
    if not area_id:
        return
    lvl = q("SELECT depth FROM sm_level WHERE cid=%s AND level_id=%s", (cid, area_id), one=True)
    if not lvl:
        return
    depth = int(lvl.get("depth") or 0)
    if depth == 2:  # Route assigned — cascade to child beats
        beats = q("""SELECT level_id, level_name, depot_id, depot_name
                     FROM sm_level
                     WHERE cid=%s AND parent_level_id=%s AND depth=3 AND status='ACTIVE'""",
                  (cid, area_id))
        for b in beats:
            exists = q("SELECT id FROM sm_rep_area WHERE cid=%s AND rep_id=%s AND area_id=%s AND status='ACTIVE'",
                       (cid, row["rep_id"], b["level_id"]), one=True)
            if not exists:
                x("""INSERT INTO sm_rep_area (cid, rep_id, rep_name, rep_category, area_id, area_name, depot_id, depot_name, status, created_on, created_by)
                     VALUES (%s, %s, %s, %s, %s, %s, %s, %s, 'ACTIVE', NOW(), %s)""",
                  (cid, row["rep_id"], row["rep_name"], row.get("rep_category", "rep"),
                   b["level_id"], b["level_name"], b.get("depot_id") or "-", b.get("depot_name") or "-", user))
            vp_exists = q("SELECT id FROM sm_visit_plan WHERE cid=%s AND rep_id=%s AND area_id=%s AND status='ACTIVE'",
                          (cid, row["rep_id"], b["level_id"]), one=True)
            if not vp_exists:
                x("""INSERT INTO sm_visit_plan (cid, rep_id, rep_name, area_id, area_name, depot_id, depot_name, order_col_day, delivery_day, seq_no, status, created_on, created_by)
                     VALUES (%s, %s, %s, %s, %s, %s, %s, 'Saturday', 'Sunday', 1, 'ACTIVE', NOW(), %s)""",
                  (cid, row["rep_id"], row["rep_name"], b["level_id"], b["level_name"],
                   b.get("depot_id") or "-", b.get("depot_name") or "-", user))
    elif depth == 3:  # Direct beat assigned
        vp_exists = q("SELECT id FROM sm_visit_plan WHERE cid=%s AND rep_id=%s AND area_id=%s AND status='ACTIVE'",
                      (cid, row["rep_id"], area_id), one=True)
        if not vp_exists:
            x("""INSERT INTO sm_visit_plan (cid, rep_id, rep_name, area_id, area_name, depot_id, depot_name, order_col_day, delivery_day, seq_no, status, created_on, created_by)
                 VALUES (%s, %s, %s, %s, %s, %s, %s, 'Saturday', 'Sunday', 1, 'ACTIVE', NOW(), %s)""",
              (cid, row["rep_id"], row["rep_name"], area_id, row.get("area_name") or area_id,
               row.get("depot_id") or "-", row.get("depot_name") or "-", user))


# ------------------------------------------------------------- visit_plan (PSR Visit Plan)
def visit_plan_prepare(cid, data, existing=None, user=None):
    rep_id = (data.get("rep_id") or "").strip()
    if not rep_id:
        return "Representative ID is required."
    rep = q("SELECT rep_id, name FROM sm_rep WHERE cid=%s AND rep_id=%s AND status='ACTIVE'",
            (cid, rep_id), one=True)
    if not rep:
        return f"Representative '{rep_id}' not found or inactive."
    data["rep_id"] = rep["rep_id"]
    data["rep_name"] = rep["name"]

    area_id = (data.get("area_id") or "").strip()
    if not area_id:
        return "Area (Beat) is required."
    area = q("SELECT level_id, level_name, depot_id, depot_name FROM sm_level WHERE cid=%s AND level_id=%s AND status='ACTIVE'",
             (cid, area_id), one=True)
    if not area:
        return f"Beat '{area_id}' not found in Field Structure."
    data["area_id"] = area["level_id"]
    data["area_name"] = area["level_name"]
    data["depot_id"] = (area.get("depot_id") or "-") or "-"
    data["depot_name"] = (area.get("depot_name") or "-") or "-"

    dm_id = (data.get("delivery_man_id") or "").strip()
    if dm_id and dm_id != "-":
        dm = q("SELECT rep_id, name FROM sm_rep WHERE cid=%s AND rep_id=%s AND status='ACTIVE'", (cid, dm_id), one=True)
        if dm:
            data["delivery_man_id"] = dm["rep_id"]
            data["delivery_man_name"] = dm["name"]
        else:
            data["delivery_man_id"] = "-"
            data["delivery_man_name"] = "-"
    else:
        data["delivery_man_id"] = "-"
        data["delivery_man_name"] = "-"

    order_day = (data.get("order_col_day") or "Saturday").strip()
    if order_day not in NEXT_DAY:
        return f"Invalid order collection day '{order_day}'."
    data["order_col_day"] = order_day
    data["delivery_day"] = NEXT_DAY[order_day]

    dup_where = "AND id<>%s" if existing else ""
    dup_params = (cid, data["rep_id"], data["area_id"], data["order_col_day"]) + ((existing["id"],) if existing else ())
    dup = q(f"SELECT id FROM sm_visit_plan WHERE cid=%s AND rep_id=%s AND area_id=%s AND order_col_day=%s AND status='ACTIVE' {dup_where} LIMIT 1",
            dup_params, one=True)
    if dup:
        return f"Representative '{rep_id}' already has a visit plan for beat '{area_id}' on '{order_day}'."

    if not (data.get("status") or "").strip():
        data["status"] = "ACTIVE"
    return None


# ------------------------------------------------------------- client_visit_plan (Outlet Exceptional Visit Plan)
def client_visit_plan_prepare(cid, data, existing=None, user=None):
    client_id = (data.get("client_id") or "").strip()
    if not client_id:
        return "Outlet ID (client_id) is required."
    clt = q("SELECT client_id, name FROM sm_client WHERE cid=%s AND client_id=%s AND status='ACTIVE'",
            (cid, client_id), one=True)
    if not clt:
        return f"Outlet '{client_id}' not found or inactive."
    data["client_id"] = clt["client_id"]

    area_id = (data.get("area_id") or "").strip()
    data["area_id"] = area_id or "-"

    freq = (data.get("frequency") or "WEEKLY").strip().upper()
    data["frequency"] = freq

    for col in ("w1", "w2", "w3", "w4", "w5", "sat", "sun", "mon", "tue", "wed", "thu", "fri"):
        val = (data.get(col) or "").strip()
        data[col] = "1" if val in ("1", "Y", "yes", "true", "True") else "-"

    dup_where = "AND id<>%s" if existing else ""
    dup_params = (cid, data["client_id"], data["area_id"], data["frequency"]) + ((existing["id"],) if existing else ())
    dup = q(f"SELECT id FROM sm_client_visit_plan WHERE cid=%s AND client_id=%s AND area_id=%s AND frequency=%s AND status='ACTIVE' {dup_where} LIMIT 1",
            dup_params, one=True)
    if dup:
        return f"A visit plan for outlet '{client_id}', area '{area_id}', frequency '{freq}' already exists."

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
    "rack": {"prepare": rack_prepare},
    "depot": {
        "prepare": depot_prepare,
        "after_create": depot_after_create,
        "after_update": depot_after_update,
        "soft_delete": depot_soft_delete,
        "restore": depot_restore,
    },
    "depot_store": {
        "prepare": depot_store_prepare,
        "after_create": depot_store_after_create,
    },
    "depot_stock_balance": {"prepare": depot_stock_balance_prepare},
    "outlet": {"prepare": outlet_prepare},
    "category_type": {"prepare": category_type_prepare},
    "top_level": {
        "prepare": top_level_prepare,
        "after_create": top_level_after_create,
        "after_update": top_level_after_update,
        "soft_delete": top_level_soft_delete,
        "restore": top_level_restore,
    },
    "level": {
        "prepare": level_prepare,
        "after_create": level_after_create,
        "after_update": level_after_update,
        "soft_delete": level_soft_delete,
        "restore": level_restore,
    },
    "rep": {"prepare": rep_prepare},
    "supervisor_level": {"prepare": supervisor_level_prepare},
    "rep_area": {
        "prepare": rep_area_prepare,
        "after_create": rep_area_after_create,
    },
    "visit_plan": {"prepare": visit_plan_prepare},
    "client_visit_plan": {"prepare": client_visit_plan_prepare},
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
