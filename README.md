# SSMS — Secondary Sales Management System

FastAPI web application for secondary-sales master data:
**Item hierarchy (Company → Brand → Type → Flavor) · Items · Item Batches · Distributors (Depots) · Distributor Stores · Category Types**, with role-based ACL and a central audit log.
A Flutter mobile app is planned as a later phase — this repo is the core **web/tier** today.

## Quick start (Windows / Git Bash)

```bash
# 1) environment (one time)
python -m venv venv
./venv/Scripts/pip install -r requirements.txt

# 2) database (MySQL/MariaDB at localhost, root, empty password)
./venv/Scripts/python scripts/setup_database.py   # creates smart_27 + schema + seed

# 3) run
./venv/Scripts/python -m uvicorn app.main:app --host 127.0.0.1 --port 8027 --reload
# open http://127.0.0.1:8027
```

**First login:** `admin` / `admin123` (Super Admin) — change it right away in Users.
The app also self-bootstraps the database on startup if the schema/seed is missing.
DB coordinates can be overridden with env vars `SSMS_DB_HOST / SSMS_DB_PORT / SSMS_DB_USER / SSMS_DB_PASS / SSMS_DB_NAME`.

## What's inside

| Area | Routes | Notes |
|---|---|---|
| Dashboard | `/` | stats, hierarchy bars, recent audit, quick actions |
| Brand (hierarchy) | `/brand` | auto codes via `LEVEL_PREFIX`, path columns, subtree soft delete, rename propagation; tree list opens depth-0 by default with per-level accordion; type-to-search parent picker, image upload+preview (`/static/uploads`, link in `image_path`), add one/many child levels from the edit page (`POST /brand/add-children/{id}`); `is_leaf` kept = "no ACTIVE child" on create/update/delete/restore |
| Item | `/item` | hierarchy tagging, prices; auto default batch (BR3) |
| Item Batch | `/item-batch` | per-item batches, datalist item picker |
| Distributor | `/distributor` | auto default stores Commercial + Damage (BR5) |
| Distributor Store | `/distributor-store` | store types from category master |
| Category Type | `/category-type` | value definitions for other modules |
| Users / Roles / Permissions | `/users` `/roles` `/permissions` | full ACL management |
| Audit Log | `/audit-log` | app-written central change log with filters |

Every master module has: **create · view · edit · soft delete (→ PENDING) · restore · Excel template download + batch upload**, plus search, filters and pagination on the list.
Sidebar is a smooth accordion (one group open at a time), collapses to an icon rail on desktop and a drawer on mobile; Facebook-like colors; Font Awesome served locally from `app/static/vendor` (no CDN).

## Project layout

```
app/
  main.py            app assembly, middleware, bootstrap
  config.py          settings (DB: localhost/root//smart_27)
  database.py        PyMySQL helpers (q / x / scalar)
  ctx.py             menu, flashes, permission gate helpers
  security.py        password hashing + permission resolution
  audit.py           central change-log writer
  modules.py         module registry (fields/lists/filters/excel)
  hooks.py           business rules (codes, default batch/stores…)
  routers/           core.py · crud.py · acl_admin.py
  templates/         base, login, dashboard, generic/, acl/, audit/
  static/            css, js, vendor/fontawesome (local); uploads/ = brand images
scripts/
  ddl.sql            full schema (reviewed + status columns + ACL + audit)
  setup_database.py  create DB + seed (roles/permissions/admin/category types/sample hierarchy)
docs/                BRD  PRD  SRS
brain/  .agents/skills/ssms/  prompts/  AGENTS.md   — project memory / skill / agent / prompt docs
scripts/check_context.py — knowledge-layer consistency gate (run before commits)
```

## Re-generating / checking the DB

```bash
./venv/Scripts/python scripts/setup_database.py
```
Seed data: 3 roles, admin user, 39 permissions, 17 category-type values, TCPL sample hierarchy. Existing DBs keep the legacy demo codes (CG001 → …); fresh installs generate codes per `app/hooks.py LEVEL_PREFIX` (see `brain/INDEX.md` §1). Counts are verified by `scripts/check_context.py`.

## Documentation

- [docs/BRD.md](docs/BRD.md) — business requirements
- [docs/PRD.md](docs/PRD.md) — product requirements & acceptance criteria
- [docs/SRS.md](docs/SRS.md) — architecture, functional requirements, data model
