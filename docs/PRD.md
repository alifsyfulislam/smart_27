# Product Requirements Document (PRD)
## Secondary Sales Management System (SSMS)

**Version:** 1.0.0 · **Depends on:** docs/BRD.md · **Stack:** FastAPI + Jinja2 + PyMySQL + openpyxl

---

## 1. Product overview

A web application (server-rendered Jinja2 templates over a FastAPI backend) that manages
secondary-sales master data with login-based access control and full auditability.

## 2. Pages & journeys

### 2.1 Login (`/login`)
- User ID + password. Session cookie (8h). Failed logins show an inline error.
- All other routes redirect here when not authenticated.

### 2.2 Dashboard (`/`)
- Stat cards: items active/inactive, batches, distributors active/inactive, stores, users, roles.
- Item-hierarchy distribution bars (Company/Brand/Type/Flavor counts).
- Recent 8 audit entries; quick actions (new level/item/batch/distributor, template downloads).

### 2.3 Sidebar navigation
Groups: **Top** (Dashboard) · **Item Info** (Brand, Item, Item Batch) · **Distributor Info** (Distributor, Distributor Store) · **Outlet Info** (Outlet) · **Settings** (Category Type) · **Administration** (Users, Roles, Permissions) · **Records** (Audit Log).
Accordion behavior — opening a group collapses the others (persisted in localStorage); a toggle
collapses the sidebar to icon rail on desktop, drawer + overlay on mobile; smooth CSS transitions;
Font Awesome icons; Facebook-style colors (#1877f2 primary, #f0f2f5 background, #050505/#65676b text).

### 2.4 Master modules (generic engine driven by `app/modules.py`)
Per module: **Brand**, **Item**, **Item Batch**, **Distributor**, **Distributor Store**, **Outlet**, **Category Type**

| Feature | Behavior |
|---|---|
| Create | Form with validation + business-code generation (see hooks) |
| View | Read-only record page |
| Edit | Edit form (business IDs editable where allowed; hierarchy parent fixed after create) |
| Soft delete | status → PENDING (for brand: subtree PENDING); restore reverses with parent-active check |
| Excel import | Template download (xlsx) + upload panel; row-by-row insert reusing form hooks; per-row error report |
| Search/filter | Free-text search over configured columns + dropdown filters (status, category selects) |
| Pagination | Configurable page size (10/25/50/100), page window, record counts |

### 2.4.1 Brand-specific UX (Item Info › Brand)
- **Tree list**: the hierarchy renders as an expandable tree. On load only **depth-0 (Company) nodes are expanded** — deeper levels stay collapsed and the user opens them manually. Expanding a node **auto-collapses the other open nodes in the same level** (accordion per level); clicking an expanded node collapses it.
- **Parent Level picker** is a type-to-search single select (searchable dropdown over `CODE — Name`); arrow keys + Enter work, the native select stays the value holder.
- **Image** field: file input with live preview on create; on edit the current image is previewed and a new file can be picked to replace it (empty input keeps it). Files land in `/static/uploads` as `{table}_{name-slug}_image_{timestamp}.{ext}`; the link is stored in `image_path` (PNG/JPG/GIF/WEBP, max 5 MB, extension-checked).
- **Child Levels card** on the Edit/View page: lists existing child levels (view/edit links, status badges) and, on Edit, offers one name box plus "Add another" to create **one or many** children in a single submit (`POST /{slug}/add-children/{id}`, names deduped, per-name errors reported). Disabled for Flavors (depth 3).

### 2.5 Administration
- **Users**: create/edit (name, email, password reset, super flag, status, role checkboxes), soft delete/restore; cannot deactivate own account.
- **Roles**: create/edit with permission checkboxes grouped by module; soft delete.
- **Permissions**: read list + create new entries.

### 2.6 Audit Log (`/audit-log`)
Filter by table, action, user, free text; expandable old/new JSON values; paginated.

## 3. Module hooks (business logic)

| Hook | Detail |
|---|---|
| `hierarchy.prepare` | Auto level code per `LEVEL_PREFIX` (padded sequence, values in `brain/INDEX.md` §1), max depth 3, name-uniqueness under parent, path fill, new rows start `is_leaf=1` |
| `hierarchy.after_create` | Parent leaf flag recomputed (`is_leaf=0` once it has an ACTIVE child) |
| `hierarchy.after_update` | Rename propagation to `parent_level_name` and `level{n}_name` of descendants; node + parent leaf flags recomputed from ACTIVE children |
| `hierarchy.soft_delete/restore` | Subtree cascading with parent-active check on restore; parent leaf flag recomputed on both (deleted last child → parent leaf again) |
| `crud image upload` | Any form field of type `image` (brand `image_path` today): multipart read, extension/size validation, `{table}_{slug}_image_{timestamp}` naming, file written only after the row insert/update succeeds |
| `item.after_create` | Default batch per BR3 (hook: `app/hooks.py item_after_create`) |
| `depot.after_create` | Default stores per BR5 (hook: `app/hooks.py depot_after_create`) |
| `item_batch.prepare` | Item existence, auto name, uniqueness per item |
| `depot_store.prepare` | Depot existence, uniqueness per depot |
| `outlet.prepare` | Client ID uniqueness, category & sub-category resolution, auto-generated customer_type (`category_id|category_name`), distributor & store validation |
| `item.prepare` / `depot.prepare` / `category_type.prepare` | Uniqueness + name resolution from hierarchy ids |

## 4. Permissions catalogue (seed)

`dashboard.view`; per module `{brand,item,item_batch,distributor,depot_store,outlet,category_type}.{view,create,edit,delete,import}`; `acl.view`, `acl.manage`; `audit.view` — 39 seeded permissions (catalogue: `SEED_PERMISSIONS` in `scripts/setup_database.py`), roles SUPER_ADMIN (all), MANAGER, VIEWER.

## 5. Acceptance criteria (verified 2026-11-05; brand UX re-verified 2026-11-09)

- Creating a flavor under TG001 auto-codes `FG003` and flips TG001 `is_leaf` to 0.
- Brand leaf invariant holds through the whole lifecycle: create without children → `is_leaf=1`; add child → parent `0`/child `1`; rename → unchanged; soft-delete the last child → parent back to `1`; restore → parent `0` again.
- Brand tree (verified in-browser): on page load only the depth-0 node shows its children; opening a second node in the same level collapses the first; toggling again closes the node.
- Brand create accepts an image file; the file is stored under `/static/uploads/` with the `{table}_{slug}_image_{timestamp}` name, the URL is saved in `image_path` and serves with HTTP 200; editing with no file keeps the current image; a non-image extension is rejected with a visible error.
- Brand edit page lists child levels and accepts multiple names in one submit (duplicates ignored); each child gets its own auto-code and audit row.
- Creating item `1101` creates the default batch (BR3); audit rows `CREATE sm_item`, `CREATE sm_item_batch` written.
- Creating distributor `131313` auto-creates stores `131313140` (Commercial) and `131313170` (Damage).
- Excel template download 200; upload creates rows and reports errors; soft delete → PENDING; restore → ACTIVE; each logged in `sm_audit_log`.
- VIEWER can browse but every write action is blocked; unknown modules redirect to the dashboard.
