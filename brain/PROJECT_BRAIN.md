# SSMS Project Brain

Living memory for anyone (human or agent) picking up this project. Update on every change.

## Identity
- **Product:** Secondary Sales Management System (SSMS), code `SMART` company id.
- **Stack today:** FastAPI web app (Jinja2 server-rendered), PyMySQL raw SQL, MariaDB 10.4 `smart_27` at localhost (root, empty password). Python venv at `./venv`.
- **Later phase:** Flutter mobile app will consume the same data model; integration feeds (item/depot APIs) land in `intr_flag` flows — not built yet.

## Status (as of 2026-11-09)
- v1.0.0 complete and verified end-to-end: login, dashboard, 6 master modules with create/view/edit/soft-delete/Excel, ACL admin, audit log.
- Brand UX added (2026-11-09): type-to-search Parent Level picker, image upload with preview + edit-replace (files under `app/static/uploads`, naming `{table}_{slug}_image_{timestamp}.{ext}`, link in `image_path`), Child Levels card on edit page with add one/many (`POST /brand/add-children/{id}`).
- Brand tree list (2026-11-09): depth-0 nodes render pre-expanded (server-side `open` class), everything else collapsed; expanding a node auto-collapses the other open nodes in the same level — accordion implemented in `app/static/js/app.js` via `:scope > .tree-node.open` within the node's parent container.
- `is_leaf` is now a maintained invariant (BR2): `1` iff no ACTIVE child, recomputed via `hooks._recompute_is_leaf` on create/update/soft-delete/restore.
- Run: `./venv/Scripts/python -m uvicorn app.main:app --host 127.0.0.1 --port 8027` (bootstrap is automatic, port 8027).

## Key decisions & why
1. **Generic CRUD engine** (`app/modules.py` registry + `app/routers/crud.py`): one router serves every master module; a new module = one dict entry + hooks. Do NOT fork per-module code.
2. **Schema fidelity with sanctioned fixes**: table/column names from requirements kept verbatim (e.g. `expiary_date` — a historical typo, keep it). Allowed fixes per requirements: added `status` columns to `sm_item_hierarchy`, `sm_item_batch`, `sm_depot_store`, `sm_category_type` so every module can soft-delete; normalized `PRIMARY KEY (id DESC)` for MariaDB 10.4.
3. **App-only audit**: `sm_audit_log` is written by `app/audit.py` around every create/update/delete/restore/login; no triggers, and audit failures never block business ops.
4. **ACL model**: varchar business keys (`user_id`, `role_id`, `perm_id`), cid-scoped unique keys, permission strings `module.action`, super-admin bypass flag. Permission cache in `app/security.py` must be invalidated after role/user edits (`invalidate_user_cache`).
5. **No CDN**: Font Awesome 6.5.2 is vendored under `app/static/vendor/fontawesome`. Keep it that way for offline/内网 deployments.
6. **UI palette**: Facebook-style (`#1877f2` primary, `#f0f2f5` bg, `#050505`/`#65676b` text). Accordion sidebar: opening one group collapses others; persisted via localStorage.
7. **Image uploads**: handled generically in `crud.py` for any registry field of type `image` (form input `{col}_file`); extension whitelist + 5 MB cap; file written to `app/static/uploads/` only AFTER the DB write succeeds so failed validations leave no orphans; DB stores the `/static/uploads/...` link. Naming `{table}_{name-slug}_image_{timestamp}.{ext}` keeps replacements from colliding/caching.
8. **Searchable single select**: any `<select data-searchable>` gets a type-to-search widget injected by `app/static/js/app.js` while the native select stays the value holder (form still submits without JS).

## Gotchas learned the hard way
- Jinja dict access: attribute lookup shadows dict keys — never name template-visible dict keys `items` (use `entries`); `max`/`min`/`set` are not Jinja globals (registered max/min in `main.py`).
- Middleware order matters: `SessionMiddleware` must be added AFTER the auth-gate middleware so it runs first (later-registered runs first in Starlette).
- Router order: include `acl_admin` before `crud` — crud's `/{slug}` catch-all would swallow `/users`.
- `_access()` in crud router: unknown module must redirect to `/`, unauthenticated to `/login`.
- Seed idempotency: `seed()` checks emptiness per table — partial failures self-heal on the next run (first-run MANAGER-role bug was tuple-vs-id; fixed in `ROLE_PERM_MATRIX`).

## Where things live
- Business rules: `app/hooks.py` (codes, default batch, default stores, cascade delete).
- Column/UI definitions: `app/modules.py`.
- Schema: `scripts/ddl.sql`; seed: `scripts/setup_database.py`.
- Docs: `docs/BRD|PRD|SRS.md`; README; skill `.agents/skills/ssms/SKILL.md`; prompts `prompts/PROMPTS.md`.

## Next candidates (not asked yet, backlog)
- REST API module for the Flutter app (JWT or session tokens).
- More category groups: approval_flag labels, town master.
- Test suite (pytest + httpx) once API surface grows.
