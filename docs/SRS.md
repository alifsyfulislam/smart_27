# Software Requirements Specification (SRS)
## Secondary Sales Management System (SSMS)

**Version:** 1.0.0 · **Implements:** docs/PRD.md · **Runtime:** Python 3.11 (venv) · **DB:** MariaDB 10.4/MySQL 8, schema `smart_27`

---

## 1. System architecture

```
Request → FastAPI (app/main.py)
   ├── SessionMiddleware (signed cookie, 8h)          [outermost]
   ├── auth_gate middleware (redirects → /login)
   │      └── ctx.current_user(request)
   ├── Routers
   │     ├── core.py        /login /logout / (dashboard) /audit-log
   │     ├── acl_admin.py   /users /roles /permissions (+POST actions)
   │     └── crud.py        generic module CRUD + Excel + /api JSON
   ├── ctx.py (menu/flash/perms) · security.py (ACL) · audit.py (change log)
   ├── modules.py (module registry) · hooks.py (business rules)
   └── database.py (PyMySQL, raw SQL) → MySQL/MariaDB smart_27
Templates: Jinja2 (app/templates) · Static: app/static (FontAwesome local)
```

## 2. Functional requirements

### FR1 Authentication
- FR1.1 `POST /login` verifies `sm_acl_user.user_id` (ACTIVE) with PBKDF2-SHA256 (120k iters, 16-byte salt).
- FR1.2 Session stores `uid`; sign-out clears session; LOGIN/LOGOUT actions logged.

### FR2 Access control
- FR2.1 Permission resolution = union of role permissions + direct user permissions; `is_super=1` bypasses everything (cache invalidated on role/perm edits).
- FR2.2 All module actions require `module.action` permission; ACL screens require `acl.view`/`acl.manage`; audit requires `audit.view`.
- FR2.3 Unauthenticated access to any page redirects to `/login`; unknown module slugs redirect to `/`.

### FR3 Master modules (per module M of `app/modules.py`)
- FR3.1 `GET /{slug}` — list: cid-filtered, free-text search (configurable `search_cols`), dropdown filters with typeahead search and multi-select support, compact high-density layout (minimized cell and container padding/margins), ORDER, LIMIT/OFFSET pagination, page-size select. Brand renders the full hierarchy as a tree instead: nodes at depth 0 start expanded (server-side `open` class), deeper nodes collapsed; `app/static/js/app.js` toggles nodes with a per-level accordion — expanding a node collapses the other open nodes under the same parent.
- FR3.2 `GET/POST /{slug}/create` — form → `values_from_form` → hook prepare → insert (`touch` stamps cid/created_on/by) → hook after_create → audit CREATE.
- FR3.3 `GET/POST /{slug}/edit/{id}` — existing merged with submitted values → hook prepare (dup checks) → update → after_update/hook → audit UPDATE (old+new snapshots).
- FR3.4 `GET /{slug}/view/{id}` — read-only render.
- FR3.5 `POST /{slug}/delete/{id}` — soft delete to PENDING (hierarchy: subtree cascade) → audit DELETE.
- FR3.6 `POST /{slug}/restore/{id}` — back to ACTIVE (hierarchy: parent-active check) → audit RESTORE.
- FR3.7 `GET /{slug}/template` — xlsx template (uppercase headers + code row + example row).
- FR3.8 `POST /{slug}/upload` — openpyxl parse, header→column mapping, per-row insert through the same hooks; summary flash + row errors; template mismatch and empty files rejected.
- FR3.9 `GET /api/hierarchy/children?parent=X` — JSON children for cascade selects (used by the item form and API consumers).
- FR3.10 `POST /{slug}/add-children/{id}` (brand) — create one or many child levels under a node from the edit page: `child_names[]` form list, deduped, each routed through the same hook + audit pipeline; per-name error report in the flash; requires `brand.create`.
- FR3.11 Image fields (`type: "image"` in the module registry, brand `image_path`): multipart form (`enctype=multipart/form-data`), input named `{col}_file`; validation = extension whitelist (png/jpg/jpeg/gif/webp) + 5 MB cap; stored under `app/static/uploads` as `{table}_{name-slug}_image_{timestamp}.{ext}`; `image_path` gets the `/static/uploads/...` link; file written only after the DB write succeeds (no orphans on validation failure); edit with an empty input keeps the existing image.
- FR3.12 `GET /{slug}/export` & `/{slug}/download` — Excel data export respecting active filters (`qk`, `status`, category/brand dropdowns): visible page rows (`page`, `page_size`) or all matching records (`scope=all`). For hierarchy (`brand`), generates a 2-sheet workbook (`HIERARCHY_TREE` with visual level indentation + `HIERARCHY_PATHS` flattened leaf paths). For hierarchy-synced items (`item`), generates `ITEMS` with synchronized company, brand, type, and flavor names/codes. All sheets formatted with openpyxl (brand blue `#1877F2` headers, alternating zebra striping `#F8F9FA`, auto-fitted column widths, freeze panes, and visible gridlines).
- FR3.13 Dynamic Form Dropdowns & Hierarchy Cascade Hydration — Standard option label syntax across all dynamic select dropdowns is `{id} | {name}` (e.g., `BG001 | Kurkure`). In the searchable single-select component (`.searchselect`), focusing or clicking the search input displays all available options without filtering on placeholder strings (such as `-- Company --`). On Item edit, the client sequentially loads and pre-selects stored hierarchy associations (`company_id`, `brand_id`, `type_id`, `flavor_id`) by requesting `/api/hierarchy/children?parent={id}` iteratively, synchronizing hidden inputs and triggering `ssms-refresh` events. Foreign-key dropdowns (`hier_root_select`, `item_select`, `depot_select`, `store_select`) follow the same `{id} | {name}` formatting across Create and Edit forms.

