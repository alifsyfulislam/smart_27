# Business Requirements Document (BRD)
## Secondary Sales Management System (SSMS)

**Version:** 1.0.0 · **Date:** 2026-11-05 · **Database:** smart_27 (MySQL 8 / MariaDB 10.4) · **Stack:** FastAPI web app (Flutter app planned later)

---

## 1. Purpose

SSMS manages the **master data** required before secondary-sales transactions can run:
item hierarchy (Company → Brand → Type → Flavor), items and their batches, distributors
(depots) and their stores, plus the data-definition master (category types). It enforces
role-based access control and keeps a central audit trail of every master-data change.

## 2. Scope

In scope (this release):
1. **Item Info** — Brand (item hierarchy), Item, Item Batch.
2. **Distributor Info** — Distributor, Distributor Store.
3. **Settings** — Category Type (data definitions for columns like `depot_category`, `store_type`, `pack_size`, `unit_type`, `item_category`).
4. **Access Control** — User / Role / Permission (ACL) with mapping tables.
5. **Records** — Central audit log written only by the application.

Out of scope (future): sales orders, requisitions, deliveries, payments, invoicing, and the Flutter mobile client.

## 3. Business rules

| # | Rule |
|---|------|
| BR1 | Item hierarchy levels are created manually (no integration). Levels: Company(C*) → Brand(B*) → Type(T*) → Flavor(F*), auto-coded `CG001/BG001/TG001/FGnNN` per level with parent path columns `level0..level3`. |
| BR2 | A node becomes non-leaf (`is_leaf=0`) as soon as it has a child; renaming a level propagates through descendant path columns. |
| BR3 | Items come from integration or manual creation; every item automatically gets a **default batch `1` with expiry 2100-12-31** (`sm_item_batch`). |
| BR4 | Items are tagged sequentially with Company > Brand > Type > Flavor from the hierarchy. |
| BR5 | Distributors come from integration or manual creation; every distributor automatically gets two default stores: `{depot_id}140` = **Commercial** and `{depot_id}170` = **Damage** (`sm_depot_store`). |
| BR6 | All master modules support: create, view, edit, **soft delete (status → PENDING)**, restore, and **template-based Excel batch upload**. |
| BR7 | Every master-table change (create/update/delete/restore) is recorded in the central log `sm_audit_log` **by the application only** — no DB triggers. |
| BR8 | Users are restricted by ACL: permissions like `item.view`, `item.create`, `item.edit`, `item.delete`, `item.import`, grouped under modules; roles bundle permissions; users get roles and/or direct permissions; a super-admin bypasses checks. |
| BR9 | `sm_category_type` feeds the value lists used by other modules (depot category, store type, item category, unit type). |

## 4. Users

- **Super Administrator** — full access, manages users/roles/permissions.
- **Sales Manager** — manages items, batches, hierarchy, distributors (no Excel import in seed).
- **Read Only (VIEWER)** — view only.
- Integration/system processes (future) will write via separate `intr_flag` flows.

## 5. Non-functional needs

- Login page + collapsible sidebar dashboard, modern and optimized layout.
- Responsive; Facebook-like font/background colors; eye-comfort palette.
- Sidebar accordion: opening one nav group auto-collapses the others, with smooth transitions; Font Awesome icons served **locally** (no CDN).
- Search + filters + pagination on every list.
- Runs in a Python virtual environment; default admin `admin/admin123` to be changed after first login.

## 6. Success criteria

- A super admin can create the sample hierarchy (TCPL example), an item with default batch, and a distributor with default stores without touching SQL.
- Every action above appears in the audit log with old/new values and the acting user.
- A VIEWER-role user cannot create or edit anything and cannot open admin screens.
- Excel templates download and import round-trips cleanly, reporting per-row errors.
