# SSMS Status (current snapshot — overwrite freely; history lives in DECISIONS/VERIFICATION_LOG)

## Identity
- **Product:** Secondary Sales Management System (SSMS), company id `SMART`.
- **Stack:** FastAPI web app (Jinja2 server-rendered), PyMySQL raw SQL, MariaDB 10.4 `smart_27` at localhost (root, empty password). Python venv at `./venv`.
- **Later phase:** Flutter mobile app will consume the same data model; integration feeds land in `intr_flag` flows — not built yet.

## State as of 2026-11-18 (counts verified by `scripts/check_context.py`)
- v1.0.0 complete and verified end-to-end (V-001): login, dashboard, 6 master modules, ACL admin, audit log.
- Brand UX verified (V-002): parent picker, image upload, child-levels card, tree list, `is_leaf` invariant (D-009).
- Outlet module verified (T-001): registry `app/modules.py:221`, hook `outlet_prepare` (D-010).
- Fieldforce Info suite verified end-to-end (V-006 / T-013..T-019): 7 new modules (`top-level`, `level`, `rep`, `supervisor-level`, `rep-area`, `visit-plan`, `client-visit-plan`), dynamic designations from `sm_category_type`, automated beat cascade and visit planning.
- Item & Distributor Enhancements verified (V-015 / T-029..T-034): `sm_rack` master module with image upload parity; `sm_depot_stock_balance` master module with edit disabled (`no_edit: True`); distributor dropdown filter on `/distributor-store`; immutable distributor on `/distributor-store/edit/{id}`; distributor status cascade to child stores; immutable distributor ID on `/distributor/edit/{id}`.
- Distributor Stock Refinement verified (V-016 / T-035, V-024 / T-043): renamed to "Distributor Stock", removed create, delete, import, and status column (`no_create: True`, `no_delete: True`, `no_import: True`, permissions 81 → 80); added 4 auto-provisioning triggers (item * batches * depots * stores, batch * item * depots * stores, depot * stores * items * batches, depot_store * depot * items * batches) inserting zero-quantity stock balances; added Item filter ("All Item") alongside Distributor filter on `/depot-stock-balance`.
- Employee Master Refinement verified (V-017 / T-036, V-018 / T-037, V-019 / T-038, V-020 / T-039, V-025 / T-044): renamed to "Employee", dynamic `EMP_USER_TYPE` category definitions (rep, sup, dm, category-type count 29 → 32), cascading dropdown (user_type first -> filtered designation: rep->PSR, dm->DM, sup->all except PSR/DM), auto-incremental non-editable `rep_id` prefixed by designation (PSR0001, DM0001, etc.) & nullable for external integration, hidden `rep_id` on create form with required unique `rep_username` on `(cid, rep_username)`, optional dob/doj across create/edit/import, MD5 password hashing with edit retention, photo upload (`image_path`), and logical form rearrangement with distributor removed from create/edit forms.
- Master Form Refinements & Visit Plan Weekday Logistics verified (V-023 / T-042): Sourced order collection days dynamically from `WEEK_DAYS` category types (category-type count 32 → 39); hidden `delivery_day` from forms with automatic next-working-day mapping (Thursday/Friday -> Saturday); searchable delivery man & supervisor inputs with custom search placeholders; removed collection day filter from visit plan list; hidden redundant `name` input from `item-batch` forms with auto-fill from item; hidden redundant `town_id` input from `distributor` forms with auto-lookup from `sm_level` and renamed label to "Town".
- Field Structure, Employee & Visit Plan Form Simplification verified (V-025 / T-044): removed Distributor (`depot_id`) input from Field Structure Town create/edit forms (`in_form=False`) with edit preservation in `level_prepare`; renamed module title to "Employee" and removed Distributor from Employee create/edit forms with edit preservation in `rep_prepare`; removed Distributor from PSR Visit Plan create/edit forms with edit preservation or field area inheritance in `visit_plan_prepare`.
- Distributor Rack Stock Module verified (V-026 / T-045): Registered 17th master data module `depot-rack-stock-balance` (table `sm_depot_rack_stock_balance`, title "Distributor Rack Stock") under Distributor Info; strictly read-only tracking (`no_create: True`, `no_edit: True`, `no_delete: True`, `no_import: True`) with view permission `depot_rack_stock_balance.view` (seeded permissions 80 → 81); status and distributor dropdown filters with search across distributor, rack, outlet, and status.
- Stock Modules Renaming & Filters verified (V-027 / T-046): Renamed `depot-stock-balance` title to "Item Stock" and added "All Distributor Store" (`store_id`) filter dropdown; renamed `depot-rack-stock-balance` title to "Rack Stock" and added "All Rack" (`rack_id`) filter dropdown.
- Outlet Info Refinement verified (V-028 / T-047): Auto-incrementing numeric `client_id` starting at `1000001` (hidden on create with placeholder, readonly on edit), Beat selector with Route filter & auto `area_name` resolution, profile photo upload (`image_path`), and removal of `depot_id`, `store_id`, and `client_old_id` from forms (`in_form=False`).
- Outlet Exceptional Visit Plan verified (V-029 / T-048): Area (Beat) positioned first in form with Route filter, dynamic cascading beat-to-outlet filter with count badge, and dynamic frequency from `sm_category_type` `FREQUENCY_TYPE` (category-type count 39 → 43).
- Visit Plan Representative Searchable Alignment verified (V-030 / T-049): Representative input in `visit-plan` and `rep-area` aligned with Delivery Man (`searchable=True`, label "Representative", placeholder "Type to search Representative…", default `-- Select Representative --`).
- Outlet Beat Distributor Validation & Default Commercial Store Tagging verified (V-031 / T-050): Outlet ID (`client_id`) follows Employee ID pattern (hidden on create, readonly on edit with tabindex -1); Beat (`area_id`) distributor validation rejects unassigned beats; auto-records `depot_id`, `depot_name`, and default commercial store (`store_id`, `store_name`) on `sm_client`; level distributor select supported on depths 1-3.
- Beat & Distributor List Filters verified (V-032 / T-051): "All Beat" (`area_id`) and "All Distributor" (`depot_id`) dropdown filters on `/outlet` and `/client-visit-plan` list pages.

## Verified counts (re-run the checker, don't trust this list on drift)
| What | Count | Canonical source |
|---|---|---|
| Master modules | 17 | `app/modules.py MODULES` / `MODULE_ORDER` |
| Seeded permissions | 81 | `scripts/setup_database.py SEED_PERMISSIONS` |
| Category-type values | 43 | `scripts/setup_database.py SEED_CATEGORY_TYPES` |
| Roles | 3 | SUPER_ADMIN, MANAGER, VIEWER |

## Run
`./venv/Scripts/python -m uvicorn app.main:app --host 127.0.0.1 --port 8027` (DB auto-bootstraps; port 8027).