### FR4 Business rules (hooks)
- FR4.1 Hierarchy codes: prefix map per `app/hooks.py LEVEL_PREFIX` (values: `brain/INDEX.md` §1), `{prefix}{seq:03d}` continuing per prefix; depth = parent.depth+1; full path `level0..level3`; new rows start `is_leaf=1`.
- FR4.1a Leaf invariant: `is_leaf='1'` iff the node has no ACTIVE child — recomputed by `_recompute_is_leaf` on create (parent), update (node + parent), soft delete (parent) and restore (parent + node).
- FR4.2 Depth cap: cannot create below flavor (max depth 3).
- FR4.3 Rename propagates to descendants; soft-delete/restore cascade the subtree.
- FR4.4 Item create → default batch (BR3; hook `item_after_create`, ON DUPLICATE-safe). On view, hierarchy displays formatted text without select inputs; Item ID is readonly and immutable on edit.
- FR4.5 Depot create → default stores (BR5; hook `depot_after_create`). Distributor ID (`depot_id`) is strictly non-editable on edit (`readonly_on_edit=True` and `depot_prepare`). Inactivating (`status='INACTIVE'`), soft-deleting (`status='PENDING'`), or restoring (`status='ACTIVE'`) a Distributor automatically cascades that status change to all its child stores in `sm_depot_store`.
- FR4.6 Uniqueness: item by cid+item_id; batch by cid+item_id+batch_id; store by cid+depot_id+store_id; category by cid+type_name+cat_type_id; rack by cid+rack_id; stock balance by cid+depot_id+store_id+item_id+batch_id; name dup within same hierarchy parent. On edit, batch Item selector and distributor store Distributor selector are disabled and immutable.
- FR4.7 Category values for type names map from `sm_category_type` groups (DISTRIBUTOR_CATEGORY, STORE_TYPE, ITEM_CATEGORY, ITEM_UNIT, ITEM_PACK, OUTLET_CATEGORY, OUTLET_SUB_CATEGORY — see `SEED_CATEGORY_TYPES`).

