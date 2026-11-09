# Software Requirements Specification (SRS)
## Secondary Sales Management System (SSMS)

**Version:** 1.0.0 · **Implements:** docs/PRD.md · **Runtime:** Python 3.11 (venv) · **DB:** MariaDB 10.4/MySQL 8, schema `smart_27`

---

## 1. System architecture

```
Request → FastAPI (app/main.py)
   ├── SessionMiddleware (signed cookie, 8h)          [outermost]
   ├── auth_gate middleware (redirects → /login)
   │      └── ctx.current_user(request)
   ├── Routers
   │     ├── core.py        /login /logout / (dashboard) /audit-log
   │     ├── acl_admin.py   /users /roles /permissions (+POST actions)
   │     └── crud.py        generic module CRUD + Excel + /api JSON
   ├── ctx.py (menu/flash/perms) · security.py (ACL) · audit.py (change log)
   ├── modules.py (module registry) · hooks.py (business rules)
   └── database.py (PyMySQL, raw SQL) → MySQL/MariaDB smart_27
Templates: Jinja2 (app/templates) · Static: app/static (FontAwesome local)
```

## 2. Functional requirements

### FR1 Authentication
- FR1.1 `POST /login` verifies `sm_acl_user.user_id` (ACTIVE) with PBKDF2-SHA256 (120k iters, 16-byte salt).
- FR1.2 Session stores `uid`; sign-out clears session; LOGIN/LOGOUT actions logged.

### FR2 Access control
- FR2.1 Permission resolution = union of role permissions + direct user permissions; `is_super=1` bypasses everything (cache invalidated on role/perm edits).
- FR2.2 All module actions require `module.action` permission; ACL screens require `acl.view`/`acl.manage`; audit requires `audit.view`.
- FR2.3 Unauthenticated access to any page redirects to `/login`; unknown module slugs redirect to `/`.

### FR3 Master modules (per module M of `app/modules.py`)
- FR3.1 `GET /{slug}` — list: cid-filtered, free-text search (configurable `search_cols`), dropdown filters, ORDER, LIMIT/OFFSET pagination, page-size select. Brand renders the full hierarchy as a tree instead: nodes at depth 0 start expanded (server-side `open` class), deeper nodes collapsed; `app/static/js/app.js` toggles nodes with a per-level accordion — expanding a node collapses the other open nodes under the same parent.
- FR3.2 `GET/POST /{slug}/create` — form → `values_from_form` → hook prepare → insert (`touch` stamps cid/created_on/by) → hook after_create → audit CREATE.
- FR3.3 `GET/POST /{slug}/edit/{id}` — existing merged with submitted values → hook prepare (dup checks) → update → after_update/hook → audit UPDATE (old+new snapshots).
- FR3.4 `GET /{slug}/view/{id}` — read-only render.
- FR3.5 `POST /{slug}/delete/{id}` — soft delete to PENDING (hierarchy: subtree cascade) → audit DELETE.
- FR3.6 `POST /{slug}/restore/{id}` — back to ACTIVE (hierarchy: parent-active check) → audit RESTORE.
- FR3.7 `GET /{slug}/template` — xlsx template (uppercase headers + code row + example row).
- FR3.8 `POST /{slug}/upload` — openpyxl parse, header→column mapping, per-row insert through the same hooks; summary flash + row errors; template mismatch and empty files rejected.
- FR3.9 `GET /api/hierarchy/children?parent=X` — JSON children for cascade selects (used by the item form and API consumers).
- FR3.10 `POST /{slug}/add-children/{id}` (brand) — create one or many child levels under a node from the edit page: `child_names[]` form list, deduped, each routed through the same hook + audit pipeline; per-name error report in the flash; requires `brand.create`.
- FR3.11 Image fields (`type: "image"` in the module registry, brand `image_path`): multipart form (`enctype=multipart/form-data`), input named `{col}_file`; validation = extension whitelist (png/jpg/jpeg/gif/webp) + 5 MB cap; stored under `app/static/uploads` as `{table}_{name-slug}_image_{timestamp}.{ext}`; `image_path` gets the `/static/uploads/...` link; file written only after the DB write succeeds (no orphans on validation failure); edit with an empty input keeps the existing image.

