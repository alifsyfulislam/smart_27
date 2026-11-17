
# Business Requirements Document (BRD)
## Secondary Sales Management System (SSMS)

**Version:** 1.0.0 · **Date:** 2026-11-05 · **Database:** smart_27 (MySQL 8 / MariaDB 10.4) · **Stack:** FastAPI web app (Flutter app planned later)

---

## 1. Purpose

SSMS manages the **master data** required before secondary-sales transactions can run:

- Item hierarchy (Company → Brand → Type → Flavor)
- Items and their batches
- Distributors (depots) and their stores
- Outlets and their distributor, store, and category relationships
- Fieldforce structure, employee assignments, and visit plans
- Data-definition master (category types)

It enforces role-based access control and maintains a central audit trail of every master-data change.

## 2. Scope

**In scope (this release):**

1. **Item Info** — Brand (item hierarchy), Item, Item Batch, Rack.
2. **Distributor Info** — Distributor, Distributor Store, Distributor Stock.
3. **Outlet Info** — Outlet (client master with distributor, store, and category linkage).
4. **Fieldforce Info** — National Structure (`sm_top_level`), Field Structure (`sm_level`), Employee Master (`sm_rep`), Supervisor Area Assignment (`sm_supervisor_level`), PSR Area Assignment (`sm_rep_area`), PSR Visit Plan (`sm_visit_plan`), Outlet Exceptional Visit Plan (`sm_client_visit_plan`).
5. **Settings** — Category Type (data definitions for columns like `depot_category`, `store_type`, `pack_size`, `unit_type`, `item_category`).
6. **Access Control** — User / Role / Permission (ACL) with mapping tables.
7. **Records** — Central audit log written only by the application.

**Out of scope (future):** Sales orders, requisitions, deliveries, payments, invoicing, and the Flutter mobile client.

## 3. Business Rules

