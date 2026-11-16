# Business Requirements Document (BRD)
## Secondary Sales Management System (SSMS)

**Version:** 1.0.0 · **Date:** 2026-11-05 · **Database:** smart_27 (MySQL 8 / MariaDB 10.4) · **Stack:** FastAPI web app (Flutter app planned later)

---

## 1. Purpose

SSMS manages the **master data** required before secondary-sales transactions can run:
item hierarchy (Company → Brand → Type → Flavor), items and their batches, distributors
(depots) and their stores, plus the data-definition master (category types). It enforces
role-based access control and keeps a central audit trail of every master-data change.

## 2. Scope

In scope (this release):
1. **Item Info** — Brand (item hierarchy), Item, Item Batch.
2. **Distributor Info** — Distributor, Distributor Store.
3. **Outlet Info** — Outlet (client master with distributor, store, and category linkage).
4. **Fieldforce Info** — National Structure (`sm_top_level`), Field Structure (`sm_level`), Employee Master (`sm_rep`), Supervisor Area Assignment (`sm_supervisor_level`), PSR Area Assignment (`sm_rep_area`), PSR Visit Plan (`sm_visit_plan`), Outlet Exceptional Visit Plan (`sm_client_visit_plan`).
5. **Settings** — Category Type (data definitions for columns like `depot_category`, `store_type`, `pack_size`, `unit_type`, `item_category`).
6. **Access Control** — User / Role / Permission (ACL) with mapping tables.
7. **Records** — Central audit log written only by the application.

Out of scope (future): sales orders, requisitions, deliveries, payments, invoicing, and the Flutter mobile client.

## 3. Business rules

| # | Rule |
|---|------|
| BR1 | Item hierarchy levels are created manually (no integration). Levels: Company(C*) → Brand(B*) → Type(T*) → Flavor(F*), auto-coded per the level prefix map (`app/hooks.py LEVEL_PREFIX`; values in `brain/INDEX.md` §1) with parent path columns `level0..level3`. |
| BR2 | Leaf flag invariant: a hierarchy node has `is_leaf=1` **iff it has no ACTIVE child** — recomputed automatically on create, update, soft delete and restore; renaming a level propagates through descendant path columns. |
| BR3 | Items come from integration or manual creation; every item automatically gets a **default batch `1` with expiry 2100-12-31** (`sm_item_batch`). |
| BR4 | Items are tagged sequentially with Company > Brand > Type > Flavor from the hierarchy. |
| BR5 | Distributors come from integration or manual creation; every distributor automatically gets two default stores — **Commercial** and **Damage** (`sm_depot_store`; id pattern: `app/hooks.py depot_after_create`, values in `brain/INDEX.md` §1). |
| BR6 | All master modules support: create, view, edit, **soft delete (status → PENDING)**, restore, and **template-based Excel batch upload**. |
| BR7 | Every master-table change (create/update/delete/restore) is recorded in the central log `sm_audit_log` **by the application only** — no DB triggers. |
| BR8 | Users are restricted by ACL: permissions like `item.view`, `item.create`, `item.edit`, `item.delete`, `item.import`, grouped under modules; roles bundle permissions; users get roles and/or direct permissions; a super-admin bypasses checks. |
| BR9 | `sm_category_type` feeds the value lists used by other modules (depot category, store type, item category, unit type). |
| BR10 | A brand (hierarchy) level may carry an **image**: uploaded files are stored under `app/static/uploads` as `{table}_{name-slug}_image_{timestamp}.{ext}` (PNG/JPG/GIF/WEBP, max 5 MB) and the generated link is saved in `image_path`. Editing can preview and replace the image; leaving the file input empty keeps the current one. |
| BR11 | From the Brand **edit page** a user can add one or many **child levels** in a single submit (names deduped; each child flows through the normal auto-code/path/audit pipeline). A Flavor (depth 3) cannot have children. |

