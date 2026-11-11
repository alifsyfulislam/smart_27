---
name: ssms
description: >
  Working conventions for the SSMS (Secondary Sales Management System) FastAPI app —
  how to run it, extend modules, keep ACL + audit intact, and update the doc set.
  Use when working in this repository on FastAPI/Jinja/MySQL master-data changes.
---

# SSMS skill

## Run & verify loop
1. Server: `./venv/Scripts/python -m uvicorn app.main:app --host 127.0.0.1 --port 8027`
   (background; DB auto-bootstraps on startup — MariaDB/MySQL must be running).
2. Login via `POST /login { user_id: admin, password: admin123 }` (session cookie `ssms_session`).
3. Exercise routes with curl; confirm `sm_audit_log` grew after each write (query via `app.database.q`).
4. DB work: `./venv/Scripts/python scripts/setup_database.py` re-runs DDL + seed safely (idempotent, emptiness checks per table).

## Rules of engagement
- **One registry**: module UI/fields live ONLY in `app/modules.py` (`MODULES`); business rules ONLY in `app/hooks.py` (`HOOKS[value of create_hook]`).
- **Audit completeness**: writes go through `_do_create` / `_update` / soft-delete-restore paths in `app/routers/crud.py`; `app/audit.log_change` must wrap them.
- **ACL strings**: `module.action` where module ∈ {dashboard, brand, item, item_batch, distributor,
  depot_store, outlet, category_type, acl, audit} (canonical catalogue: `SEED_PERMISSIONS` in
  `scripts/setup_database.py`)
  and action ∈ {view, create, edit, delete, import} (acl: view/manage; audit: view).
- **Schema discipline**: names are frozen (keep `expiary_date` typo); add columns by amending `scripts/ddl.sql` + documenting in its header. Soft-delete values: master modules `status='PENDING'` (`app/routers/crud.py`); ACL user/role `status='INACTIVE'` (`app/routers/acl_admin.py`). Item *status* (INACTIVE/PENDING/REJECTED) is a separate domain vocabulary pushed to batches (`app/hooks.py item_soft_delete`).
- **UI**: Facebook-style palette (values: `docs/PRD.md` §2.3), Font Awesome local only, accordion sidebar (`openGroup` in localStorage), responsive ≥900px desktop / drawer on mobile.
- **Jinja pitfalls**: dict keys named `items` collide with the dict method in attribute lookup — use `entries`; `max`/`min` are registered globals; there is no `set()` — use `[]` literals.
- **Starlette pitfalls**: register `SessionMiddleware` AFTER route middleware; include `acl_admin` router BEFORE `crud` (the `/{slug}` catch-all would swallow `/users`, `/roles`, `/permissions`).

## Doc-update checklist (per requirements, keep in sync on every change)
- `docs/BRD.md` business rules BR1–BR9 → new/changed rules
- `docs/PRD.md` journeys + acceptance criteria
- `docs/SRS.md` architecture/FR/data model
- `README.md` run instructions + route table
- `brain/PROJECT_BRAIN.md` decisions/status/gotchas
- `.agents/skills/ssms/SKILL.md` (this file) if conventions changed
- `prompts/PROMPTS.md` if prompts changed
- `AGENTS.md` non-negotiables if the rules above changed