### FR4 Business rules (hooks)
- FR4.1 Hierarchy codes: `{CG,BG,TG,FG}{seq:03d}` continuing per prefix; depth = parent.depth+1; full path `level0..level3`; new rows start `is_leaf=1`.
- FR4.1a Leaf invariant: `is_leaf='1'` iff the node has no ACTIVE child — recomputed by `_recompute_is_leaf` on create (parent), update (node + parent), soft delete (parent) and restore (parent + node).
- FR4.2 Depth cap: cannot create below flavor (max depth 3).
- FR4.3 Rename propagates to descendants; soft-delete/restore cascade the subtree.
- FR4.4 Item create → default batch `1` / 2100-12-31 (ON DUPLICATE-safe).
- FR4.5 Depot create → stores `{depot_id}140` Commercial / `{depot_id}170` Damage.
- FR4.6 Uniqueness: item by cid+item_id; batch by cid+item_id+batch_id; store by cid+depot_id+store_id; category by cid+type_name+cat_type_id; name dup within same hierarchy parent.
- FR4.7 Category values for type names map from `sm_category_type` (DEPOT_CATEGORY, STORE_TYPE, ITEM_CATEGORY, UNIT_TYPE).

### FR5 Audit
- FR5.1 `sm_audit_log` rows: table_name, record_key (business id), action, old_values/new_values JSON snapshots, changed_by, user_ip, note.
- FR5.2 App-only; failures to log never break the business transaction.

### FR6 Admin screens
- FR6.1 Users: create/edit/soft-delete/restore + role assignment; self-deactivation blocked.
- FR6.2 Roles: create/edit (permission matrix by module) /soft delete.
- FR6.3 Permissions: list + create; catalogue seeded at bootstrap.
- FR6.4 `sm_audit_log` viewer with table/action/user filters and expandable JSON.

## 3. Data model

Tables (scripts/ddl.sql, exact names/columns from requirements):

| Table | Purpose / changes vs. provided DDL |
|---|---|
| `sm_item_hierarchy` | + `status` (soft delete); `image_path` now stores a generated `/static/uploads/...` link written by the upload handler (files on disk under `app/static/uploads/`) |
| `sm_item`, `sm_item_batch` | provided; `sm_item_batch` + `status` |
| `sm_depot`, `sm_depot_store` | provided; `sm_depot_store` + `status` |
| `sm_category_type` | + `status` |
| `sm_acl_user/role/permission`, `sm_acl_user_role`, `sm_acl_user_permission`, `sm_acl_role_permission` | new ACL tables (varchar business keys FK-free, cid-scoped unique) |
| `sm_audit_log` | new central change log (longtext JSON snapshots) |

Key types used: `int AUTO_INCREMENT` PKs, unique/normal keys as in requirements (DESC keys normalized for MariaDB compatibility), `utf8` charset under MariaDB 10.4 (maps to utf8mb3), `double` for prices/weights.

## 4. Configuration & operations

- DB: host `localhost`, user `root`, password empty, database `smart_27` (env-overridable: `SSMS_DB_HOST/PORT/USER/PASS/NAME`).
- Bootstrap: `scripts/setup_database.py` (creates DB + schema + seed); the app also auto-bootstraps on startup.
- Run: `./venv/Scripts/python -m uvicorn app.main:app --host 127.0.0.1 --port 8027`.
- Default admin: `admin / admin123` (change immediately).
- Dependencies: `requirements.txt` (fastapi, uvicorn, jinja2, pymysql, cryptography, python-multipart, openpyxl, itsdangerous). No CDN assets — FontAwesome 6.5.2 downloaded to `app/static/vendor`.

## 5. Verification summary (2026-11-05)

Login 303→dashboard 200; all module lists 200; brand create → FG003; item create → default batch; depot create → 2 default stores; template download (5.3KB) + upload import; delete → INACTIVE; restore → ACTIVE; audit log records CREATE/DELETE/RESTORE/LOGIN; VIEWER restrictions enforced; /users /roles /permissions screens 200 (GET /users/create correctly redirects).
