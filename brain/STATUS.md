# SSMS Status (current snapshot — overwrite freely; history lives in DECISIONS/VERIFICATION_LOG)

## Identity
- **Product:** Secondary Sales Management System (SSMS), company id `SMART`.
- **Stack:** FastAPI web app (Jinja2 server-rendered), PyMySQL raw SQL, MariaDB 10.4 `smart_27` at localhost (root, empty password). Python venv at `./venv`.
- **Later phase:** Flutter mobile app will consume the same data model; integration feeds land in `intr_flag` flows — not built yet.

## State as of 2026-11-17 (counts verified by `scripts/check_context.py`)
- v1.0.0 complete and verified end-to-end (V-001): login, dashboard, 6 master modules, ACL admin, audit log.
- Brand UX verified (V-002): parent picker, image upload, child-levels card, tree list, `is_leaf` invariant (D-009).
- Outlet module verified (T-001): registry `app/modules.py:221`, hook `outlet_prepare` (D-010).
- Fieldforce Info suite verified end-to-end (V-006 / T-013..T-019): 7 new modules (`top-level`, `level`, `rep`, `supervisor-level`, `rep-area`, `visit-plan`, `client-visit-plan`), dynamic designations from `sm_category_type`, automated beat cascade and visit planning.
- Item & Distributor Enhancements verified (V-015 / T-029..T-034): `sm_rack` master module with image upload parity; `sm_depot_stock_balance` master module with edit disabled (`no_edit: True`); distributor dropdown filter on `/distributor-store`; immutable distributor on `/distributor-store/edit/{id}`; distributor status cascade to child stores; immutable distributor ID on `/distributor/edit/{id}`.
- Distributor Stock Refinement verified (V-016 / T-035): renamed to "Distributor Stock", removed delete, import, and status column (`no_delete: True`, `no_import: True`, permissions 83 → 81); added 3 auto-provisioning triggers (item, depot, depot_store) inserting zero-quantity stock balances, with full one-time active data backfill.
- Employee Master Refinement verified (V-017 / T-036, V-018 / T-037, V-019 / T-038): renamed to "Employee(rep/sup/dm)", dynamic `EMP_USER_TYPE` category definitions (rep, sup, dm, category-type count 29 → 32), cascading dropdown (user_type first -> filtered designation: rep->PSR, dm->DM, sup->all except PSR/DM), auto-incremental non-editable `rep_id` prefixed by designation (PSR0001, DM0001, etc.) & nullable for external integration, optional dob/doj across create/edit/import, MD5 password hashing with edit retention, photo upload (`image_path`), and logical form rearrangement with distributor and photo placed before note.

## Verified counts (re-run the checker, don't trust this list on drift)
| What | Count | Canonical source |
|---|---|---|
| Master modules | 16 | `app/modules.py MODULES` / `MODULE_ORDER` |
| Seeded permissions | 81 | `scripts/setup_database.py SEED_PERMISSIONS` |
| Category-type values | 32 | `scripts/setup_database.py SEED_CATEGORY_TYPES` |
| Roles | 3 | SUPER_ADMIN, MANAGER, VIEWER |

## Run
`./venv/Scripts/python -m uvicorn app.main:app --host 127.0.0.1 --port 8027` (DB auto-bootstraps; port 8027).
