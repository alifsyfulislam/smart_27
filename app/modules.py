"""SSMS module registry.

Each master-data module (its table, list columns, form fields, search columns,
filters and Excel template columns) is declared here once; the generic CRUD
router and templates render everything from this registry.
"""
from . import config

STATUS_OPTIONS = [
    ('S001','ACTIVE'),
    ('S002','INACTIVE'),
    ('S003','PENDING'),
    ('S004','REJECTED'),
]


def f(name, label, type_="text", required=False, in_list=False, in_form=True,
      in_search=False, in_excel=True, options=None, cat=None, default=None,
      width=None, help=None, readonly_on_edit=False, hidden_in_list_width=None):
    """Build a field spec dict."""
    return {
        "name": name, "label": label, "type": type_, "required": required,
        "in_list": in_list, "in_form": in_form, "in_search": in_search,
        "in_excel": in_excel, "options": options, "cat": cat,
        "default": default, "width": width, "help": help,
        "readonly_on_edit": readonly_on_edit,
    }


MODULES = {
    # ================= ITEM INFO =================
    "brand": {
        "title": "Brand",
        "icon": "fa-sitemap",
        "perm": "brand",
        "table": "sm_item_hierarchy",
        "group": "Item Info",
        "order": "level1 ASC, depth ASC",
        "indent_col": "depth",
        "list_cols": [
            ("level_id", "Level ID"), ("level_name", "Level Name"),
            ("parent_level_id", "Parent ID"), ("depth", "Depth"),
            ("is_leaf", "Leaf"), ("status", "Status"),
        ],
        "search_cols": ["level_id", "level_name", "parent_level_id", "parent_level_name"],
        "filters": [
            # ("level1_name", "Brand", "cat", "BRAND_CATEGORY"),
            ("status", "Status", "status"),
        ],
        "form_fields": [
            f("parent_level_id", "Parent Level", "hier_root_select", in_form=True,
              help="Leave '- Root -' to create a new Company (level 0). Levels: Company > Brand > Type > Flavor — a Flavor (depth 3) cannot have children."),
            f("level_name", "Level Name", "text", required=True, in_list=True),
            f("image_path", "Image", "image",
              help="Optional PNG/JPG/GIF/WEBP (max 5 MB). Saved under /static/uploads as "
                   "{table}_{slug}_image_{timestamp}.{ext}; the generated link is stored in image_path."),
            f("note", "Note", "textarea"),
        ],
        "create_hook": "hierarchy",
        "excel_cols": ["parent_level_id", "level_name", "image_path", "note"],
        "unique_msg": "A level with this name already exists under the same parent.",
    },
    "item": {
        "title": "Item",
        "icon": "fa-box-open",
        "perm": "item",
        "table": "sm_item",
        "group": "Item Info",
        "order": "id DESC",
        "list_cols": [
            ("item_id", "Item ID"), ("name", "Name"), ("brand_name", "Brand"),
            ("pack_size", "Pack Size"), ("unit_type", "Unit"), ("ctn_pcs_ratio", "CTN PCS"),
            ("mrp", "MRP"), ("price", "Price"), ("status", "Status"),
        ],
        "search_cols": ["item_id", "name", "name_bn", "short_name", "brand_name", "type_name", "flavor_name"],
        "filters": [
            ("status", "Status", "status"),
            ("item_category", "Item Category", "cat", "ITEM_CATEGORY"),
            ("unit_type", "Unit Type", "cat", "UNIT_TYPE"),
        ],
        "form_fields": [
            f("item_id", "Item ID", "text", required=True, in_list=True,
              help="Comes from integration or can be created manually here."),
            f("name", "Name", "text", required=True, in_list=True),
            f("name_bn", "Name (BN)", "text"),
            f("short_name", "Short Name", "text"),
            f("status", "Status", "select", options=STATUS_OPTIONS, default="ACTIVE", readonly_on_edit=False, in_list=True),
            f("item_category", "Item Category", "select", cat="ITEM_CATEGORY", default="REGULAR"),
            f("unit_type", "Unit Type", "select", cat="ITEM_UNIT", default="PCS"),
            f("pack_size", "Pack Size", "select", cat="ITEM_PACK", default="SMALL"),
            f("hierarchy", "Hierarchy Tagging", "hier_cascade", help="Tag the item sequentially with Company > Brand > Type > Flavor."),
            f("weight", "Weight", "float"),
            f("sequence_no", "Sequence No", "int", default=1),
            f("stock_cover_days", "Stock Cover Days", "int", default=7),
            f("invoice_price", "Invoice Price", "float"),
            f("price", "Price", "float", in_list=True),
            f("vat_amt", "VAT Amount", "float", default=0.0),
            f("total_amt", "Total Amount", "float"),
            f("mrp", "MRP", "float", in_list=True),
            f("note", "Note", "textarea"),
        ],
        "create_hook": "item",
        "excel_cols": ["item_id", "name", "name_bn", "short_name", "item_category",
                       "unit_type", "pack_size", "weight", "company_id", "brand_id",
                       "type_id", "flavor_id", "ctn_pcs_ratio", "sequence_no",
                       "stock_cover_days", "dist_price", "invoice_price", "mrp",
                       "price", "vat_amt", "total_amt", "manufacturer", "note"],
        "unique_msg": "An item with this Item ID already exists.",
    },
    "item-batch": {
        "title": "Item Batch",
        "icon": "fa-layer-group",
        "perm": "item_batch",
        "table": "sm_item_batch",
        "group": "Item Info",
        "order": "id DESC",
        "list_cols": [
            ("item_id", "Item ID"), ("batch_id", "Batch ID"), ("name", "Name"),
            ("expiary_date", "Expiary Date"), ("status", "Status"),
        ],
        "search_cols": ["item_id", "batch_id", "name", "note"],
        "filters": [("status", "Status", "status")],
        "form_fields": [
            f("item_id", "Item", "item_select", required=True, in_list=True),
            f("batch_id", "Batch ID", "text", required=True, in_list=True,
              help="When an item is created manually/integration, a default batch '1' valid till 2100-12-31 is generated automatically."),
            f("name", "Name", "text"),
            f("expiary_date", "Expiary Date", "date", required=True, in_list=True),
            f("status", "Status", "select", options=STATUS_OPTIONS, default="ACTIVE", in_list=True),
            f("note", "Note", "textarea"),
        ],
        "create_hook": "item_batch",
        "excel_cols": ["item_id", "batch_id", "name", "expiary_date", "note"],
        "unique_msg": "This batch already exists for the item.",
    },
    # ================= DISTRIBUTOR INFO =================
    "distributor": {
        "title": "Distributor",
        "icon": "fa-truck-fast",
        "perm": "distributor",
        "table": "sm_depot",
        "group": "Distributor Info",
        "order": "id DESC",
        "list_cols": [
            ("depot_id", "Distributor ID"), ("name", "Name"), ("depot_category", "Category"),
            ("contact", "Contact"), ("town_name", "Town"), ("owner_name", "Owner"),
            ("status", "Status"),
        ],
        "search_cols": ["depot_id", "name", "contact", "owner_name", "town_name", "email"],
        "filters": [("status", "Status", "status"),
                    ("depot_category", "Depot Category", "cat", "DEPOT_CATEGORY")],
        "form_fields": [
            f("depot_id", "Distributor ID (Depot)", "text", required=True, in_list=True,
              help="Comes from integration or manual. On create, default stores {id}140 (Commercial) and {id}170 (Damage) are generated automatically."),
            f("name", "Name", "text", required=True, in_list=True),
            f("name_bn", "Name (BN)", "text"),
            f("short_name", "Short Name", "text"),
            f("depot_category", "Depot Category", "select", cat="DEPOT_CATEGORY",
              default="DISTRIBUTOR", in_list=True),
            f("owner_name", "Owner Name", "text", in_list=True),
            f("owner_name_bn", "Owner Name (BN)", "text"),
            f("email", "Email", "text"),
            f("contact", "Contact", "text", in_list=True),
            f("contact_2", "Contact 2", "text"),
            f("tin", "TIN", "text"),
            f("bin", "BIN", "text"),
            f("address", "Address", "textarea"),
            f("address_bn", "Address (BN)", "textarea"),
            f("wh_address", "Warehouse Address", "textarea"),
            f("wh_address_bn", "Warehouse Address (BN)", "textarea"),
            f("town_id", "Town ID", "text"),
            f("town_name", "Town Name", "text", in_list=True),
            f("latitude", "Latitude", "text"),
            f("longitude", "Longitude", "text"),
            f("sequence_no", "Sequence No", "int", default=1),
            f("status", "Status", "select", options=STATUS_OPTIONS, default="ACTIVE", in_list=True),
            f("note", "Note", "textarea"),
        ],
        "create_hook": "depot",
        "excel_cols": ["depot_id", "name", "name_bn", "short_name", "depot_category",
                       "owner_name", "email", "contact", "contact_2", "tin", "bin",
                       "address", "town_id", "town_name", "latitude", "longitude",
                       "sequence_no", "note"],
        "unique_msg": "A distributor with this Depot ID already exists.",
    },
    "distributor-store": {
        "title": "Distributor Store",
        "icon": "fa-store",
        "perm": "depot_store",
        "table": "sm_depot_store",
        "group": "Distributor Info",
        "order": "id DESC",
        "list_cols": [
            ("depot_id", "Distributor ID"), ("store_id", "Store ID"),
            ("store_name", "Store Name"), ("store_type", "Store Type"), ("status", "Status"),
        ],
        "search_cols": ["depot_id", "store_id", "store_name", "store_type", "note"],
        "filters": [("status", "Status", "status"),
                    ("store_type", "Store Type", "cat", "STORE_TYPE")],
        "form_fields": [
            f("depot_id", "Distributor", "depot_select", required=True, in_list=True),
            f("store_id", "Store ID", "text", required=True, in_list=True),
            f("store_name", "Store Name", "text", required=True, in_list=True),
            f("store_type", "Store Type", "select", cat="STORE_TYPE", in_list=True),
            f("status", "Status", "select", options=STATUS_OPTIONS, default="ACTIVE", in_list=True),
            f("note", "Note", "textarea"),
        ],
        "create_hook": "depot_store",
        "excel_cols": ["depot_id", "store_id", "store_name", "store_type", "note"],
        "unique_msg": "This store already exists for the distributor.",
    },
    # ================= Settings =================
    "category-type": {
        "title": "Category Type",
        "icon": "fa-shapes",
        "perm": "category_type",
        "table": "sm_category_type",
        "group": "Settings",
        "order": "type_name ASC, id DESC",
        "list_cols": [
            ("type_name", "Type Name"), ("cat_type_id", "Category ID"),
            ("cat_type_name", "Category Name"), ("status", "Status"),
        ],
        "search_cols": ["type_name", "cat_type_id", "cat_type_name", "note"],
        "filters": [("status", "Status", "status")],
        "form_fields": [
            f("type_name", "Type Name", "text", required=True, in_list=True,
              help="Definition group, e.g. DEPOT_CATEGORY, STORE_TYPE, ITEM_CATEGORY, UNIT_TYPE."),
            f("cat_type_id", "Category ID (value)", "text", required=True, in_list=True),
            f("cat_type_name", "Category Name (display)", "text", in_list=True),
            f("status", "Status", "select", options=STATUS_OPTIONS, default="ACTIVE", in_list=True),
            f("note", "Note", "textarea"),
        ],
        "create_hook": "category_type",
        "excel_cols": ["type_name", "cat_type_id", "cat_type_name", "note"],
        "unique_msg": "This category definition already exists.",
    },
}