| # | Rule |
|---|---|
| BR1 | Item hierarchy levels are created manually (no integration). Levels: Company (C*) → Brand (B*) → Type (T*) → Flavor (F*), auto-coded per the level prefix map (`app/hooks.py LEVEL_PREFIX`; values in `brain/INDEX.md` §1) with parent path columns `level0..level3`. |
| BR2 | Leaf flag invariant: a hierarchy node has `is_leaf=1` **if and only if it has no ACTIVE child** — recomputed automatically on create, update, soft delete, and restore. Renaming a level propagates through descendant path columns. |
| BR3 | Items come from integration or manual creation; every item automatically gets a **default batch `1` with expiry 2100-12-31** (`sm_item_batch`). |
| BR4 | Items are tagged sequentially with Company > Brand > Type > Flavor from the hierarchy. |
| BR5 | Distributors come from integration or manual creation; every distributor automatically gets two default stores — **Commercial** and **Damage** (`sm_depot_store`; ID pattern: `app/hooks.py depot_after_create`, values in `brain/INDEX.md` §1). |
| BR6 | All master modules support: create, view, edit, **soft delete (status → PENDING)**, restore, and **template-based Excel batch upload**. |
| BR7 | Every master-table change (create/update/delete/restore) is recorded in the central log `sm_audit_log` **by the application only** — no DB triggers. |
| BR8 | Users are restricted by ACL: permissions like `item.view`, `item.create`, `item.edit`, `item.delete`, `item.import`, grouped under modules; roles bundle permissions; users get roles and/or direct permissions; a super-admin bypasses checks. |
| BR9 | `sm_category_type` feeds the value lists used by other modules (depot category, store type, item category, unit type). |
| BR10 | A brand (hierarchy) level may carry an **image**: uploaded files are stored under `app/static/uploads` as `{table}_{name-slug}_image_{timestamp}.{ext}` (PNG/JPG/GIF/WEBP, max 5 MB), and the generated link is saved in `image_path`. Editing can preview and replace the image; leaving the file input empty keeps the current one. |
| BR11 | From the Brand **edit page**, a user can add one or many **child levels** in a single submit (names deduped; each child flows through the normal auto-code/path/audit pipeline). A Flavor (depth 3) cannot have children. |
| BR12 | Outlets (`sm_client`) are linked to distributors and stores; customer type is auto-generated as `category_id\|category_name` from `sm_category_type` (groups `OUTLET_CATEGORY` and `OUTLET_SUB_CATEGORY`). |
| BR13 | Dynamic dropdown and foreign-key select fields (hierarchy levels, item lookup, distributor lookup, store lookup) must display selectable options in canonical `ID \| Name` format (e.g. `BG001 \| Kurkure`). In item create and edit forms, hierarchy cascade options must remain fully visible and searchable without placeholder filter occlusion. On edit, previously saved hierarchy associations must auto-hydrate sequentially from database values. |
| BR14 | **National Structure** (`sm_top_level`): 4-tier tree: National (depth 0, prefix `H`) > Area (depth 1, prefix `A`) > Zone (depth 2, prefix `Z`) > Territory (depth 3, prefix `T`). Territory is the maximum depth (leaf; cannot have children). Auto-incremental codes (`H0001`, `A0001`, `Z0001`, `T0001`) with parent lineage columns `level0..level3` and dynamic `is_leaf` recomputation. |
| BR15 | **Field Structure** (`sm_level`): 4-tier market coverage tree: Territory (depth 0, prefix `T`) > Town (depth 1, prefix `TW`) > Route (depth 2, prefix `R`) > Beat (depth 3, prefix `B`). In create and edit forms, Parent Level options are sourced dynamically from active Zones in `sm_top_level` (`depth 2`, `status='ACTIVE'`), and Territory name/ID suggestions are dynamically filtered and loaded based on the selected Parent Zone (`sm_top_level depth 2 → depth 3`, `parent_level_id = zone_id`), preventing mismatched selections and inserting `level_id`, `level_name`, `parent_level_id`, and `parent_level_name` directly from National Structure. Beat is the maximum depth (leaf; cannot have children). Auto-incremental codes (`TW0001`, `R0000006`, `B0000033`) for depths > 0 with lineage columns `level0..level3` and dynamic `is_leaf`. Distributor tagging (`depot_id`) is exposed in create/edit forms exclusively at Town level (`depth 1`); child Routes (`depth 2`) and Beats (`depth 3`) automatically inherit the Town's distributor, and updates to a Town's distributor automatically cascade across all child Routes and Beats under that Town. |
| BR16 | **Employee(rep/sup/dm)** (`sm_rep`): Managed via integration or manual creation; unique on `(cid, rep_id)` where `rep_id` accepts NULL for external integration records, and unique on `(cid, rep_username)` (`UNQ_REP_USERNAME`). User type is sourced dynamically from `sm_category_type` (`EMP_USER_TYPE`: `rep` = Pre Sales Executive / PSR, `sup` = Supervisor / Manager, `dm` = Delivery Man / DM). Dynamic cascading dropdown: User Type is selected first, filtering Designation options (`rep` loads only `PSR`, `dm` loads only `DM`, `sup` loads all designations except `PSR` and `DM`). On create (`/rep/create`), `Employee ID` (`rep_id`) is hidden (`hide_on_create=True`) to avoid user confusion and is auto-generated on save with designation prefix code: `PSR0001`, `DM0001`, `HOS0001`, `SOM0001`, `ASM0001`, `ASE0001`, `CE0001` (4-digit zero-padded sequence); on edit (`/rep/edit/{id}`) and view (`/rep/view/{id}`), `rep_id` remains visible (readonly on edit). The `rep_username` ("Username") field is captured on manual forms (required) and verified for uniqueness. Dates `dob` (Date of Birth) and `doj` (Date of Joining) are optional across create, edit, and Excel import (stored as `NULL` when omitted). Passwords entered in plain text are encrypted using MD5; editing with an empty password retains the existing hash. Profile photo upload (`image_path`) mirrors `sm_item` image handling (PNG/JPG/WEBP up to 5 MB stored under `/static/uploads/sm_rep_{name}_image_{timestamp}.{ext}`). Form fields arranged logically with Distributor (`depot_id`) and Photo / Image (`image_path`) positioned directly before Note. |
| BR17 | **Supervisor Area Assignment** (`sm_supervisor_level`): Supervisors (`sm_rep` where `user_type='sup'`) can be assigned to any administrative or field tier across National Structure (`sm_top_level`) or Field Structure (`sm_level`), stored with `sup_id`, `level_id`, and unified `level_depth_no`. Depth is computed as `sm_top_level.depth` for National levels (National=0, Area=1, Zone=2, Territory=3) and `sm_top_level max depth (3) + sm_level.depth` for Field levels (Territory=3, Town=4, Route=5, Beat=6). Form `/supervisor-level/create` and edit provide a Hierarchy Tier Filter (`f-hierarchy_tier`) that instantly narrows down the searchable `level_id` dropdown (`data-searchable`) by administrative/field tier with live calculated depth badge indication, eliminating search difficulty on large datasets. |
| BR18 | **PSR Area Assignment & Cascading Beat Population** (`sm_rep_area`): Field representatives (`sm_rep` where `user_type='rep'`) can only be assigned to a Route (`sm_level` depth 2). The assignment form accepts PSR and Route selection; upon save, the engine automatically resolves all active child Beats under that Route and bulk-inserts individual Beat records into `sm_rep_area`. |
| BR19 | **PSR Visit Plan** (`sm_visit_plan`): Simultaneous with Route/Beat assignment (`sm_rep_area`), the system auto-populates visit plan rows in `sm_visit_plan`, mapping each Beat to an order collection day (`order_col_day` in Saturday..Friday). The corresponding delivery day (`delivery_day`) is automatically derived as the immediate next calendar day. |
| BR20 | **Outlet Exceptional Visit Plan** (`sm_client_visit_plan`): Enables custom, non-standard outlet scheduling by mapping an outlet (`client_id`) within an area (`area_id`) with visit frequency, weekly cycle flags (`w1`..`w5`), and weekday matrix flags (`sat`..`fri`). |
| BR21 | **Rack Master** (`sm_rack`): Managed under Item Info (`/rack`). Supports manual creation, view, edit, soft delete, restore, and Excel import. Mirrored image upload parity with `sm_item` (PNG/JPG/GIF/WEBP up to 5 MB saved under `app/static/uploads/sm_rack_{slug}_image_{timestamp}.{ext}`). Unique on `(cid, rack_id)`. The `rack_id` is immutable on edit. Preserves historical schema column expiry date. |
| BR22 | **Distributor Stock** (`sm_depot_stock_balance`): Managed under Distributor Info (`/depot-stock-balance`). Records inventory balances per distributor, store, item, and batch. Create form renders dropdown selectors for active Distributor, Store, Item, and Batch. Unique on `(cid, depot_id, store_id, item_id, batch_id)`. Editing, deleting, and Excel importing are strictly prohibited (`no_edit: True`, `no_delete: True`, `no_import: True`; action endpoints redirect with error flash and corresponding buttons are suppressed). Does not carry a `status` column. Features automatic stock row provisioning with quantity 0 and blocked quantity 0 across three triggers: (1) creating/importing an item auto-provisions across all stores, (2) creating a distributor auto-provisions across its default stores &times; all items, (3) creating a store auto-provisions across that store &times; all items. Preserves historical schema column expiry date. |
| BR23 | **Distributor Store Filter & Readonly Distributor** (`sm_depot_store`): The `/distributor-store` list page provides a Distributor dropdown filter. On `/distributor-store/edit/{id}`, the Distributor selector is disabled/non-editable (`readonly_on_edit=True` with hidden input fallback and server-side immutability in `depot_store_prepare`), preventing reassignment to another distributor. |
| BR24 | **Distributor Status Cascade & Readonly Distributor ID** (`sm_depot`): Inactivating (`status='INACTIVE'`) or soft-deleting (`status='PENDING'`) a Distributor automatically cascades that status change to all its child stores in `sm_depot_store`. Restoring (`status='ACTIVE'`) a Distributor cascades `ACTIVE` status back to its child stores. On `/distributor/edit/{id}`, Distributor ID (`depot_id`) is strictly non-editable (`readonly_on_edit=True` with server-side immutability in `depot_prepare`). |

