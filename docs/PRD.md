# Product Requirements Document (PRD)
## Secondary Sales Management System (SSMS)

**Version:** 1.0.0 · **Depends on:** docs/BRD.md · **Stack:** FastAPI + Jinja2 + PyMySQL + openpyxl

---

## 1. Product overview

A web application (server-rendered Jinja2 templates over a FastAPI backend) that manages
secondary-sales master data with login-based access control and full auditability.

## 2. Pages & journeys

### 2.1 Login (`/login`)
- User ID + password. Session cookie (8h). Failed logins show an inline error.
- All other routes redirect here when not authenticated.

### 2.2 Dashboard (`/`)
- Stat cards: items active/inactive, batches, distributors active/inactive, stores, users, roles.
- Item-hierarchy distribution bars (Company/Brand/Type/Flavor counts).
- Recent 8 audit entries; quick actions (new level/item/batch/distributor, template downloads).

### 2.3 Sidebar navigation
Groups: **Top** (Dashboard) · **Item Info** (Brand, Item, Item Batch, Rack) · **Fieldforce Info** (National Structure, Field Structure, Employee Master, Supervisor Area, PSR Area, PSR Visit Plan, Outlet Visit Plan) · **Distributor Info** (Distributor, Distributor Store, Distributor Stock) · **Outlet Info** (Outlet) · **Settings** (Category Type) · **Administration** (Users, Roles, Permissions) · **Records** (Audit Log).
Accordion behavior — opening a group collapses the others (persisted in localStorage); a toggle
collapses the sidebar to icon rail on desktop, drawer + overlay on mobile; smooth CSS transitions;
Font Awesome icons; Facebook-style colors (#1877f2 primary, #f0f2f5 background, #050505/#65676b text).

### 2.4 Master modules (generic engine driven by `app/modules.py`)
Per module: **Brand**, **Item**, **Item Batch**, **Rack**, **Distributor**, **Distributor Store**, **Distributor Stock**, **Outlet**, **National Structure**, **Supervisor Area**, **PSR Area**, **PSR Visit Plan**, **Outlet Visit Plan**, **Category Type**

| Feature | Behavior |
|---|---|
| Create | Form with validation + business-code generation (see hooks) |
| View | Read-only record page |
| Edit | Edit form (business IDs editable where allowed; hierarchy parent fixed after create) |
| Soft delete | status → PENDING (for brand: subtree PENDING); restore reverses with parent-active check |
| Excel import | Template download (xlsx) + upload panel; row-by-row insert reusing form hooks; per-row error report |
| Excel export | Download filtered visible page data (`GET /{slug}/export`); 'Download All' for entire result set (`scope=all`); hierarchy (`brand`) exports multi-sheet tree + leaf paths; hierarchy-synced items (`item`) export with synchronized Company, Brand, Type, and Flavor columns |
| Search/filter | Free-text search over configured columns + typeahead search and multi-select dropdown filters (status, category selects) |
| Density / Layout | Minimal margin and padding high-density layout across table rows, card containers, and search controls to eliminate wasted screen space |
| Pagination | Configurable page size (10/25/50/100), page window, record counts |

### 2.4.1 Brand-specific UX (Item Info › Brand)
- **Tree list**: the hierarchy renders as an expandable tree. On load only **depth-0 (Company) nodes are expanded** — deeper levels stay collapsed and the user opens them manually. Expanding a node **auto-collapses the other open nodes in the same level** (accordion per level); clicking an expanded node collapses it.
- **Parent Level picker** is a type-to-search single select (searchable dropdown over `CODE — Name`); arrow keys + Enter work, the native select stays the value holder.
- **Image** field: file input with live preview on create; on edit the current image is previewed and a new file can be picked to replace it (empty input keeps it). Files land in `/static/uploads` as `{table}_{name-slug}_image_{timestamp}.{ext}`; the link is stored in `image_path` (PNG/JPG/GIF/WEBP, max 5 MB, extension-checked).
- **Child Levels card** on the Edit/View page: lists existing child levels (view/edit links, status badges) and, on Edit, offers one name box plus "Add another" to create **one or many** children in a single submit (`POST /{slug}/add-children/{id}`, names deduped, per-name errors reported). Disabled for Flavors (depth 3).

### 2.4.2 Dynamic Form Dropdowns & Hierarchy Cascade
- **Option display format**: All dynamically populated form selects (Brand parent picker, Item hierarchy cascade, Item in Item Batch, Distributor in Distributor Store, Store in Outlet, Town in Distributor) format selectable options as `ID | Name` (e.g. `BG001 | Kurkure`, `TW0001 | GULSHAN`), replacing dash delimiters.
- **Searchable single-select UX (`select[data-searchable]`)**: When focused or typed into, placeholder text (e.g., `-- Company --`, `-- Select item --`, `Type to search Town Name…`) never acts as a pre-applied search query. The options list displays all valid options when empty/focused, allowing instant typeahead filtering.
- **Hierarchy cascade (Item create & edit)**:
  - **Create**: Company dropdown initially populates from `/api/hierarchy/children?parent=0`. Selecting a level loads its active child levels for the next select (Company → Brand → Type → Flavor).
  - **Edit**: Existing item hierarchy values (`company_id`, `brand_id`, `type_id`, `flavor_id`) automatically hydrate sequentially from database values on page load, setting the respective values and updating visible dropdown labels across all four levels.
- **Float Input Precision (Item create & edit)**: Numeric fields (`weight`, `invoice_price`, `price`, `vat_amt`, `total_amt`, `mrp`) accept arbitrary decimal precision using HTML5 `step="any"` without browser constraint errors, preserve `0.0` and `0` values across create/edit/view, and parse comma-separated floats cleanly.
- **Item Image Upload (`sm_item.image_path`)**: Mirrors the Brand image upload pattern on `/item/create` and `/item/edit/{id}`. File input accepts PNG/JPG/GIF/WEBP (max 5 MB) with instant client-side preview; on edit, displays existing image thumbnail (suppressing the database default `'-'`) and hint. Uploaded file lands in `/static/uploads/sm_item_{name-slug}_image_{timestamp}.{ext}` only after DB row commit, storing the relative URL in `sm_item.image_path` with full change tracking in `sm_audit_log`.
- **Item View & Edit Controls**: On `/item/view/{id}`, the Hierarchy Tagging block displays a clean, read-only text summary of Company, Brand, Type, and Flavor without input controls; on `/item/edit/{id}`, `item_id` is marked readonly and protected against modification both client-side and in `item_prepare`.
- **Item Batch Edit Controls**: On `/item-batch/edit/{id}`, the Item selector is disabled (with a hidden input ensuring form payload integrity) and protected on the backend via `item_batch_prepare`.
- **National Structure Parent & Image Simplification**: `/top-level/create` parent picker restricts options strictly to depth 0 active records plus Root; image input is removed from forms.
- **Field Structure Parent & Territory Selection**: In `/level/create` and `/level/edit`, Parent Level options are sourced dynamically from active Zones in National Structure (`sm_top_level` depth 2, `status='ACTIVE'`); Level Name suggestions dynamically filter and load active National Structure Territories (`sm_top_level` depth 3) under that chosen Zone.
- **Distributor Town Selection**: `town_name` renders as a searchable dropdown dynamically populated from `sm_level` (`depth=1` and `status='ACTIVE'`). The backend `depot_prepare` hook automatically synchronizes `town_id` and `town_name`.

### 2.4.4 Rack & Distributor Info Enhancements
- **Rack Master (`sm_rack`)**: Positioned under Item Info (`/rack`). Supports manual creation, view, edit, soft delete, restore, and Excel import. Mirrored image upload parity with `sm_item` (PNG/JPG/GIF/WEBP up to 5 MB stored in `app/static/uploads/sm_rack_{slug}_image_{timestamp}.{ext}`). Unique on `(cid, rack_id)`. The `rack_id` is immutable on edit (`readonly_on_edit=True` in module spec and enforced in `rack_prepare`). Historical column expiry date preserved.
- **Distributor Stock (`sm_depot_stock_balance`)**: Positioned under Distributor Info (`/depot-stock-balance`). Features dropdown selection of active Distributor, Store (filtered/cascaded by distributor), Item, and Batch (dynamically populated via `/api/item/batches?item_id=...`). Unique on `(cid, depot_id, store_id, item_id, batch_id)`. Strictly non-editable (`no_edit: True`), non-deletable (`no_delete: True`), and non-importable (`no_import: True`); edit, delete, and import endpoints redirect with danger flash, and corresponding action buttons and templates are suppressed across UI. Has no status column. Auto-provisions zero-quantity stock records (`quantity=0`, `block_qty=0`, `batch_id='1'`, BR3 default expiry date) via 3 hooks: on Item creation/import (across all stores), on Distributor creation (across default stores × all items), and on Distributor Store creation (across that store × all items). Historical column expiry date preserved.
- **Distributor Store Filter & Immutability (`sm_depot_store`)**: List view includes a Distributor (`depot_id`) dropdown filter. On `/distributor-store/edit/{id}`, the Distributor option is strictly non-editable (`readonly_on_edit=True` with disabled select, hidden input, and backend enforcement in `depot_store_prepare`).
- **Distributor Status Cascade & Immutability (`sm_depot`)**: Inactivating (`status='INACTIVE'`) or soft-deleting (`status='PENDING'`) a Distributor automatically propagates that status change to all its child stores in `sm_depot_store`. Restoring (`status='ACTIVE'`) a Distributor restores all child stores to `ACTIVE`. On `/distributor/edit/{id}`, Distributor ID (`depot_id`) is strictly non-editable (`readonly_on_edit=True` and backend immutability in `depot_prepare`).

### 2.4.3 Fieldforce Modules & User Journeys (Fieldforce Info)
- **National Structure (`sm_top_level`)**: 4-tier tree: National (depth 0, prefix `H`), Area (depth 1, prefix `A`), Zone (depth 2, prefix `Z`), Territory (depth 3, prefix `T`). Territory is max depth (leaf; cannot have children). Auto-incremental codes (`H0001`, `A0001`, `Z0001`, `T0001`), parent lineage `level0..level3`, tree visualization, accordion collapse, image attachment, and dynamic `is_leaf` recomputation.
- **Field Structure (`sm_level`)**: 4-tier market coverage tree: Territory (depth 0, prefix `T`, parent Zone sourced dynamically from `sm_top_level` depth 2 active list; Territory name/code filtered from `sm_top_level` depth 3 active list under selected Zone; inserts `level_id`, `level_name`, `parent_level_id`, `parent_level_name`), Town (depth 1, prefix `TW`, distributor tagging exposed), Route (depth 2, prefix `R`, auto-inherits Town distributor), Beat (depth 3, prefix `B`, auto-inherits Town distributor). Beat is max depth (leaf; cannot have children). Auto-incremental codes for child depths (`TW0001`, `R0000006`, `B0000033`), parent lineage `level0..level3`, town distributor cascading to routes/beats, and dynamic `is_leaf`.
- **Employee(rep/sup/dm)** (`sm_rep`): Fieldforce personnel master with dynamic user types from `sm_category_type` (`EMP_USER_TYPE`: `rep` for Pre Sales Executive / PSR, `sup` for Supervisor / Manager, `dm` for Delivery Man / DM). Unique keys on `(cid, rep_id)` (accepting NULL for integration) and `(cid, rep_username)` (`UNQ_REP_USERNAME`). Cascading dynamic dropdowns: user selects User Type first, which filters Designation (`rep` -> only `PSR`, `dm` -> only `DM`, `sup` -> all designations except `PSR` and `DM`). On create (`/rep/create`), `Employee ID` (`rep_id`) is hidden (`hide_on_create=True`) to avoid user confusion and auto-generated on save prefixed by designation code (`PSR0001`, `DM0001`, `HOS0001`, `SOM0001`, etc.); on edit and view, `rep_id` is visible (readonly on edit). Required `rep_username` ("Username") field captured and validated for uniqueness across `(cid, rep_username)`. Optional Date of Birth (`dob`) and Date of Joining (`doj`) across create, edit, and Excel import (stored as `NULL` when omitted). Automatic MD5 password encryption on create/update with blank password retention on edit. Photo upload (`image_path`) with file preview under `/static/uploads/sm_rep_{name}_image_{timestamp}.{ext}`. Form rearranged logically: User Type & Designation first, then Username, Names, Contact, Dates & Compliance, Address, Password & Status, with Distributor and Photo / Image placed directly before Note.
- **Supervisor Area Assignment (`sm_supervisor_level`)**: Allows assigning a supervisor (`sm_rep.user_type='sup'`) to any hierarchy node across National (`sm_top_level`) or Field (`sm_level`) structures, storing `sup_id`, `level_id`, and `level_depth_no`.
- **PSR Area Assignment & Cascading Beat Population (`sm_rep_area`)**: Field representative (`sm_rep.user_type='rep'`) assigned specifically to a Route (`sm_level` depth 2). The create/edit form presents a PSR picker and Route picker; on submission, the system resolves all active child Beats under the chosen Route and bulk-inserts individual records into `sm_rep_area`.
- **PSR Visit Plan (`sm_visit_plan`)**: Extended beat-to-day schedule automatically populated upon Route/Beat assignment in `sm_rep_area`. Maps Beat to `order_col_day` (Saturday..Friday); automatically computes and persists `delivery_day` as the subsequent calendar day.
- **Outlet Exceptional Visit Plan (`sm_client_visit_plan`)**: Exceptional scheduling interface for outlets (`client_id`) within an area (`area_id`), specifying visit frequency, active week indicators (`w1..w5`), and weekday matrix flags (`sat..fri`).

### 2.5 Administration
- **Users**: create/edit (name, email, password reset, super flag, status, role checkboxes), soft delete/restore; cannot deactivate own account.
- **Roles**: create/edit with permission checkboxes grouped by module; soft delete.
- **Permissions**: read list + create new entries.

### 2.6 Audit Log (`/audit-log`)
Filter by table, action, user, free text; expandable old/new JSON values; paginated.

## 3. Module hooks (business logic)

| Hook | Detail |
|---|---|
| `hierarchy.prepare` | Auto level code per `LEVEL_PREFIX` (padded sequence, values in `brain/INDEX.md` §1), max depth 3, name-uniqueness under parent, path fill, new rows start `is_leaf=1` |
| `hierarchy.after_create` | Parent leaf flag recomputed (`is_leaf=0` once it has an ACTIVE child) |
| `hierarchy.after_update` | Rename propagation to `parent_level_name` and `level{n}_name` of descendants; node + parent leaf flags recomputed from ACTIVE children |
| `hierarchy.soft_delete/restore` | Subtree cascading with parent-active check on restore; parent leaf flag recomputed on both (deleted last child → parent leaf again) |
| `crud image upload` | Any form field of type `image` (brand `image_path` today): multipart read, extension/size validation, `{table}_{slug}_image_{timestamp}` naming, file written only after the row insert/update succeeds |
| `item.after_create` | Default batch per BR3 (hook: `app/hooks.py item_after_create`); auto-provisions Distributor Stock rows (qty=0, block_qty=0) across all stores |
| `depot.after_create` | Default stores per BR5 (hook: `app/hooks.py depot_after_create`); auto-provisions Distributor Stock rows (qty=0, block_qty=0) across default stores × all items |
| `item_batch.prepare` | Item existence, auto name, uniqueness per item |
| `rack.prepare` | Validates rack_id format/uniqueness; enforces immutability of `rack_id` on edit |
| `depot.prepare` | Uniqueness + name resolution; synchronizes `town_id` and `town_name` with `sm_level` (depth 1 Town); enforces immutability of `depot_id` on edit |
| `depot.after_update` | Cascades status updates (ACTIVE/INACTIVE/PENDING) from Distributor to all child stores in `sm_depot_store` |
| `depot.soft_delete/restore` | Soft delete sets Distributor to PENDING and cascades PENDING to child stores; restore sets Distributor to ACTIVE and cascades ACTIVE to child stores |
| `depot_store.prepare` | Depot existence, uniqueness per depot; enforces immutability of `depot_id` on edit |
| `depot_store.after_create` | Auto-provisions Distributor Stock rows (qty=0, block_qty=0) across created store × all items |
| `depot_stock_balance.prepare` | Validates distributor, store, item, batch existence; resolves store_name and expiry date; sanitizes quantities (no status validation) |
| `outlet.prepare` | Client ID uniqueness, category & sub-category resolution, auto-generated customer_type (`category_id|category_name`), distributor & store validation |
| `supervisor_level.prepare` | Client ID uniqueness, category & sub-category resolution, auto-generated customer_type (`category_id|category_name`), distributor & store validation |
| `rep_area.prepare` | Client ID uniqueness, category & sub-category resolution, auto-generated customer_type (`category_id|category_name`), distributor & store validation |
| `item.prepare` / `category_type.prepare` | Uniqueness + name resolution from hierarchy ids |
| `top_level.prepare` | Auto level code per prefix (`H`, `A`, `Z`, `T`), max depth 3 (Territory), name uniqueness under parent, path fill `level0..level3`, initial `is_leaf=1` |
| `top_level.after_create/update/delete` | Leaf flag recomputation and subtree rename propagation |
| `level.prepare` | Auto level code per prefix (`TW`, `R`, `B`), depth 0 Territory parent Zone sourced dynamically from `sm_top_level` depth 2 active list and Territory name/code filtered by Zone from depth 3 active list (injects `level_id`, `level_name`, `parent_level_id`, `parent_level_name`), distributor tagging on Town (depth 1), auto-inheritance of distributor on Route/Beat, max depth 3 (Beat), path fill, initial `is_leaf=1` |
| `level.after_create/update/delete` | Leaf flag recomputation, subtree rename propagation, and Town distributor change cascade to all child Routes and Beats (`level1 = town.level_id`) |
| `rep.prepare` | Generation of immutable `rep_id` from designation prefix sequence (`HOS`, `SOM`, `ASM`, `ASE`, `CE`, `PSR`, `DM`), `(cid, rep_id)` uniqueness validation, user_type (`rep`/`sup`) validation |
| `rep_area.after_create` | Resolves all active child Beats under selected Route (`sm_level` depth 2), bulk-inserts Beat rows into `sm_rep_area`, and triggers creation of corresponding `sm_visit_plan` records |
| `visit_plan.prepare` | Validates `order_col_day` (Saturday..Friday) and automatically sets `delivery_day` as the next calendar day |
| `client_visit_plan.prepare` | Validates outlet existence, area match, and normalizes weekly (`w1..w5`) and day (`sat..fri`) flags |

## 4. Permissions catalogue (seed)

`dashboard.view`; per module `{brand,item,item_batch,distributor,depot_store,outlet,category_type}.{view,create,edit,delete,import}`; `acl.view`, `acl.manage`; `audit.view` — 39 seeded permissions (catalogue: `SEED_PERMISSIONS` in `scripts/setup_database.py`), roles SUPER_ADMIN (all), MANAGER, VIEWER.

## 5. Acceptance criteria (verified 2026-11-05; brand UX re-verified 2026-11-09)

- Creating a flavor under TG001 auto-codes `FG003` and flips TG001 `is_leaf` to 0.
- Brand leaf invariant holds through the whole lifecycle: create without children → `is_leaf=1`; add child → parent `0`/child `1`; rename → unchanged; soft-delete the last child → parent back to `1`; restore → parent `0` again.
- Brand tree (verified in-browser): on page load only the depth-0 node shows its children; opening a second node in the same level collapses the first; toggling again closes the node.
- Brand create accepts an image file; the file is stored under `/static/uploads/` with the `{table}_{slug}_image_{timestamp}` name, the URL is saved in `image_path` and serves with HTTP 200; editing with no file keeps the current image; a non-image extension is rejected with a visible error.
- Brand edit page lists child levels and accepts multiple names in one submit (duplicates ignored); each child gets its own auto-code and audit row.
- Creating item `1101` creates the default batch (BR3); audit rows `CREATE sm_item`, `CREATE sm_item_batch` written.
- Creating distributor `131313` auto-creates stores `131313140` (Commercial) and `131313170` (Damage).
- Excel template download 200; upload creates rows and reports errors; soft delete → PENDING; restore → ACTIVE; each logged in `sm_audit_log`.
- VIEWER can browse but every write action is blocked; unknown modules redirect to the dashboard.
