# AGENTS.md — SSMS (Secondary Sales Management System)

Guidance for AI agents / contributors working in this repository.

## What this project is
FastAPI web app managing secondary-sales master data on MariaDB/MySQL `smart_27`.
Core concepts: **item hierarchy** (Company → Brand → Type → Flavor, auto-coded CG/BG/TG/FG),
**items** (auto default batch `1` valid 2100-12-31), **distributors** (auto default stores
`{id}140` Commercial / `{id}170` Damage), **category types** (value definitions),
**ACL** (user/role/permission + 3 mapping tables), **central audit log** (`sm_audit_log`, app-written only).

## Non-negotiables
1. Keep the exact table/column names from `scripts/ddl.sql` — including the historical typo `expiary_date`. Migrations only via attested DDL changes there + comments.
2. All master-table changes MUST flow through the generic CRUD engine (`app/routers/crud.py` + hooks in `app/hooks.py`) so audit logging stays complete. Never hand-roll inserts in new routes.
3. Permission checks: every new route must gate on `require_perm(user, "module.action")`; view actions redirect without permission (see `_access` in crud.py).
4. No CDN links. Vendor any asset locally under `app/static/vendor/`.
5. Run in `./venv` only; DB is localhost/root//smart_27 unless env vars say otherwise.
6. Update the doc set whenever behavior changes: `docs/BRD.md` (needs), `docs/PRD.md` (behavior/acceptance), `docs/SRS.md` (architecture/FR), `README.md` (how-to), `brain/PROJECT_BRAIN.md` (decisions/status), `.agents/skills/ssms/SKILL.md`, `prompts/PROMPTS.md`.

## How to verify changes
- Start server: `./venv/Scripts/python -m uvicorn app.main:app --host 127.0.0.1 --port 8027`
- Login with `admin/admin123`, then exercise the affected module(s) over HTTP (curl) — check list 200, create/update flows, and the `sm_audit_log` rows in DB.
- Schema changes: re-run `./venv/Scripts/python scripts/setup_database.py`.

## Adding a new master module (checklist)
1. Column spec dict in `app/modules.py` (`MODULES`, incl. `list_cols`, `search_cols`, `filters`, `form_fields`, `excel_cols`, `perm`) and add to `MODULE_ORDER`/`PERM2SLUG` if needed.
2. Business rules (duplicates, auto-codes, defaults) as a hook in `app/hooks.py` registered under `HOOKS`.
3. Table in `scripts/ddl.sql` (with `status` column if soft-delete is wanted) and seed permissions in `setup_database.py`.
4. Update docs (PRD §journeys + SRS §FR) and the brain file.