## 4. Users

- **Super Administrator** — Full access; manages users, roles, and permissions.
- **Sales Manager** — Manages items, batches, hierarchy, and distributors (no Excel import in seed).
- **Read Only (VIEWER)** — View-only access.
- **Integration/system processes** (future) — Will write via separate `intr_flag` flows.

## 5. Non-functional Needs

- Login page + collapsible sidebar dashboard, with a modern and optimized layout.
- Responsive design; Facebook-like font/background colors and an eye-comfort palette.
- Sidebar accordion: opening one navigation group automatically collapses the others, with smooth transitions.
- Font Awesome icons served **locally** (no CDN).
- Search, filters, and pagination on every list.
- Column filters support typeahead search and multi-select.
- High-density compact view: minimal margins and padding across tables, cards, and filter controls to maximize visible data and eliminate wasted screen space.
- Runs in a Python virtual environment.
- Default admin credentials per `AGENTS.md`, to be changed after first login.

## 6. Success Criteria

- A super admin can create the sample hierarchy (TCPL example), an item with its default batch, and a distributor with its default stores without touching SQL.
- Every action above appears in the audit log with old/new values and the acting user.
- A VIEWER-role user cannot create or edit anything and cannot open admin screens.
- Excel templates download and import round-trips cleanly, reporting per-row errors.