| BR12 | Outlets (`sm_client`) are linked to distributors and stores; customer type is auto-generated as `category_id|category_name` from `sm_category_type` (groups `OUTLET_CATEGORY` and `OUTLET_SUB_CATEGORY`). |
| BR13 | Dynamic dropdown and foreign-key select fields (hierarchy levels, item lookup, distributor lookup, store lookup) must display selectable options in canonical `ID | Name` format (e.g. `BG001 | Kurkure`). In item create and edit forms, hierarchy cascade options must remain fully visible and searchable without placeholder filter occlusion, and on edit, previously saved hierarchy associations must auto-hydrate sequentially from database values. |
| BR14 | **National Structure** (`sm_top_level`): 4-tier tree: National (depth 0, prefix `H`) > Area (depth 1, prefix `A`) > Zone (depth 2, prefix `Z`) > Territory (depth 3, prefix `T`). Territory is max depth (leaf; cannot have children). Auto-incremental codes (`H0001`, `A0001`, `Z0001`, `T0001`) with parent lineage columns `level0..level3` and dynamic `is_leaf` recomputation. |
| BR15 | **Field Structure** (`sm_level`): 4-tier market coverage tree: Territory (depth 0, prefix `T`) > Town (depth 1, prefix `TW`) > Route (depth 2, prefix `R`) > Beat (depth 3, prefix `B`). Depth 0 Territory is sourced from `sm_top_level` depth 3 list. Beat is max depth (leaf; cannot have children). Auto-incremental codes (`T0001`, `TW0001`, `R0000006`, `B0000033`) with lineage columns `level0..level3`, depot linkage, and dynamic `is_leaf`. |
| BR16 | **Employee Master** (`sm_rep`): Managed via integration or manual creation; unique on `(cid, rep_id)`. Two distinct user types: `rep` (Pre-Sales Representative / PSR) and `sup` (Supervisor). Immutable auto-incremental `rep_id` prefixed by designation: Head of Sales (`HOS0001`), Sales Operation Manager (`SOM0001`), Area Sales Manager (`ASM0001`), Area Sales Executive (`ASE0001`), Customer Executive (`CE0001`), Pre Sales Executive (`PSR0001`), Delivery Man (`DM0001`). Cannot be edited once generated. |
| BR17 | **Supervisor Area Assignment** (`sm_supervisor_level`): Supervisors (`sm_rep` where `user_type='sup'`) can be assigned to any administrative or field tier across National Structure (`sm_top_level`) or Field Structure (`sm_level`), stored with `sup_id`, `level_id`, and `level_depth_no`. |
| BR18 | **PSR Area Assignment & Cascading Beat Population** (`sm_rep_area`): Field representatives (`sm_rep` where `user_type='rep'`) can only be assigned to a Route (`sm_level` depth 2). The assignment form accepts PSR and Route selection; upon save, the engine automatically resolves all active child Beats under that Route and bulk-inserts individual Beat records into `sm_rep_area`. |
| BR19 | **PSR Visit Plan** (`sm_visit_plan`): Simultaneous with Route/Beat assignment (`sm_rep_area`), the system auto-populates visit plan rows in `sm_visit_plan` mapping each Beat to an order collection day (`order_col_day` in Saturday..Friday). The corresponding delivery day (`delivery_day`) is automatically derived as the immediate next calendar day. |
| BR20 | **Outlet Exceptional Visit Plan** (`sm_client_visit_plan`): Enables custom, non-standard outlet scheduling by mapping an outlet (`client_id`) within an area (`area_id`) with visit frequency, weekly cycle flags (`w1`..`w5`), and weekday matrix flags (`sat`..`fri`). |

## 4. Users

- **Super Administrator** — full access, manages users/roles/permissions.
- **Sales Manager** — manages items, batches, hierarchy, distributors (no Excel import in seed).
- **Read Only (VIEWER)** — view only.
- Integration/system processes (future) will write via separate `intr_flag` flows.

## 5. Non-functional needs

- Login page + collapsible sidebar dashboard, modern and optimized layout.
- Responsive; Facebook-like font/background colors; eye-comfort palette.
- Sidebar accordion: opening one nav group auto-collapses the others, with smooth transitions; Font Awesome icons served **locally** (no CDN).
- Search + filters + pagination on every list; column filters support typeahead search and multi-select.
- High-density compact view: minimal margin and padding across tables, cards, and filter controls to maximize visible data and eliminate wasted screen space.
- Runs in a Python virtual environment; default admin credentials per `AGENTS.md`, to be changed after first login.

## 6. Success criteria

- A super admin can create the sample hierarchy (TCPL example), an item with default batch, and a distributor with default stores without touching SQL.
- Every action above appears in the audit log with old/new values and the acting user.
- A VIEWER-role user cannot create or edit anything and cannot open admin screens.
- Excel templates download and import round-trips cleanly, reporting per-row errors.