MODULE_ORDER = ["brand", "item", "item-batch", "distributor", "distributor-store", "category-type"]

PERM2SLUG = {"brand": "brand", "item": "item", "item_batch": "item-batch",
             "distributor": "distributor", "depot_store": "distributor-store",
             "category_type": "category-type"}


def get(slug):
    return MODULES.get(slug)


def values_from_form(m, form, existing=None, is_create=True):
    """Collect row values for INSERT/UPDATE from a starlette FormData."""
    values = {}
    for spec in m["form_fields"]:
        name = spec["name"]
        if name == "hierarchy":           # cascade: hidden inputs already on form
            continue
        if name == "parent_level_id" and existing is None:
            pass                          # handled by hook but keep submitted value
        if spec["type"] == "image":
            continue                      # file input <name>_file handled by the router
        if not spec["in_form"]:
            continue
        if (not is_create) and spec["readonly_on_edit"]:
            continue
        raw = form.get(name)
        if spec["type"] == "int":
            try:
                values[name] = int(float(raw)) if raw not in (None, "") else int(spec["default"] or 0)
            except (TypeError, ValueError):
                values[name] = int(spec["default"] or 0)
        elif spec["type"] == "float":
            try:
                values[name] = float(raw) if raw not in (None, "") else float(spec["default"] or 0)
            except (TypeError, ValueError):
                values[name] = float(spec["default"] or 0)
        else:
            values[name] = (raw or "").strip()
    return values


def touch(values, user_id, is_create):
    now = "NOW()"
    if is_create:
        values["cid"] = config.CID
        values["created_on"] = now
        values["created_by"] = user_id
    else:
        values["updated_on"] = now
        values["updated_by"] = user_id