- FR4.8 Outlet (`sm_client`): uniqueness cid+client_id; category/sub-category resolution; auto-generated customer_type (`category_id|category_name`); depot and store validation against `sm_depot` and `sm_depot_store`.
- FR4.9 National Structure (`sm_top_level`): 4-tier tree: National (depth 0, prefix `H`), Area (depth 1, prefix `A`), Zone (depth 2, prefix `Z`), Territory (depth 3, prefix `T`). Territory is max depth (leaf); auto-incremental codes (`H0001`, `A0001`, `Z0001`, `T0001`), parent lineage `level0..level3`, and dynamic `is_leaf` recomputation. Parent Level options restricted to Root and depth 0 active records; image input removed.
- FR4.10 Field Structure (`sm_level`): 4-tier market coverage: Territory (depth 0, prefix `T`, parent Zone sourced dynamically from `sm_top_level` depth 2 active list; Territory name/code filtered from `sm_top_level` depth 3 active list under selected Zone; inserts `level_id`, `level_name`, `parent_level_id`, `parent_level_name`), Town (depth 1, prefix `TW`, distributor tagging exposed), Route (depth 2, prefix `R`, auto-inherits Town distributor), Beat (depth 3, prefix `B`, auto-inherits Town distributor). Beat is max depth (leaf); auto-incremental codes for child depths (`TW0001`, `R0000006`, `B0000033`), parent lineage `level0..level3`, town distributor cascading to routes/beats, and dynamic `is_leaf`. In `/level/create` and `/level/edit`, Parent Level options are sourced dynamically from active Zones in National Structure (`sm_top_level` depth 2, `status='ACTIVE'`); Territory level name suggestions dynamically filter and load active National Structure Territories (`sm_top_level` depth 3) under that chosen Zone.
- FR4.11 Employee(rep/sup/dm) (`sm_rep`): Managed via integration or manual creation; unique on `(cid, rep_id)` (where `rep_id` accepts NULL for external integration records) and `(cid, rep_username)` (`UNQ_REP_USERNAME`). User type sourced dynamically from `sm_category_type` (`EMP_USER_TYPE`: `rep` for Pre Sales Executive / PSR, `sup` for Supervisor / Manager, `dm` for Delivery Man / DM). Dynamic cascading dropdown: User Type selected first, loading filtered Designation options (`rep` -> `PSR` only; `dm` -> `DM` only; `sup` -> all designations except `PSR` and `DM`). On create (`/rep/create`), `Employee ID` (`rep_id`) is hidden (`hide_on_create=True`) to avoid user confusion and auto-generated on save prefixed by designation code: `PSR0001`, `DM0001`, `HOS0001`, `SOM0001`, `ASM0001`, `ASE0001`, `CE0001` (4-digit zero-padded sequence); on edit and view, `rep_id` remains visible (readonly on edit). Required `rep_username` ("Username") field captured and validated for uniqueness across `(cid, rep_username)`. Optional Date of Birth (`dob`) and Date of Joining (`doj`) across create, edit, and Excel import (stored as `NULL` when omitted). Automatic MD5 password encryption on create/update with empty password retention on edit. Photo upload (`image_path`) with file preview under `/static/uploads/sm_rep_{name}_image_{timestamp}.{ext}`. Form rearranged logically: User Type & Designation first, then Username, Names, Contact, Dates & Compliance, Address, Password & Status, with Distributor and Photo / Image placed directly before Note.
- FR4.12 Supervisor Area Assignment (`sm_supervisor_level`): Allows assigning supervisors (`sm_rep` with `user_type='sup'`) to any hierarchy node across National or Field structures (`sup_id`, `level_id`, `level_depth_no`). Unified depth `level_depth_no` evaluates as `sm_top_level.depth` for National levels (0=Head, 1=Area, 2=Zone, 3=Territory) and `3 + sm_level.depth` for Field levels (3=Territory, 4=Town, 5=Route, 6=Beat). Form provides Hierarchy Tier Filter (`f-hierarchy_tier`), searchable select (`data-searchable`), and dynamic calculated depth badge.
- FR4.13 PSR Area Assignment & Cascading Beat Population (`sm_rep_area`): Reps (`sm_rep` with `user_type='rep'`) assigned exclusively to Route (`sm_level` depth 2). Form takes PSR and Route; saving triggers automated resolution of all active Beats under that Route and bulk-inserts individual Beat records into `sm_rep_area`.
- FR4.14 PSR Visit Plan (`sm_visit_plan`): Concurrently populated upon Route/Beat assignment in `sm_rep_area`. Maps Beat to `order_col_day` (Saturday..Friday); automatically derives `delivery_day` as the next calendar day.
- FR4.15 Outlet Exceptional Visit Plan (`sm_client_visit_plan`): Enables custom outlet scheduling by mapping an outlet (`client_id`) within an area (`area_id`) with visit frequency, weekly cycle flags (`w1`..`w5`), and weekday matrix flags (`sat`..`fri`).
- FR4.16 Rack Master (`sm_rack`): Managed under Item Info (`/rack`). Unique on `(cid, rack_id)`. `rack_id` is immutable on edit (`readonly_on_edit=True` and `rack_prepare`). Supports image upload parity with `sm_item` (PNG/JPG/GIF/WEBP up to 5 MB saved under `/static/uploads/sm_rack_{slug}_image_{timestamp}.{ext}`). Preserves historical schema column expiry date.
- FR4.17 Distributor Stock (`sm_depot_stock_balance`): Managed under Distributor Info (`/depot-stock-balance`). Unique on `(cid, depot_id, store_id, item_id, batch_id)` (`UNQ_DEPOT_STORE_ITEM_BATCH`). Features dropdown selection for active Distributor, Store, Item, and dynamic Batch (`/api/item/batches?item_id=...`). Editing, deleting, and Excel importing are strictly prohibited (`no_edit: True`, `no_delete: True`, `no_import: True`; edit, delete, and import endpoints redirect with danger flash, and action buttons and templates are suppressed across UI). Has no status column. Auto-provisions zero-quantity stock records (`quantity=0`, `block_qty=0`, `batch_id='1'`, BR3 default expiry date) via 3 hooks: on Item creation/import (across all stores), on Distributor creation (across default stores × all items), and on Distributor Store creation (across that store × all items). Preserves historical schema column expiry date.

