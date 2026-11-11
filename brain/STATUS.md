# SSMS Status (current snapshot — overwrite freely; history lives in DECISIONS/VERIFICATION_LOG)

## Identity
- **Product:** Secondary Sales Management System (SSMS), company id `SMART`.
- **Stack:** FastAPI web app (Jinja2 server-rendered), PyMySQL raw SQL, MariaDB 10.4 `smart_27` at localhost (root, empty password). Python venv at `./venv`.
- **Later phase:** Flutter mobile app will consume the same data model; integration feeds land in `intr_flag` flows — not built yet.

## State as of 2026-11-11 (counts verified by `scripts/check_context.py`)
- v1.0.0 complete and verified end-to-end (V-001): login, dashboard, 6 master modules, ACL admin, audit log.
- Brand UX verified (V-002): parent picker, image upload, child-levels card, tree list, `is_leaf` invariant (D-009).
- Outlet module **in code, docs backfill in progress (T-001)**: registry `app/modules.py:221`, hook `outlet_prepare` (D-010).

## Verified counts (re-run the checker, don't trust this list on drift)
| What | Count | Canonical source |
|---|---|---|
| Master modules | 7 | `app/modules.py MODULES` / `MODULE_ORDER` |
| Seeded permissions | 39 | `scripts/setup_database.py SEED_PERMISSIONS` |
| Category-type values | 17 | `scripts/setup_database.py SEED_CATEGORY_TYPES` |
| Roles | 3 | SUPER_ADMIN, MANAGER, VIEWER |

## Run
`./venv/Scripts/python -m uvicorn app.main:app --host 127.0.0.1 --port 8027` (DB auto-bootstraps; port 8027).
