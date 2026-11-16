"""SSMS module registry.

Each master-data module (its table, list columns, form fields, search columns,
filters and Excel template columns) is declared here once; the generic CRUD
router and templates render everything from this registry.
"""
from . import config

STATUS_OPTIONS = [
    # (value, label) — values are stored verbatim in the `status` columns
    ('ACTIVE', 'ACTIVE'),
    ('INACTIVE', 'INACTIVE'),
    ('PENDING', 'PENDING'),
    ('REJECTED', 'REJECTED'),
]


def f(name, label, type_="text", required=False, in_list=False, in_form=True,
      in_search=False, in_excel=True, options=None, cat=None, default=None,
      width=None, help=None, readonly_on_edit=False, hidden_in_list_width=None,
      searchable=False):
    """Build a field spec dict."""
    return {
        "name": name, "label": label, "type": type_, "required": required,
        "in_list": in_list, "in_form": in_form, "in_search": in_search,
        "in_excel": in_excel, "options": options, "cat": cat,
        "default": default, "width": width, "help": help,
        "readonly_on_edit": readonly_on_edit, "searchable": searchable,
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
            ("brand_id", "Brand", "hier_brand"),
            ("item_category", "Item Category", "cat", "ITEM_CATEGORY"),
            ("unit_type", "Unit Type", "cat", "ITEM_UNIT"),
        ],
        "form_fields": [
            f("item_id", "Item ID", "text", required=True, in_list=True, readonly_on_edit=True,
              help="Comes from integration or can be created manually here. Immutable on edit."),
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
            f("total_amt", "Total Amount", "float",
              help="Auto-calculated as Price + VAT Amount while you type; you can still type over it."),
            f("mrp", "MRP", "float", in_list=True),
            f("image_path", "Image", "image",
              help="Optional PNG/JPG/GIF/WEBP (max 5 MB). Saved under /static/uploads as "
                   "{table}_{slug}_image_{timestamp}.{ext}; the generated link is stored in image_path."),
            f("note", "Note", "textarea"),
        ],
        "create_hook": "item",
        "excel_cols": ["item_id", "name", "name_bn", "short_name", "item_category",
                       "unit_type", "pack_size", "weight", "company_id", "brand_id",
                       "type_id", "flavor_id", "ctn_pcs_ratio", "sequence_no",
                       "stock_cover_days", "dist_price", "invoice_price", "mrp",
                       "price", "vat_amt", "total_amt", "manufacturer", "image_path", "note"],
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
        "filters": [
            ("status", "Status", "status"),
            ("brand_id", "Brand", "item_brand"),
        ],
        "form_fields": [
            f("item_id", "Item", "item_select", required=True, in_list=True, readonly_on_edit=True,
              help="Active items only — type to search by item id or name. Immutable on edit."),
            f("batch_id", "Batch ID", "text", required=True, in_list=True,
              help="When an item is created manually/integration, a default batch '1' valid till 2100-12-31 is generated automatically."),
            f("name", "Name", "text"),
            f("expiary_date", "Expiary Date", "date", required=True, in_list=True, default="2100-12-31",
              help="Defaults to 2100-12-31 (no expiry)."),
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
                    ("depot_category", "Depot Category", "cat", "DISTRIBUTOR_CATEGORY")],
        "form_fields": [
            f("depot_id", "Distributor ID (Depot)", "text", required=True, in_list=True,
              help="Comes from integration or manual. On create, default stores {id}140 (Commercial) and {id}170 (Damage) are generated automatically."),
            f("name", "Name", "text", required=True, in_list=True),
            f("name_bn", "Name (BN)", "text"),
            f("short_name", "Short Name", "text"),
            f("depot_category", "Depot Category", "select", cat="DISTRIBUTOR_CATEGORY",
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
            f("town_id", "Town ID", "text", in_form=False),
            f("town_name", "Town Name", "select", in_list=True, searchable=True,
              help="Town from Field Structure (sm_level depth 1)."),
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
    # ================= OUTLET INFO =================
    "outlet": {
        "title": "Outlet",
        "icon": "fa-shop",
        "perm": "outlet",
        "table": "sm_client",
        "group": "Outlet Info",
        "order": "id DESC",
        "list_cols": [
            ("client_id", "Outlet ID"), ("name", "Outlet Name"),
            ("category_name", "Category"), ("sub_category_name", "Sub Category"),
            ("customer_type", "Customer Type"), ("depot_id", "Distributor"),
            ("store_name", "Store"), ("contact_no1", "Contact"), ("status", "Status"),
        ],
        "search_cols": ["client_id", "client_old_id", "name", "name_bn", "short_name",
                        "owner_name", "contact_no1", "contact_no2", "category_name",
                        "depot_id", "depot_name", "store_id", "store_name"],
        "filters": [
            ("status", "Status", "status"),
            ("category_id", "Outlet Category", "cat", "OUTLET_CATEGORY"),
        ],
        "form_fields": [
            f("client_id", "Outlet ID", "text", required=True, in_list=True,
              help="Unique per company; comes from integration or is created manually here."),
            f("client_old_id", "Old Outlet ID", "text"),
            f("name", "Outlet Name", "text", required=True, in_list=True),
            f("name_bn", "Name (BN)", "text"),
            f("short_name", "Short Name", "text"),
            f("owner_name", "Owner Name", "text"),
            f("owner_name_bn", "Owner Name (BN)", "text"),
            f("category_id", "Outlet Category", "select", cat="OUTLET_CATEGORY", in_list=True,
              help="Values from Settings › Category Type, type OUTLET_CATEGORY (e.g. OC001 — KR0)."),
            f("sub_category_id", "Outlet Sub Category", "select", cat="OUTLET_SUB_CATEGORY",
              help="Values from type OUTLET_SUB_CATEGORY (e.g. OSC001 — KR0-1)."),
            f("depot_id", "Distributor", "depot_select", required=True, in_list=True,
              help="Active distributors (sm_depot) only."),
            f("store_id", "Store", "store_select",
              help="Stores of the selected distributor (sm_depot_store); pick the distributor first."),
            f("contact_no1", "Contact 1", "text"),
            f("contact_no2", "Contact 2", "text"),
            f("address", "Address", "textarea"),
            f("status", "Status", "select", options=STATUS_OPTIONS, default="ACTIVE", in_list=True),
            f("note", "Note", "textarea"),
        ],
        "create_hook": "outlet",
        "excel_cols": ["client_id", "client_old_id", "name", "name_bn", "short_name",
                       "owner_name", "category_id", "sub_category_id", "depot_id",
                       "store_id", "contact_no1", "contact_no2", "address", "note"],
        "unique_msg": "An outlet with this Outlet ID already exists.",
    },
    # ================= Settings =================
    "category-type": {
        "title": "Module Category",
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
    # ================= FIELDFORCE INFO =================
    "top-level": {
        "title": "National Structure",
        "icon": "fa-network-wired",
        "perm": "top_level",
        "table": "sm_top_level",
        "group": "Fieldforce Info",
        "order": "level0 ASC, depth ASC, level_id ASC",
        "indent_col": "depth",
        "list_cols": [
            ("level_id", "Level ID"), ("level_name", "Level Name"),
            ("parent_level_id", "Parent ID"), ("depth", "Depth"),
            ("is_leaf", "Leaf"), ("status", "Status"),
        ],
        "search_cols": ["level_id", "level_name", "parent_level_id", "parent_level_name"],
        "filters": [("status", "Status", "status")],
        "form_fields": [
            f("parent_level_id", "Parent Level", "hier_root_select", in_form=True,
              help="Root (level 0) is National (H). Levels: National(H) > Area(A) > Zone(Z) > Territory(T). Territory (depth 3) is a leaf."),
            f("level_name", "Level Name", "text", required=True, in_list=True),
            f("note", "Note", "textarea"),
        ],
        "create_hook": "top_level",
        "excel_cols": ["parent_level_id", "level_name", "note"],
        "unique_msg": "A national level with this name already exists under the same parent.",
    },
    "level": {
        "title": "Field Structure",
        "icon": "fa-route",
        "perm": "level",
        "table": "sm_level",
        "group": "Fieldforce Info",
        "order": "level0 ASC, depth ASC, level_id ASC",
        "indent_col": "depth",
        "list_cols": [
            ("level_id", "Level ID"), ("level_name", "Level Name"),
            ("parent_level_id", "Parent ID"), ("depth", "Depth"),
            ("depot_name", "Distributor"), ("is_leaf", "Leaf"), ("status", "Status"),
        ],
        "search_cols": ["level_id", "level_name", "parent_level_id", "parent_level_name", "depot_id", "depot_name"],
        "filters": [("status", "Status", "status")],
        "form_fields": [
            f("parent_level_id", "Parent Level", "hier_root_select", in_form=True,
              help="Root (level 0) is Territory (T). Levels: Territory(T) > Town(TW) > Route(R) > Beat(B). Beat (depth 3) is a leaf."),
            f("level_name", "Level Name", "text", required=True, in_list=True),
            f("depot_id", "Distributor", "depot_select", help="Optional distributor mapping for this field level."),
            f("note", "Note", "textarea"),
        ],
        "create_hook": "level",
        "excel_cols": ["parent_level_id", "level_name", "depot_id", "note"],
        "unique_msg": "A field level with this name already exists under the same parent.",
    },
    "rep": {
        "title": "Employee",
        "icon": "fa-user-tie",
        "perm": "rep",
        "table": "sm_rep",
        "group": "Fieldforce Info",
        "order": "id DESC",
        "list_cols": [
            ("rep_id", "Employee ID"), ("name", "Name"),
            ("designation_name", "Designation"), ("user_type", "User Type"),
            ("mobile_no", "Mobile"), ("depot_name", "Distributor"), ("status", "Status"),
        ],
        "search_cols": ["rep_id", "rep_username", "name", "name_bn", "designation_id", "designation_name", "mobile_no", "email", "depot_id", "depot_name"],
        "filters": [
            ("status", "Status", "status"),
            ("designation_id", "Designation", "cat", "DESIGNATION"),
        ],
        "form_fields": [
            f("rep_id", "Employee ID", "text", readonly_on_edit=True, in_list=True,
              help="Auto-generated on save from Designation (e.g. HOS0001, PSR0001). Immutable on edit."),
            f("name", "Name", "text", required=True, in_list=True),
            f("name_bn", "Name (BN)", "text"),
            f("designation_id", "Designation", "select", cat="DESIGNATION", required=True, in_list=True,
              help="Sourced dynamically from Settings > Module Category (type DESIGNATION)."),
            f("user_type", "User Type", "select", options=[("rep", "rep — Sales Representative / PSR"), ("sup", "sup — Supervisor / Manager")], required=True, default="rep", in_list=True),
            f("mobile_no", "Mobile No", "text", in_list=True),
            f("alt_mobile_no", "Alt Mobile No", "text"),
            f("email", "Email", "text"),
            f("depot_id", "Distributor", "depot_select", in_list=True, help="Assigned distributor (sm_depot), if applicable."),
            f("address", "Address", "textarea"),
            f("dob", "Date of Birth", "date"),
            f("doj", "Date of Joining", "date"),
            f("nid", "NID", "text"),
            f("tin", "TIN", "text"),
            f("password", "Password", "text", default="123456"),
            f("status", "Status", "select", options=STATUS_OPTIONS, default="ACTIVE", in_list=True),
            f("note", "Note", "textarea"),
        ],
        "create_hook": "rep",
        "excel_cols": ["name", "name_bn", "designation_id", "user_type", "mobile_no", "alt_mobile_no", "email", "depot_id", "address", "dob", "doj", "nid", "tin", "note"],
        "unique_msg": "An employee with this ID already exists.",
    },
    "supervisor-level": {
        "title": "Supervisor Area",
        "icon": "fa-user-gear",
        "perm": "supervisor_level",
        "table": "sm_supervisor_level",
        "group": "Fieldforce Info",
        "order": "id DESC",
        "list_cols": [
            ("sup_id", "Supervisor ID"), ("sup_name", "Supervisor Name"),
            ("level_id", "Level ID"), ("level_name", "Level Name"),
            ("level_depth_no", "Depth"), ("status", "Status"),
        ],
        "search_cols": ["sup_id", "sup_name", "level_id", "level_name"],
        "filters": [("status", "Status", "status")],
        "form_fields": [
            f("sup_id", "Supervisor", "select", required=True, in_list=True,
              help="Active employees with user_type='sup'."),
            f("level_id", "Hierarchy Level ID", "select", required=True, in_list=True,
              help="Active level from National Structure (H, A, Z, T) or Field Structure (T, TW, R, B)."),
            f("status", "Status", "select", options=STATUS_OPTIONS, default="ACTIVE", in_list=True),
            f("note", "Note", "textarea"),
        ],
        "create_hook": "supervisor_level",
        "excel_cols": ["sup_id", "level_id", "note"],
        "unique_msg": "This supervisor is already assigned to this hierarchy level.",
    },
    "rep-area": {
        "title": "PSR Area",
        "icon": "fa-map-location-dot",
        "perm": "rep_area",
        "table": "sm_rep_area",
        "group": "Fieldforce Info",
        "order": "id DESC",
        "list_cols": [
            ("rep_id", "Rep ID"), ("rep_name", "Rep Name"),
            ("area_id", "Area ID"), ("area_name", "Area Name"),
            ("depot_name", "Distributor"), ("status", "Status"),
        ],
        "search_cols": ["rep_id", "rep_name", "area_id", "area_name", "depot_id", "depot_name"],
        "filters": [("status", "Status", "status")],
        "form_fields": [
            f("rep_id", "Representative (PSR)", "select", required=True, in_list=True,
              help="Active sales reps (sm_rep where user_type='rep')."),
            f("area_id", "Route / Beat", "select", required=True, in_list=True,
              help="Select a Route (depth 2) or Beat (depth 3). If a Route is assigned, all child Beats and initial visit plans are auto-cascaded."),
            f("status", "Status", "select", options=STATUS_OPTIONS, default="ACTIVE", in_list=True),
            f("note", "Note", "textarea"),
        ],
        "create_hook": "rep_area",
        "excel_cols": ["rep_id", "area_id", "note"],
        "unique_msg": "This area is already assigned to this representative.",
    },
    "visit-plan": {
        "title": "PSR Visit Plan",
        "icon": "fa-calendar-days",
        "perm": "visit_plan",
        "table": "sm_visit_plan",
        "group": "Fieldforce Info",
        "order": "id DESC",
        "list_cols": [
            ("rep_id", "Rep ID"), ("rep_name", "Rep Name"),
            ("area_id", "Beat ID"), ("area_name", "Beat Name"),
            ("order_col_day", "Order Day"), ("delivery_day", "Delivery Day"),
            ("delivery_man_name", "Delivery Man"), ("status", "Status"),
        ],
        "search_cols": ["rep_id", "rep_name", "area_id", "area_name", "order_col_day", "delivery_day", "delivery_man_id", "delivery_man_name", "depot_name"],
        "filters": [
            ("status", "Status", "status"),
            ("order_col_day", "Order Day", "select", [("Saturday","Saturday"),("Sunday","Sunday"),("Monday","Monday"),("Tuesday","Tuesday"),("Wednesday","Wednesday"),("Thursday","Thursday"),("Friday","Friday")]),
        ],
        "form_fields": [
            f("rep_id", "Representative (PSR)", "select", required=True, in_list=True,
              help="Active sales reps (sm_rep where user_type='rep')."),
            f("area_id", "Beat", "select", required=True, in_list=True,
              help="Active beat (sm_level depth 3)."),
            f("order_col_day", "Order Collection Day", "select", options=[("Saturday","Saturday"),("Sunday","Sunday"),("Monday","Monday"),("Tuesday","Tuesday"),("Wednesday","Wednesday"),("Thursday","Thursday"),("Friday","Friday")], default="Saturday", required=True, in_list=True),
            f("delivery_day", "Delivery Day", "text", readonly_on_edit=True, in_list=True,
              help="Auto-calculated as next calendar day."),
            f("delivery_man_id", "Delivery Man", "select", in_list=True,
              help="Active employee with designation DM."),
            f("seq_no", "Sequence No", "int", default=1, in_list=True),
            f("status", "Status", "select", options=STATUS_OPTIONS, default="ACTIVE", in_list=True),
            f("note", "Note", "textarea"),
        ],
        "create_hook": "visit_plan",
        "excel_cols": ["rep_id", "area_id", "order_col_day", "delivery_man_id", "seq_no", "note"],
        "unique_msg": "A visit plan already exists for this representative, beat, and day.",
    },
    "client-visit-plan": {
        "title": "Outlet Visit Plan",
        "icon": "fa-shop-lock",
        "perm": "client_visit_plan",
        "table": "sm_client_visit_plan",
        "group": "Fieldforce Info",
        "order": "id DESC",
        "list_cols": [
            ("client_id", "Outlet ID"), ("area_id", "Area ID"),
            ("frequency", "Frequency"), ("w1", "W1"), ("w2", "W2"),
            ("w3", "W3"), ("w4", "W4"), ("w5", "W5"), ("status", "Status"),
        ],
        "search_cols": ["client_id", "area_id", "frequency"],
        "filters": [("status", "Status", "status")],
        "form_fields": [
            f("client_id", "Outlet", "select", required=True, in_list=True,
              help="Active outlet (sm_client)."),
            f("area_id", "Area (Beat)", "select", in_list=True, help="Beat ID (sm_level depth 3)."),
            f("frequency", "Frequency", "select", options=[("WEEKLY","WEEKLY"),("BI_WEEKLY","BI_WEEKLY"),("MONTHLY","MONTHLY"),("FORTNIGHTLY","FORTNIGHTLY")], default="WEEKLY", in_list=True),
            f("w1", "Week 1", "select", options=[("1","Yes"),("-","No")], default="1"),
            f("w2", "Week 2", "select", options=[("1","Yes"),("-","No")], default="1"),
            f("w3", "Week 3", "select", options=[("1","Yes"),("-","No")], default="1"),
            f("w4", "Week 4", "select", options=[("1","Yes"),("-","No")], default="1"),
            f("w5", "Week 5", "select", options=[("1","Yes"),("-","No")], default="1"),
            f("sat", "Saturday", "select", options=[("1","Yes"),("-","No")], default="1"),
            f("sun", "Sunday", "select", options=[("1","Yes"),("-","No")], default="1"),
            f("mon", "Monday", "select", options=[("1","Yes"),("-","No")], default="1"),
            f("tue", "Tuesday", "select", options=[("1","Yes"),("-","No")], default="1"),
            f("wed", "Wednesday", "select", options=[("1","Yes"),("-","No")], default="1"),
            f("thu", "Thursday", "select", options=[("1","Yes"),("-","No")], default="1"),
            f("fri", "Friday", "select", options=[("1","Yes"),("-","No")], default="1"),
            f("seq_no", "Sequence No", "int", default=1),
            f("status", "Status", "select", options=STATUS_OPTIONS, default="ACTIVE", in_list=True),
            f("note", "Note", "textarea"),
        ],
        "create_hook": "client_visit_plan",
        "excel_cols": ["client_id", "area_id", "frequency", "w1", "w2", "w3", "w4", "w5", "sat", "sun", "mon", "tue", "wed", "thu", "fri", "seq_no", "note"],
        "unique_msg": "A visit plan for this outlet, area and frequency already exists.",
    },
}

MODULE_ORDER = [
    "brand", "item", "item-batch",
    "top-level", "level", "rep", "supervisor-level", "rep-area", "visit-plan", "client-visit-plan",
    "distributor", "distributor-store",
    "outlet", "category-type",
]

PERM2SLUG = {
    "brand": "brand", "item": "item", "item_batch": "item-batch",
    "top_level": "top-level", "level": "level", "rep": "rep",
    "supervisor_level": "supervisor-level", "rep_area": "rep-area",
    "visit_plan": "visit-plan", "client_visit_plan": "client-visit-plan",
    "distributor": "distributor", "depot_store": "distributor-store",
    "outlet": "outlet", "category_type": "category-type",
}


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
                clean_raw = str(raw).replace(",", "").strip() if raw not in (None, "") else ""
                values[name] = float(clean_raw) if clean_raw else float(spec["default"] or 0)
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