### FR5 Audit
- FR5.1 `sm_audit_log` rows: table_name, record_key (business id), action, old_values/new_values JSON snapshots, changed_by, user_ip, note.
- FR5.2 App-only; failures to log never break the business transaction.

### FR6 Admin screens
- FR6.1 Users: create/edit/soft-delete/restore + role assignment; self-deactivation blocked.
- FR6.2 Roles: create/edit (permission matrix by module) /soft delete.
- FR6.3 Permissions: list + create; catalogue seeded at bootstrap.
- FR6.4 `sm_audit_log` viewer with table/action/user filters and expandable JSON.

## 3. Data model

Tables (scripts/ddl.sql, exact names/columns from requirements):

| Table | Purpose / changes vs. provided DDL |
|---|---|
| `sm_item_hierarchy` | + `status` (soft delete); `image_path` now stores a generated `/static/uploads/...` link written by the upload handler (files on disk under `app/static/uploads/`) |
| `sm_item`, `sm_item_batch` | provided; `sm_item_batch` + `status` |
| `sm_rack` | Item rack master with `image_path` upload parity, immutable `rack_id`, `issue_date`, expiry date, and `status` |
| `sm_depot`, `sm_depot_store` | provided; `sm_depot_store` + `status` |
| `sm_depot_stock_balance` | Distributor store item batch inventory balances; non-editable/non-deletable/non-importable master record with `quantity`, `block_qty`, expiry date, unique on `(cid, depot_id, store_id, item_id, batch_id)`, no `status` column |
| `sm_category_type` | + `status` |
| `sm_client` | provided client/outlet master + `status` |
| `sm_top_level` | National structure hierarchy (National > Area > Zone > Territory) with lineage `level0..level3`, `is_leaf`, `depth`, `image_path` |
| `sm_level` | Field structure hierarchy (Territory > Town > Route > Beat) with lineage `level0..level8`, `is_leaf`, `depth`, `depot_id` |
| `sm_rep` | Fieldforce employee master with dual user types (`rep`, `sup`), designation-based immutable auto IDs, credentials, and sync metadata. Unique `(cid`, `rep_id)` and `(cid`, `rep_username)` |
| `sm_supervisor_level` | Supervisor area assignments mapping `sup_id` to any hierarchy node (`level_id`, `level_depth_no`) |
| `sm_rep_area` | PSR area assignments mapping `rep_id` to Route and cascaded active Beats (`area_id`, `depot_id`) |
| `sm_visit_plan` | PSR visit scheduling mapping rep, beat/area, `order_col_day`, and auto-derived `delivery_day` |
| `sm_client_visit_plan` | Outlet exceptional visit plan mapping `client_id`, `area_id`, frequency, week flags (`w1`..`w5`), and weekday matrix (`sat`..`fri`) |
| `sm_acl_user/role/permission`, `sm_acl_user_role`, `sm_acl_user_permission`, `sm_acl_role_permission` | new ACL tables (varchar business keys FK-free, cid-scoped unique) |
| `sm_audit_log` | new central change log (longtext JSON snapshots) |

Key types used: `int AUTO_INCREMENT` PKs, unique/normal keys as in requirements (DESC keys normalized for MariaDB compatibility), `utf8` charset under MariaDB 10.4 (maps to utf8mb3), `double` for prices/weights.

## 4. Configuration & operations

- DB: host `localhost`, user `root`, password empty, database `smart_27` (env-overridable: `SSMS_DB_HOST/PORT/USER/PASS/NAME`).
- Bootstrap: `scripts/setup_database.py` (creates DB + schema + seed); the app also auto-bootstraps on startup.
- Run: `./venv/Scripts/python -m uvicorn app.main:app --host 127.0.0.1 --port 8027`.
- Default admin: see `AGENTS.md` (change immediately).
- Dependencies: `requirements.txt` (fastapi, uvicorn, jinja2, pymysql, cryptography, python-multipart, openpyxl, itsdangerous). No CDN assets — FontAwesome 6.5.2 downloaded to `app/static/vendor`.

## 5. Verification summary (2026-11-05)

Login 303→dashboard 200; all module lists 200; brand create → FG003; item create → default batch; depot create → 2 default stores; template download (5.3KB) + upload import; delete → PENDING; restore → ACTIVE; audit log records CREATE/DELETE/RESTORE/LOGIN; VIEWER restrictions enforced; /users /roles /permissions screens 200 (GET /users/create correctly redirects).
