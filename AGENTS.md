# AGENTS.md — SSMS (Secondary Sales Management System)

Guidance for AI agents / contributors working in this repository.

## What this project is
FastAPI web app managing secondary-sales master data on MariaDB/MySQL `smart_27`.
Core concepts: **item hierarchy** (Company → Brand → Type → Flavor, auto-coded per
`app/hooks.py LEVEL_PREFIX`), **items** (auto default batch, see BR3), **distributors**
(auto default stores, see BR5), **category types** (value definitions),
**ACL** (user/role/permission + 3 mapping tables), **central audit log** (`sm_audit_log`, app-written only).
Fact values live in one home each — never restate them here; `brain/INDEX.md` §1 maps every fact to its home.

## Non-negotiables
1. Keep the exact table/column names from `scripts/ddl.sql` — including the historical typo `expiary_date`. Migrations only via attested DDL changes there + comments.
2. All master-table changes MUST flow through the generic CRUD engine (`app/routers/crud.py` + hooks in `app/hooks.py`) so audit logging stays complete. Never hand-roll inserts in new routes.
3. Permission checks: every new route must gate on `require_perm(user, "module.action")`; view actions redirect without permission (see `_access` in crud.py).
4. No CDN links. Vendor any asset locally under `app/static/vendor/`.
5. Run in `./venv` only; DB is `localhost`, user `root`, empty password, schema `smart_27` unless env vars say otherwise.
6. **Sync contract** — after a behavior change, update only what the change touched: the `brain/INDEX.md` rows (§1 facts / §2 module map), `brain/STATUS.md` counts if changed, the **one** affected rule doc (`docs/BRD.md` need / `docs/PRD.md` journey / `docs/SRS.md` FR), `brain/TASKS.md` status, and `prompts/PROMPTS.md`/`README.md` only if operations changed. `scripts/check_context.py` must pass on your scope before commit. Never restate a fact — point at its home (rule 8).
7. **Code wins over docs** when they disagree — verify against the code symbol before editing either.
8. **Every fact lives in exactly one file.** `brain/INDEX.md` §1 is the fact→home map; restating a mapped fact elsewhere is a defect.

## Session protocol
**Start (in order):**
1. `./venv/Scripts/python scripts/check_context.py` — exit 1 → fix **only the flagged rows** (re-index per `brain/INDEX.md` §4a). Do not proceed on drift.
2. Read `brain/INDEX.md` + `brain/STATUS.md`. Trust them when the INDEX stamp covers HEAD (§4a); re-read nothing else yet.
3. Drain `MY_WATCHER.txt` (raw inbox) into `brain/TASKS.md` — assign ids/status/deps; leave a tombstone. Pick the IN_PROGRESS task or the first `ready` one.
4. Load task context from the task's INDEX §2 module-map row (line-range anchors), per §4 rules — never whole engine files without an anchor.
**During:** Non-negotiables apply; on code-vs-doc conflicts code wins (rule 7) — fix the stale row/doc, never the code to match a doc.
**End (task closing ritual):**
1. Move the task to its new status in `brain/TASKS.md` (DONE entries: one line, with commit ref).
2. Update `brain/STATUS.md` counts if modules/perms/category-types changed; update INDEX rows if registry/hooks/facts changed.
3. New decision made → append `brain/DECISIONS.md` (never rewrite old entries). Verified live → append `brain/VERIFICATION_LOG.md`.
4. Run `scripts/check_context.py` — must exit 0 on everything except explicitly deferred rows; update the INDEX stamp if you re-indexed.
5. Commit: `module: action (T-nnn)`. Fill the IN_PROGRESS/handover block for anything left open.

## How to verify changes
- Start server: `./venv/Scripts/python -m uvicorn app.main:app --host 127.0.0.1 --port 8027`
- Login with `admin/admin123`, then exercise the affected module(s) over HTTP (curl) — check list 200, create/update flows, and the `sm_audit_log` rows in DB.
- Schema changes: re-run `./venv/Scripts/python scripts/setup_database.py`.

## Adding a new master module (checklist)
1. Column spec dict in `app/modules.py` (`MODULES`, incl. `list_cols`, `search_cols`, `filters`, `form_fields`, `excel_cols`, `perm`) and add to `MODULE_ORDER`/`PERM2SLUG` if needed.
2. Business rules (duplicates, auto-codes, defaults) as a hook in `app/hooks.py` registered under `HOOKS`.
3. Table in `scripts/ddl.sql` (with `status` column if soft-delete is wanted) and seed permissions in `setup_database.py`.
4. Update docs (PRD §journeys + SRS §FR) and the brain file.
