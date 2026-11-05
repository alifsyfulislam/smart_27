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
Groups: **Top** (Dashboard) · **Item Info** (Brand, Item, Item Batch) · **Distributor Info** (Distributor, Distributor Store) · **Settings** (Category Type) · **Administration** (Users, Roles, Permissions) · **Records** (Audit Log).
Accordion behavior — opening a group collapses the others (persisted in localStorage); a toggle
collapses the sidebar to icon rail on desktop, drawer + overlay on mobile; smooth CSS transitions;
Font Awesome icons; Facebook-style colors (#1877f2 primary, #f0f2f5 background, #050505/#65676b text).

### 2.4 Master modules (generic engine driven by `app/modules.py`)
Per module: **Brand**, **Item**, **Item Batch**, **Distributor**, **Distributor Store**, **Category Type**

| Feature | Behavior |
|---|---|
| Create | Form with validation + business-code generation (see hooks) |
| View | Read-only record page |
| Edit | Edit form (business IDs editable where allowed; hierarchy parent fixed after create) |
| Soft delete | status → INACTIVE (for brand: subtree INACTIVE); restore reverses with parent-active check |
| Excel import | Template download (xlsx) + upload panel; row-by-row insert reusing form hooks; per-row error report |
| Search/filter | Free-text search over configured columns + dropdown filters (status, category selects) |
| Pagination | Configurable page size (10/25/50/100), page window, record counts |

### 2.5 Administration
- **Users**: create/edit (name, email, password reset, super flag, status, role checkboxes), soft delete/restore; cannot deactivate own account.
- **Roles**: create/edit with permission checkboxes grouped by module; soft delete.
- **Permissions**: read list + create new entries.

### 2.6 Audit Log (`/audit-log`)
Filter by table, action, user, free text; expandable old/new JSON values; paginated.

## 3. Module hooks (business logic)

| Hook | Detail |
|---|---|
| `hierarchy.prepare` | Auto level code (`CG/BG/TG/FG` + padded sequence), max depth 3, name-uniqueness under parent, path fill, is_leaf handling |
| `hierarchy.after_create` | Parent `is_leaf` → 0 |
| `hierarchy.after_update` | Rename propagation to `parent_level_name` and `level{n}_name` of descendants |
| `hierarchy.soft_delete/restore` | Subtree cascading with parent-active check on restore |
| `item.after_create` | Default batch `batch_id='1'`, `expiary_date='2100-12-31'` |
| `depot.after_create` | Default stores `{id}140` Commercial / `{id}170` Damage |
| `item_batch.prepare` | Item existence, auto name, uniqueness per item |
| `depot_store.prepare` | Depot existence, uniqueness per depot |
| `item.prepare` / `depot.prepare` / `category_type.prepare` | Uniqueness + name resolution from hierarchy ids |

## 4. Permissions catalogue (seed)

`dashboard.view`; per module `{brand,item,item_batch,distributor,depot_store,category_type}.{view,create,edit,delete,import}`; `acl.view`, `acl.manage`; `audit.view` — 34 seeded permissions, roles SUPER_ADMIN (all), MANAGER, VIEWER.

## 5. Acceptance criteria (verified 2026-11-05)

- Creating a flavor under TG001 auto-codes `FG003` and flips TG001 `is_leaf` to 0.
- Creating item `1101` creates default batch `1` (2100-12-31); audit rows `CREATE sm_item`, `CREATE sm_item_batch` written.
- Creating distributor `131313` auto-creates stores `131313140` (Commercial) and `131313170` (Damage).
- Excel template download 200; upload creates rows and reports errors; soft delete → INACTIVE; restore → ACTIVE; each logged in `sm_audit_log`.
- VIEWER can browse but every write action is blocked; unknown modules redirect to the dashboard.
