# SSMS Single Source of Truth (SSOT) — Resume.md
<!-- Synced with repo state at commit 5566591 · Date: 2026-11-17 -->

> **Purpose:** This document is the authoritative **Single Source of Truth (SSOT)** and primary **Session Resumption & Alignment Guide** for the Secondary Sales Management System (SSMS). Any developer or AI agent resuming work on this repository must align with the architecture, non-negotiables, conventions, and status codified here.

---

## 1. System Identity & Runtime Environment

| Property | Value / Canonical Definition |
|---|---|
| **Product** | Secondary Sales Management System (SSMS) |
| **Tenant / Company ID** | `SMART` (default multi-tenant prefix `cid`) |
| **Backend Framework** | FastAPI (Python 3.11, server-rendered Jinja2 templates) |
| **Database Engine** | MariaDB 10.4 / MySQL 8 (`smart_27` schema on `127.0.0.1:3306`) |
| **Database Driver** | PyMySQL (raw SQL execution via `app.database.q`, `x`, `scalar`; auto-resolves `localhost` to `127.0.0.1`) |
| **DB Credentials** | User: `root`, Password: `""` (empty string) |
| **App Server Command** | `./venv/Scripts/python -m uvicorn app.main:app --host 127.0.0.1 --port 8027` |
| **Bootstrap / DDL** | `./venv/Scripts/python scripts/setup_database.py` (idempotent bootstrap) |
| **Consistency Gate** | `./venv/Scripts/python scripts/check_context.py` (mandatory pre-commit gate) |
| **Default Admin Creds** | User: `admin` / Password: `admin123` (Role: `SUPER_ADMIN`) |
| **Session Cookie** | `ssms_session` (Starlette signed session, 8-hour TTL) |
| **UI Shell & Menu** | Collapsible accordion sidebar with `Home`, `Item Info`, `Fieldforce Info`, `Distributor Info`, `Outlet Info`, `Settings`, `Records`, `Access Control` groups; dashboard quick actions |
| **Planned Next Phase** | Flutter mobile client (will consume REST API on same DB schema) |

---

## 2. Non-Negotiable Architectural Rules

1. **Generic CRUD Engine (`app/routers/crud.py` + `app/modules.py` + `app/hooks.py`)**  
   All master-table operations (create, view, edit, soft-delete, restore, Excel import/export) MUST flow through the generic engine. Never hand-roll independent inserts/updates for master tables. Adding a module requires:
   - Column/UI specification in `app/modules.py` (`MODULES`)
   - Business hooks in `app/hooks.py` (`HOOKS`)
   - Table definition in `scripts/ddl.sql` + seed in `scripts/setup_database.py`
2. **Central Application-Written Audit (`sm_audit_log`)**  
   Every state modification is recorded via `app/audit.py:log_change`. No database triggers are permitted. Audit failures must be non-blocking.
3. **Strict Granular Access Control (ACL)**  
   Every route must enforce `require_perm(user, "module.action")`. Permissions follow `{module}.{action}` syntax (81 canonical seeded permissions). Super administrators (`is_super=1`) bypass checks.
4. **Frozen Schema Names & Intentional Anomalies**  
   Column and table names in `scripts/ddl.sql` are strictly frozen to preserve legacy compatibility, including the historical spelling `expiary_date` in `sm_item_batch`.
5. **No External CDNs**  
   No external asset links (CSS/JS/Fonts) are allowed. All vendor assets are vendored locally under `app/static/vendor/` (e.g., Font Awesome 6.5.2).
6. **Code Wins Over Documentation**  
   When code and documentation diverge, code symbols and runtime behavior are canonical. Update the stale document/INDEX, never alter code to match an outdated document.
7. **Single Source of Truth (SSOT) Fact Architecture**  
   Every fact lives in exactly one canonical file (mapped in `brain/INDEX.md` §1). Restating a mapped fact across multiple documents is treated as an architectural defect.
8. **Pre-Commit Verification Protocol**  
   `./venv/Scripts/python scripts/check_context.py` must exit 0 before completing any task or committing changes.

---

## 3. Domain Vocabulary & Core Invariants

### 3.1 Item Hierarchy & Item Master
- **Hierarchy Structure (`sm_item_hierarchy`):** 4 strict depth tiers (0 to 3) capped by `app/hooks.py MAX_DEPTH = 3`:
  - Depth 0 = **Company** (`level0`, auto-prefix `MG`)
  - Depth 1 = **Brand** (`level1`, auto-prefix `BG`)
  - Depth 2 = **Type** (`level2`, auto-prefix `CG`)
  - Depth 3 = **Flavor** (`level3`, auto-prefix `FG`, cannot have children)
- **Hierarchy Auto-Coding:** Auto-generated per `app/hooks.py LEVEL_PREFIX`: `{prefix}{seq:03d}` (`MG001`, `BG001`, `CG001`, `FG001`).
- **Leaf Flag Invariant (`is_leaf`):** Node has `is_leaf='1'` **iff it has no ACTIVE child**. Automatically recomputed on create, rename, soft-delete, and restore (`app/hooks.py _recompute_is_leaf`).
- **Item Float Precision (D-017):** Inputs for float values (`weight`, `invoice_price`, `price`, `vat_amt`, `total_amt`, `mrp`) render HTML5 `step="any"` to prevent browser stepMismatch validation errors on arbitrary decimals; `values_from_form` cleans commas; `item_prepare` rounds `total_amt = round(price + vat_amt, 4)`.
- **Item Image Upload Parity (D-018):** Replicates Brand image upload pattern for `sm_item.image_path`. Supports up to 5 MB (`.png,.jpg,.jpeg,.gif,.webp`), stores file under `/static/uploads/sm_item_{slug}_image_{timestamp}.{ext}` after DB commit, logs CREATE/UPDATE in `sm_audit_log`, and guards against MariaDB default `'-'` broken previews.
- **Item & Batch Immutable IDs on Edit (D-020):** `item_id` in `sm_item` and `sm_item_batch` is `readonly_on_edit=True` (`readonly` input for Item, `disabled` select for Batch), protected against tampering in `item_prepare` and `item_batch_prepare`.
- **Item View Hierarchy Printout (D-020):** `/item/view/{id}` renders read-only formatted text for Company, Brand, Type, and Flavor ID and Name without `<select>` elements.
- **Rack Master Module (`sm_rack`, BR21, D-024):** Auto-coded per `app/hooks.py _next_rack_code`: `RCK{seq:04d}` (`RCK0001`). `rack_id` is immutable on edit (`readonly_on_edit=True`, protected in `rack_prepare`). Full image upload parity matching Brand/Item (`image_path` up to 5 MB, stored under `/static/uploads/sm_rack_{slug}_image_{timestamp}.{ext}`, thumbnail preview, clean handling of default `'-'`). Standard soft-delete (`status='PENDING'`) and restore (`status='ACTIVE'`).

### 3.2 Soft-Delete Semantics (Unified to `PENDING`)
- **Master Modules:** Soft delete sets `status='PENDING'`. Restore sets `status='ACTIVE'`.
- **ACL Users & Roles:** Soft delete sets `status='PENDING'`. Restore sets `status='ACTIVE'` (unified per Decision D-011).
- **Item Domain Status vs Batches:** Item master status (`ACTIVE`, `INACTIVE`, `PENDING`, `REJECTED`) is a business domain status. Changing an item to non-active cascades the status to its batch rows (`app/hooks.py item_soft_delete`).
- **Distributor Status Cascade (BR24, D-028):** Inactivating (`status='INACTIVE'`) or soft-deleting (`status='PENDING'`) a Distributor (`sm_depot`) automatically cascades synchronously to update all child stores in `sm_depot_store` to matching status (`depot_after_update`, `depot_soft_delete`). Restoring (`depot_restore`) restores all child stores to `ACTIVE`.

### 3.3 Default Auto-Provisions & Distributor Hardening
- **Default Item Batch (BR3):** Creating an item automatically creates default batch `batch_id='1'` with expiry `2100-12-31` (`app/hooks.py item_after_create`).
- **Default Distributor Stores (BR5):** Creating a distributor (depot) automatically creates two default stores: `{depot_id}140` (Commercial) and `{depot_id}170` (Damage) (`app/hooks.py depot_after_create`).
- **Distributor Stock Invariants (`sm_depot_stock_balance`, BR22, D-025, D-030):** Master under Distributor Info recording batch quantities across distributor and store (renamed from Distributor Stock Balance). Sourced via dynamic dropdowns (`depot_id`, `store_id`, `item_id`, `batch_id`) with dynamic batch hydration endpoint (`/api/item/batches?item_id=...`). Strictly non-editable (`no_edit=True`), non-deletable (`no_delete=True`), and non-importable (`no_import=True`): action buttons and templates suppressed across UI; GET/POST routes for edit, delete, restore, and upload rejected with 303 redirect. Has no `status` column; unique on `(cid, depot_id, store_id, item_id, batch_id)`. Auto-provisions zero-quantity stock records (`quantity=0`, `block_qty=0`, `batch_id='1'`, expiry `2100-12-31`) via 3 hooks: on Item create/Excel import (across all stores), on Distributor create (across default stores × all items), and on Distributor Store create (across that store × all items). Includes one-time data backfill for existing active records.
- **Distributor Store Hardening (`sm_depot_store`, BR23, D-026, D-027):** Dedicated Distributor (`depot_id`) dropdown filter on `/distributor-store` list view. Non-editable Distributor selector on `/distributor-store/edit/{id}` with `readonly_on_edit=True` (disabled select + hidden input fallback + `depot_store_prepare` backend guard).
- **Distributor Master Hardening (`sm_depot`, BR24, D-029):** Non-editable Distributor ID (`depot_id`) on `/distributor/edit/{id}` with `readonly_on_edit=True` and `depot_prepare` backend guard.

### 3.4 Dynamic Form Dropdowns & Hierarchy Standards
- **Option Display Standard:** All dynamic/foreign-key dropdown options format selectable options uniformly as `ID | Name` (e.g., `BG001 | Kurkure`).
- **Searchable Select Component:** Focus or click on a searchable single select displays all options matching an empty search query rather than filtering out entries matching placeholder text (`app.js`).
- **Hierarchy Cascade Auto-Hydration:** In Item edit, previously saved hierarchy levels (`company_id`, `brand_id`, `type_id`, `flavor_id`) sequentially auto-hydrate from database values asynchronously.
- **Empty-Table Parent Options Fix (D-016):** `_hierarchy_parent_opts`, `_top_level_parent_opts`, and `_level_parent_opts` return `list(q(...))` and explicitly provide root option (`level_id='0'`), preventing list concatenation type crashes on empty database setups and permitting initial root creation.
- **Option Whitespace Sanitization (D-022):** Single-line `<option>` markup in `form.html` and whitespace trimming in `app.js` prevent multiline indentation spaces from contaminating select option labels. Root options cleanly suppress redundant prefixes.
- **Distributor Town Dropdown (D-017):** In `distributor` (`sm_depot`), `town_id` is excluded from form; `town_name` renders as searchable select dynamically populated from `sm_level` (depth 1, active) as `level_id | level_name`. `depot_prepare` auto-synchronizes `town_id` and `town_name`.

### 3.5 Fieldforce Architecture & Invariants (BR14–BR20)
- **National Structure (`sm_top_level`, BR14):** 4-tier tree: National (depth 0, prefix `H`) > Area (depth 1, prefix `A`) > Zone (depth 2, prefix `Z`) > Territory (depth 3, prefix `T`, leaf). Auto-codes (`H0001`, `A0001`, `Z0001`, `T0001`), lineage `level0..level3`, dynamic `is_leaf`. Parent level options restricted to Root and depth 0 active records; `image_path` removed (D-020).
- **Field Structure (`sm_level`, BR15):** 4-tier market coverage tree: Territory (depth 0, prefix `T`, from `sm_top_level` depth 3) > Town (depth 1, prefix `TW`) > Route (depth 2, prefix `R`) > Beat (depth 3, prefix `B`, leaf).
  - *Territory Sync (D-019, D-021):* Field Structure root (`depth = 0`) validates and syncs from active National Structure Territories (`sm_top_level` depth 3). Parent Level options on `/level/create` and `/level/edit` are sourced dynamically from active Zones (`sm_top_level` depth 2).
  - *Dynamic Zone-to-Territory Filter (D-022):* Territory input/select is dynamically filtered by selected Parent Zone (`parent_level_id = zone_id`). `level_prepare` rejects cross-zone mismatches on both create and edit.
  - *Distributor Tagging & Cascade (D-019):* Distributor tagging (`depot_id`) is scoped strictly to Town (`depth = 1`). Route (`depth = 2`) and Beat (`depth = 3`) inherit distributor from Town. Editing a Town distributor automatically cascades to all descendant Routes and Beats (`level_after_update`).
  - *Route & Beat Code Length (D-023):* Auto-generated codes for Route (prefix `R`, depth 2) and Beat (prefix `B`, depth 3) use 7-digit zero-padding (`:07d`, length 8: `R0000001`..`R0000037`, `B0000001`..`B0000037`), aligning with enterprise sample lengths. Town (`TW0001`) and Territory (`T0001`) retain standard 4-digit padding.
- **Employee Master (`sm_rep`, BR16, D-031, D-032, D-033):** Renamed to "Employee(rep/sup/dm)". Sourced dynamically from `sm_category_type` where `type_name='EMP_USER_TYPE'` (`rep` -> Pre Sales Executive / PSR, `sup` -> Supervisor / Manager, `dm` -> Delivery Man / DM). Dynamic cascading dropdown: selecting `user_type` filters `designation_id` (`rep` -> `PSR` only; `dm` -> `DM` only; `sup` -> all designations except `PSR` and `DM`). The `rep_id` is rendered non-editable (`readonly=True`, placeholder indicating auto-generation, non-editable styling) on create and edit forms; auto-generated on save following designation prefix (`PSR0001`, `DM0001`, `HOS0001`, `SOM0001`, etc.) and immutable on edit, while external integration via `emp_integration` can supply `NULL` (supported by MariaDB nullable unique key). Optional `dob` and `doj` across create, edit, and Excel import (stored as `NULL` when omitted, D-033). Passwords automatically hashed with MD5 on create/edit (preserved on blank edit). Photo upload parity (`image_path` up to 5 MB stored under `/static/uploads/sm_rep_{slug}_image_{timestamp}.{ext}`). Form fields arranged logically with Distributor (`depot_id`) and Photo / Image (`image_path`) positioned directly before Note (`note`).
- **Supervisor Area Assignment (`sm_supervisor_level`, BR17):** Assigns supervisors (`user_type='sup'`) to any hierarchy node across National (`sm_top_level`) or Field (`sm_level`) structures (`sup_id`, `level_id`, `level_depth_no`).
- **PSR Area Assignment & Cascading Beat Population (`sm_rep_area`, BR18):** PSR reps (`user_type='rep'`) assignable only to Route (`sm_level` depth 2). Saving resolves all active Beats under that Route and bulk-inserts individual Beat records into `sm_rep_area`.
- **PSR Visit Plan (`sm_visit_plan`, BR19):** Auto-populated concurrently with `sm_rep_area` assignment. Maps Beat to `order_col_day` (Saturday..Friday); automatically derives `delivery_day` as the subsequent calendar day.
- **Outlet Exceptional Visit Plan (`sm_client_visit_plan`, BR20):** Exceptional outlet scheduling by mapping `client_id` in `area_id` with visit frequency, weekly cycle (`w1`..`w5`), and weekday matrix (`sat`..`fri`).

---

## 4. Master Module Directory & Technical Specification

SSMS currently registers **16 master data modules**, plus ACL and Audit engines:

| Module Slug | Title / Group | Database Table | Primary / Unique Keys | Permissions | Hooks (`app/hooks.py`) |
|---|---|---|---|---|---|
| `brand` | Brand / *Item Info* | `sm_item_hierarchy` | `id`, (`cid`, `level_id`) | `brand.{view,create,edit,delete,import}` | `hierarchy_prepare`, `_recompute_is_leaf` |
| `item` | Item / *Item Info* | `sm_item` | `id`, (`cid`, `item_id`) | `item.{view,create,edit,delete,import}` | `item_prepare`, `item_after_create`, `item_soft_delete` |
| `item-batch` | Item Batch / *Item Info* | `sm_item_batch` | `id`, (`cid`, `item_id`, `batch_id`) | `item_batch.{view,create,edit,delete,import}` | `item_batch_prepare` |
| `rack` | Rack / *Item Info* | `sm_rack` | `id`, (`cid`, `rack_id`) | `rack.{view,create,edit,delete,import}` | `rack_prepare` |
| `distributor` | Distributor / *Distributor Info* | `sm_depot` | `id`, (`cid`, `depot_id`) | `distributor.{view,create,edit,delete,import}` | `depot_prepare`, `depot_after_create`, `depot_after_update`, `depot_soft_delete`, `depot_restore` |
| `distributor-store` | Distributor Store / *Distributor Info* | `sm_depot_store` | `id`, (`cid`, `depot_id`, `store_id`) | `distributor_store.{view,create,edit,delete,import}` | `depot_store_prepare` |
| `depot-stock-balance` | Distributor Stock / *Distributor Info* | `sm_depot_stock_balance` | `id`, (`cid`, `depot_id`, `store_id`, `item_id`, `batch_id`) | `depot_stock_balance.{view,create}` | `depot_stock_balance_prepare` |
| `outlet` | Outlet / *Outlet Info* | `sm_client` | `id`, (`cid`, `client_id`) | `outlet.{view,create,edit,delete,import}` | `outlet_prepare` |
| `category-type` | Module Category / *Settings* | `sm_category_type` | `id`, (`cid`, `type_name`, `cat_type_id`) | `category_type.{view,create,edit,delete,import}` | `category_type_prepare` |
| `top-level` | National Structure / *Fieldforce Info* | `sm_top_level` | `id`, (`cid`, `level_id`) | `top_level.{view,create,edit,delete,import}` | `top_level_prepare`, `_recompute_top_level_is_leaf` |
| `level` | Field Structure / *Fieldforce Info* | `sm_level` | `id`, (`cid`, `level_id`) | `level.{view,create,edit,delete,import}` | `level_prepare`, `level_after_update`, `_recompute_level_is_leaf`, `level_restore` |
| `rep` | Employee(rep/sup/dm) / *Fieldforce Info* | `sm_rep` | `id`, (`cid`, `rep_id`) | `rep.{view,create,edit,delete,import}` | `rep_prepare` |
| `supervisor-level` | Supervisor Area / *Fieldforce Info* | `sm_supervisor_level` | `id` | `supervisor_level.{view,create,edit,delete,import}` | `supervisor_level_prepare` |
| `rep-area` | PSR Area / *Fieldforce Info* | `sm_rep_area` | `id` | `rep_area.{view,create,edit,delete,import}` | `rep_area_prepare`, `rep_area_after_create` |
| `visit-plan` | PSR Visit Plan / *Fieldforce Info* | `sm_visit_plan` | `id` | `visit_plan.{view,create,edit,delete,import}` | `visit_plan_prepare` |
| `client-visit-plan` | Outlet Visit Plan / *Fieldforce Info* | `sm_client_visit_plan` | `id` | `client_visit_plan.{view,create,edit,delete,import}` | `client_visit_plan_prepare` |
| `acl` (screens) | Users, Roles, Permissions | `sm_acl_user`, `sm_acl_role`, `sm_acl_permission` | `user_id`, `role_id`, `perm_id` | `acl.view`, `acl.manage` | Handled in `app/routers/acl_admin.py` |
| `audit-log` | Audit Log / *Records* | `sm_audit_log` | `id` | `audit.view` | Handled in `app/audit.py` |

---

## 5. Memory Architecture & Context Retrieval Rules

To avoid context fragmentation, token bloat, and hallucinations, memory is split into specialized layers:

```
[Layer 0: Auto-Loaded / Foundation]
   ├── AGENTS.md                    # Core operational non-negotiables & session protocol
   └── .agents/skills/ssms/SKILL.md  # Framework conventions, pitfalls (Jinja, Starlette)

[Layer 1: Retrieval & Truth Layer]
   ├── Resume.md (THIS FILE)        # Root SSOT snapshot for instant session alignment
   ├── brain/INDEX.md               # Fact-to-home map (§1), Module map (§2), Anchors (§4)
   └── brain/STATUS.md              # Current system state & verified entity counts

[Layer 2: History & Auditable Logs]
   ├── brain/DECISIONS.md           # Permanent append-only architectural log (D-001 to D-033)
   └── brain/VERIFICATION_LOG.md    # Append-only verified test logs (V-001 to V-019)

[Layer 3: Task Flow & Inbox]
   ├── MY_WATCHER.txt               # Raw task inbox for user inputs
   └── brain/TASKS.md               # Structured task register (IN_PROGRESS <= 1, OPEN, DONE)

[Layer 4: Verification Tooling]
   └── scripts/check_context.py     # Automated read-only consistency & drift checker
```

### Context Loading Rules (Zero-Waste Protocol)
1. **Never read entire engine files without an anchor.** Always use line-range anchors from `brain/INDEX.md` §2.
2. **Never read the 368KB `bll_db.sql` prod dump.** Use `scripts/ddl.sql` or targeted live queries.
3. **If `brain/INDEX.md` sync stamp matches HEAD**, trust §1–§5 completely without re-reading requirements documents.

---

## 6. Standard Session Protocol for AI Agents & Developers

### Session Start Ritual
1. Run consistency check:
   ```powershell
   ./venv/Scripts/python scripts/check_context.py
   ```
   If exit code is 1, fix only the flagged drifted rows (per `brain/INDEX.md` §4a).
2. Read `Resume.md` + `brain/INDEX.md` + `brain/STATUS.md`.
3. Check `MY_WATCHER.txt`: if raw tasks exist, drain them into `brain/TASKS.md` and leave a tombstone.
4. Pick the task in `IN_PROGRESS` or the highest priority task from `OPEN`.
5. Read ONLY the module-map anchors from `brain/INDEX.md` §2 for that task.

### Session End & Task Closing Ritual
1. Update `brain/TASKS.md`:
   - If completed, move to `DONE` with format: `YYYY-MM-DD | <commit-hash> | <scope> | <result>`.
   - If work remains, fill the `IN_PROGRESS` handover block: `last commit · done this session · next concrete steps · open questions`.
2. Update counts in `brain/STATUS.md` if modules, permissions, or category types changed.
3. If an architectural decision was made, append to `brain/DECISIONS.md`.
4. If live verification succeeded, append to `brain/VERIFICATION_LOG.md`.
5. Run `./venv/Scripts/python scripts/check_context.py` — ensure exit code is 0.
6. Commit changes: `git commit -m "<module>: <action> (T-nnn)"`.

---

## 7. Current Task Register & Status

### Active Milestones Verified (V-001 to V-019)
- **V-001 (2026-11-05 · fb0e803):** Core v1.0.0 end-to-end verified (Login, dashboard, 6 master modules, ACL admin, audit log).
- **V-002 (2026-11-09 · 8b10af5):** Brand UX verified (Tree list, accordion per level, parent picker, image upload, multi-child addition, `is_leaf` invariant).
- **V-003 (2026-11-13 · 00f28df):** Excel data download & hierarchy export verified across all 7 master modules (HIERARCHY_TREE, HIERARCHY_PATHS, ITEMS with synced levels, openpyxl styling).
- **V-004 (2026-11-13 · HEAD):** Compact list layout (high-density table cells 5px 8px, card margin 12px, header 8px 14px, pager 6px 12px) and typeahead multi-select filter components (`.ms-dropdown`) verified live via HTTP against all 7 master modules with Excel export synchronization.
- **V-005 (2026-11-13 · HEAD):** Dynamic dropdowns formatting & cascade hydration: Searchable select `openAll()` un-occluded option visibility; sequential async cascade hydration on `/item/edit/{id}` preserving stored company/brand/type/flavor; `ID | Name` standard delimiter formatting across `/brand/create`, `/item/create`, `/item-batch/create`, `/distributor-store/create`, `/outlet/create`, and category/brand filter options; verified live against MySQL database with authenticated session.
- **V-006 (2026-11-14 · HEAD):** Fieldforce Info suite end-to-end verified across all 7 master modules (`top-level`, `level`, `rep`, `supervisor-level`, `rep-area`, `visit-plan`, `client-visit-plan`); GET 200 on all 14 master modules; dynamic designation sourcing from `sm_category_type` (`type_name='DESIGNATION'`); immutable auto-incrementing `rep_id` with designation prefix (e.g. `PSR0001`, `ASM0001`); 4-tier National Structure (H>A>Z>T) with auto depth & `is_leaf` recomputation; Field Structure (T>TW>R>B) validating against top-level depth 3; Route assignment auto-cascades child Beats to `sm_rep_area` and seeds `sm_visit_plan` with next-day delivery derivation; central audit logging verified across all actions.
- **V-007 (2026-11-16 · HEAD):** Hierarchy create forms on empty table (T-020): Verified GET 200 and POST 303 for `/brand/create`, `/top-level/create`, and `/level/create` on empty database tables; root nodes created with depth 0 and parent_level_id '0' without 500 error.
- **V-008 (2026-11-16 · HEAD):** Item float values & Distributor Town dropdown (T-021, T-022): Verified `/item/create` and `/item/edit` render `step="any"` for float inputs, preserving `0.0` values; `values_from_form` parses comma-separated floats; `item_prepare` computes `total_amt` rounded to 4 decimals; `/distributor/create` and `/distributor/edit` render `town_name` as searchable single-select populated from `sm_level` (depth 1, active) formatted as `ID | Name`; `depot_prepare` synchronizes `town_id` and `town_name`.
- **V-009 (2026-11-16 · HEAD):** Item image upload parity (T-023): Full lifecycle for `sm_item.image_path` on create and edit; image preview thumbnail on view; disk storage in `/static/uploads/sm_item_{slug}_image_{timestamp}.{ext}`; default `'-'` suppresses broken thumbnails.
- **V-010 (2026-11-16 · HEAD):** Field Structure Territory Sync & Town Distributor Cascade (T-024): Creating Root Territory (`depth = 0`) copies attributes from `sm_top_level` depth 3; Town (`depth = 1`) assigns distributor; Route (`depth = 2`) and Beat (`depth = 3`) auto-inherit distributor; editing Town distributor cascades to child Route and Beat records in `sm_level`.
- **V-011 (2026-11-16 · HEAD):** Hierarchy View Print, Edit Immobility & Structure Parent Selectors (T-025): `/item/view/{id}` prints hierarchy lineage without select inputs; `item_id` readonly on Item edit and disabled on Batch edit; parent selectors constrained to Root and depth 0 active records; `image_path` removed from top-level.
- **V-012 (2026-11-16 · HEAD):** Field Structure Parent Level from National Structure Zone Depth 2 (T-026): `/level/create` and `/level/edit` (depth 0) source Parent Level options from active National Structure Zones (`sm_top_level` depth 2).
- **V-013 (2026-11-16 · HEAD):** Parent Level Whitespace Fix & Dynamic Zone-to-Territory Suggestion Filter (T-027): Parent level dropdowns verified zero leading newlines; Field Structure dynamically filters Territory suggestions by selected Parent Zone; backend rejects cross-zone mismatches.
- **V-014 (2026-11-16 · HEAD):** Field Structure Route & Beat Code Length Synchronization (T-028): Auto-generation for Route (`R`) and Beat (`B`) produces 8-character codes (`R0000001`..`R0000037`, `B0000001`..`B0000037`) with 7-digit zero-padding; existing records migrated and lineage columns synced.
- **V-015 (2026-11-17 · HEAD):** My Watcher Master Modules & Distributor Hardening Suite (T-029..T-034):
  - Task 1 (T-029): `sm_rack` master module under Item Info with image upload parity and immutable `rack_id` on edit.
  - Task 2 (T-030): `sm_depot_stock_balance` master module under Distributor Info with dynamic batch endpoint (`/api/item/batches`) and strictly no edit action (`no_edit: True`).
  - Task 3 (T-031): Distributor (`depot_id`) filter on `/distributor-store` list page.
  - Task 4 (T-032): Non-editable Distributor (`depot_id`) on `/distributor-store/edit/{id}`.
  - Task 5 (T-033): Distributor status cascade on inactivate/soft-delete (`INACTIVE`/`PENDING`) and restore (`ACTIVE`) to child stores.
  - Task 6 (T-034): Non-editable Distributor ID (`depot_id`) on `/distributor/edit/{id}`.
  - Verified live via HTTP against port 8027 with full `sm_audit_log` trail.
- **V-016 (2026-11-17 · HEAD):** Distributor Stock Refinement & Auto-Provisioning Suite (T-035):
  - Module title displays "Distributor Stock"; delete, import, and status column removed.
  - Action restrictions: direct GET/POST to `/depot-stock-balance/template`, `/edit/{id}`, `/delete/{id}`, `/restore/{id}`, and `/upload` strictly redirect (303) with danger flash; action buttons and template links eliminated from UI.
  - Schema & permissions: Dropped `status` column from `sm_depot_stock_balance`, unique key `UNQ_DEPOT_STORE_ITEM_BATCH (cid, depot_id, store_id, item_id, batch_id)`; permissions catalogue reduced from 83 to 81.
  - Auto-provisioning triggers verified live: Trigger A (item create / Excel import across all stores), Trigger B (distributor create across default stores 140/170 × all items), Trigger C (distributor store create across that store × all items) inserting `qty=0`, `block_qty=0`, `batch_id='1'`, expiry `2100-12-31`.
  - One-time active data backfill executed and verified.
- **V-017 (2026-11-17 · HEAD):** Employee(rep/sup/dm) Refinement Suite (T-036):
  - Module title updated to "Employee(rep/sup/dm)" in `MODULES["rep"]`.
  - Added `EMP_USER_TYPE` (`rep`, `sup`, `dm`) to `sm_category_type` (category-type count 29 → 32).
  - Client-side cascading script filters designations dynamically based on `user_type` (`rep` -> `PSR`, `dm` -> `DM`, `sup` -> all except `PSR`/`DM`) and dispatches `ssms-refresh` to sync searchable dropdown UI.
  - Auto-generated `rep_id` on UI creation following designation prefix (`PSR0001`, `DM0001`, `SOM0001`), immutable on edit, nullable for external integrations (`emp_integration`).
  - Strict validation for required `dob` and `doj`.
  - Automated MD5 password hashing with empty-password preservation on edit.
  - Full photo upload parity (`image_path` up to 5 MB stored under `/static/uploads/sm_rep_{slug}_image_{timestamp}.{ext}`) with thumbnail rendering on view, edit, and list views.
  - Form fields rearranged into logical groups; verified live via HTTP against port 8027 with full `sm_audit_log` trail.
- **V-018 (2026-11-17 · HEAD):** Employee Form Readonly `rep_id` & Layout Positioning (T-037):
  - Form field `rep_id` configured with `readonly=True, in_list=True, placeholder="(Auto-generated on save)"` in `MODULES["rep"]`.
  - Non-editable visual styling applied via `.field input:read-only` in `style.css` (`background: var(--fb-bg, #f0f2f5); cursor: not-allowed;` with focus ring suppressed).
  - `form.html` updated to honor `s.readonly` and dynamically update placeholder text with designation prefix (`(Auto-generated: PSRxxxx on save)`).
  - Prepare hook `rep_prepare` handles empty or placeholder `rep_id` values on create by auto-generating `{prefix}{seq:04d}`.
  - Form layout rearranged: Distributor (`depot_id`) and Photo / Image (`image_path`) placed as the last two fields before Note (`note`).
  - Verified live via HTTP against port 8027 (form renders readonly `rep_id`, correct field order, and successful employee create generating `PSR0002` with `sm_audit_log` trail).
- **V-019 (2026-11-17 · HEAD):** Employee Optional Date Fields (dob / doj) Verification across Create, Edit & Import (T-038):
  - Prepare hook `rep_prepare` sanitizes empty/whitespace/'-' date values to `None` (SQL NULL) and extracts date component from Excel timestamps.
  - Verified live via HTTP against port 8027: POST `/rep/create` creates employee with `dob=None, doj=None` when omitted, and saves dates when provided.
  - Verified live: POST `/rep/edit/{id}` clears dates to `dob=None, doj=None`.
  - Verified live: POST `/rep/upload` imports rows with empty dates and populated dates seamlessly with `sm_audit_log` audit entries.

### Task Register Snapshot (`brain/TASKS.md`)

| Task ID | Priority | Module | Status | Scope / Description |
|---|---|---|---|---|
| **T-038** | **P1** | `rep` | `done` | Employee dob and doj non-mandatory across create, edit, and Excel import (V-019, D-033). |
| **T-037** | **P1** | `rep` | `done` | Employee create form refinement: `rep_id` non-editable on form with placeholder/styling; Distributor and Photo/Image positioned directly before Note (V-018, D-032). |
| **T-036** | **P1** | `rep` | `done` | Employee(rep/sup/dm) refinement: title rename, EMP_USER_TYPE category type, cascading user_type to designation, auto rep_id with designation prefix, nullable rep_id for integration, required dob/doj, MD5 password hashing, photo upload, form rearrangement (V-017, D-031). |
| **T-035** | **P1** | `depot-stock-balance` | `done` | Distributor Stock refinement: renamed from Distributor Stock Balance, removed import/delete/status (permissions 83 -> 81), added 3 zero-qty auto-provisioning triggers (item, depot, depot_store) and data backfill (V-016, D-030). |
| **T-034** | **P1** | `distributor` | `done` | Distributor ID (`depot_id`) non-editable on `/distributor/edit/{id}` with `readonly_on_edit=True` and server-side immutability in `depot_prepare` (V-015, D-029). |
| **T-033** | **P1** | `distributor` | `done` | Distributor status cascade: automatically cascades INACTIVE, PENDING (soft-delete), and ACTIVE (restore) to all child stores in `sm_depot_store` (V-015, D-028). |
| **T-032** | **P1** | `distributor-store` | `done` | Distributor selector non-editable on `/distributor-store/edit/{id}` with `readonly_on_edit=True` and backend immutability in `depot_store_prepare` (V-015, D-027). |
| **T-031** | **P1** | `distributor-store` | `done` | Distributor dropdown filter (`depot_id`) added to `/distributor-store` list page alongside status and store_type (V-015, D-026). |
| **T-030** | **P1** | `depot-stock-balance` | `done` | Distributor Stock Balance module (`sm_depot_stock_balance`) with `no_edit: True`, dropdown selectors for distributor, store, item, and batch, with auto expiry resolution (V-015, D-025). |
| **T-029** | **P1** | `rack` | `done` | Rack Master module (`sm_rack`) under Item Info with image upload parity, immutable `rack_id` on edit, full CRUD, and Excel export/import (V-015, D-024). |
| **T-028** | **P1** | `level` | `done` | Field Structure Route and Beat code length synchronization (R0000037, B0000037 8-character zero-padded format) with `sm_level` data migration (V-014, D-023). |
| **T-027** | **P1** | `level` | `done` | Parent Level option whitespace fix in `/top-level/create` and `/level/create`; dynamic Zone-to-Territory suggestion filter in Field Structure (V-013, D-022). |
| **T-026** | **P1** | `level` | `done` | Field Structure Parent Level options from `sm_top_level` depth 2 (active Zones) for `/level/create` and `/level/edit` with depth 3 Territory name sync (V-012, D-021). |
| **T-025** | **P1** | `core` | `done` | Item view hierarchy print, readonly `item_id` on item/batch edit, top-level parent depth 0 without image, level parent depth 0 with territory select (V-011, D-020). |
| **T-024** | **P1** | `level` | `done` | Field Structure territory sync from `sm_top_level` depth 3 + town-level distributor tagging and route/beat auto-cascade (V-010, D-019). |
| **T-023** | **P1** | `item` | `done` | Item image upload: replicate Brand image upload pattern for `sm_item.image_path` on `/item/create` and `/item/edit/{id}`, guard against `'-'` defaults in `form.html`, and update docs (V-009, D-018). |
| **T-022** | **P1** | `distributor` | `done` | Distributor Town dropdown from active `sm_level` depth 1 Towns with `ID \| Name` formatting and `depot_prepare` sync (V-008, D-017). |
| **T-021** | **P1** | `item` | `done` | Item float values precision with HTML5 `step="any"` and `total_amt` auto-calculation in `item_prepare` (V-008, D-017). |
| **T-020** | **P1** | `brand` | `done` | Hierarchy create forms on empty table: wrap `q(...)` in `list()` and include root options to prevent 500 crashes (V-007, D-016). |
| **T-013..19** | **P1** | `fieldforce` | `done` | Fieldforce Info Suite: National Structure, Field Structure, Employee Master, Supervisor Area, PSR Area, PSR Visit Plan, Outlet Exceptional Visit Plan (V-006, D-015). |
| **T-012** | **P1** | `all` | `done` | Dynamic dropdowns sweep: searchable select un-occluded open on focus/click; sequential cascade hydration on Item edit; `ID \| Name` format across dropdowns (V-005, D-014). |
| **T-010..11**| **P2** | `ui` | `done` | Compact list-page layout (5px 8px padding) and typeahead multi-select filter components (`.ms-dropdown`) with SQL `IN (...)` filtering (V-004, D-013). |
| **T-004** | **P2** | `all` | `done` | Filtered Excel data download button on list pages and hierarchy-synced exports (V-003, D-012). |
| **T-001** | **P0** | `outlet` | `done` | Backfill outlet module documentation across PRD, SRS, schema, README, PROMPTS, and STATUS (V-003, D-010). |
| **T-002..03**| **P1** | `item/batch` | `backlog` | Item and Item Batch refinement backlog (brand filters, active dropdowns). |
| **T-005..06**| **P2/3** | `core/brand` | `backlog` | Clarifications on menu highlighting and brand delete button leaf conditions. |
| **T-007..09**| **P3** | `api/core` | `backlog` | REST API routes for Flutter mobile app, additional category types, and automated pytest suite. |

---

## 8. Architectural Decision Summary (D-001 to D-033)

- **D-001:** Generic CRUD engine (`app/modules.py` + `app/routers/crud.py`). Avoid per-module route forks.
- **D-002:** Strict schema fidelity (`scripts/ddl.sql`) with MariaDB 10.4 normalized indexes; retain `expiary_date` spelling.
- **D-003:** App-only central audit (`sm_audit_log`) around create, update, delete, restore, and auth events.
- **D-004:** Role-based access control with direct user permissions, CID tenancy scoping, and super-admin bypass.
- **D-005:** Zero CDN policy — vendor local CSS, JS, and Font Awesome assets.
- **D-006:** Facebook-inspired clean UI palette + collapsible accordion navigation.
- **D-007:** Secure multipart image upload pipeline with post-DB-write disk storage.
- **D-008:** Pure client-side searchable select enhancement keeping native form submission intact.
- **D-009:** `is_leaf` invariant dynamically recomputed from active children.
- **D-010:** Outlet master (`sm_client`) registered on generic engine with automatic customer type generation.
- **D-011:** Soft-delete vocabulary across both master data and ACL unified to `status='PENDING'`.
- **D-012:** Filtered Excel Data Export with Hierarchy Synchronization (`GET /{slug}/export`, `/{slug}/download`) implemented as synchronous `def module_export` executed via threadpool, exporting styled sheets (`HIERARCHY_TREE`, `HIERARCHY_PATHS`, `ITEMS` with synced levels).
- **D-013:** Compact High-Density Table Layout & Typeahead Multi-Select Filter Components: minimal table cell padding (5px 8px), tight card headers and search bars, zero-CDN vanilla JS/CSS multi-select dropdowns (`.ms-dropdown`) with real-time text search, multi-key/comma-separated query serialization, and SQL `IN (...)` filtering synchronized across list views, pagination, and Excel export.
- **D-014:** Standardized `ID | Name` Dynamic Option Formatting & Sequential Hierarchy Hydration: Standardized dynamic dropdown options across master forms and filters to canonical `ID | Name`. Fixed searchable select component in `app.js` (`select[data-searchable]`) to display all valid options on focus/click without placeholder occlusion. Implemented asynchronous sequential cascade hydration loop (`0 -> company -> brand -> type -> flavor`) in `app/templates/generic/form.html` to auto-hydrate saved hierarchy selections from DB values during Edit without clearing child tiers. Corrected `form.html` select field disable logic from `s.name != 'status'` to `s.readonly_on_edit`, restoring editability for category and pack attributes.
- **D-015:** Fieldforce Info Suite Architecture: 7 master modules (top-level, level, rep, supervisor-level, rep-area, visit-plan, client-visit-plan). Dynamic designations from `sm_category_type` (type_name='DESIGNATION'); immutable auto-incrementing `rep_id` (`HOS0001`, `PSR0001`); 4-tier lineage with auto-prefixes (`H/A/Z/T` and `T/TW/R/B`) and dynamic `is_leaf`; auto-cascading Beat associations and next-day visit plans from Route assignment in `sm_rep_area`; central audit logging and soft-delete (`status='PENDING'`) enforced across all 7 modules.
- **D-016:** Hierarchy Empty-Table Parent Options & List Concatenation: Wrapped PyMySQL `q(...)` calls in `list(...)` and added root option (`level_id='0'`) in `_hierarchy_parent_opts`, `_top_level_parent_opts`, and `_level_parent_opts` in `app/routers/crud.py`, eliminating list-concatenation crashes on empty tables and enabling initial root record creation.
- **D-017:** Item Float Precision & Distributor Town Dropdown: Configured HTML5 `step="any"` for float inputs in `form.html`, comma-cleaning in `values_from_form`, and 4-decimal rounding for `total_amt = round(price + vat_amt, 4)` in `item_prepare`. Configured Distributor `town_name` as searchable select populated dynamically from active Towns (`sm_level` depth 1) as `level_id | level_name`, with `depot_prepare` synchronizing `town_id` and `town_name`.
- **D-018:** Item Image Upload (`sm_item.image_path`) Pattern Parity: Added `image_path` field spec to Item master, post-DB-write storage under `/static/uploads/sm_item_{slug}_image_{timestamp}.{ext}`, thumbnail preview on view/edit, and suppression of MariaDB default `'-'` broken links.
- **D-019:** Field Structure Territory Sync & Town Distributor Tagging / Cascade: Synchronized Field Structure root (`sm_level` depth 0) with National Structure Territories (`sm_top_level` depth 3, active). Distributor tagging is scoped strictly to Town (`depth = 1`). Route (`depth = 2`) and Beat (`depth = 3`) inherit distributor from ancestor Town. Updating Town distributor automatically cascades new distributor to all descendant Routes and Beats (`level_after_update`).
- **D-020:** Item View Hierarchy Print, Form Edit Immobility & Top/Field Level Parent Dropdown Constraints: Item view renders read-only hierarchy lineage printout without `<select>` elements. `item_id` marked `readonly_on_edit=True` on Item and Batch forms and protected in prepare hooks. `_top_level_parent_opts()` and `_level_parent_opts()` constrained to depth 0 active records plus Root; `image_path` removed from top-level form fields and excel export.
- **D-021:** Field Structure Parent Level Sourced from National Structure Depth 2: In Field Structure (`/level/create` and `/level/edit`), Parent Level options are sourced dynamically from active Zones in National Structure (`sm_top_level` where `depth = 2` and `status = 'ACTIVE'`). On `/level/create` and `/level/edit` (for depth 0 Territory records), Parent Level renders an active searchable select populated via `_level_parent_opts()`.
- **D-022:** Parent Level Whitespace Fix & Dynamic Zone-to-Territory Suggestion Filter: Formatted `<option>` tags on a single line in `form.html` and added trimming in `app.js` to eliminate multiline indentation spaces from dropdown labels; Root option suppresses prefix `0 | `. In Field Structure (`/level/create` and `/level/edit`), `level_name` suggestions (Territory from `sm_top_level` depth 3) are filtered dynamically by the selected Parent Zone (`sm_top_level` depth 2). Backend validation in `level_prepare` rejects cross-zone mismatches.
- **D-023:** Field Structure Route & Beat Code Length Synchronization: Route (prefix `R`, depth 2) and Beat (prefix `B`, depth 3) auto-generated codes synchronized to the 8-character enterprise format (`R0000037`, `B0000037`) using 7-digit zero-padding (`:07d`) in `_next_field_level_code(cid, prefix)` in `app/hooks.py`. Existing records in `sm_level` and path foreign key columns normalized to 8-character format.
- **D-024:** Rack Master Module (`sm_rack`) under Item Info: Auto-coded `RCK{seq:04d}` (`RCK0001`), `rack_id` immutable on edit (`readonly_on_edit=True`), full image upload pipeline parity with Brand/Item (`image_path`), and standard soft-delete (`status='PENDING'`).
- **D-025:** Distributor Stock Balance Master Module (`sm_depot_stock_balance`): Snapshot module under Distributor Info recording item-batch stock balances per distributor and store. Dynamic `/api/item/batches?item_id=...` endpoint hydrates batches for selected item. Configured with strictly no edit module or edit action (`no_edit=True`), hiding edit buttons and rejecting GET/POST edit access with 303 redirect.
- **D-026:** Distributor Store List Page Distributor Filter: Added `depot_id` dropdown filter on `/distributor-store` list view, populated from active distributors and synchronized with search, pagination, and Excel export.
- **D-027:** Distributor Store Edit Immobility for Distributor Selection: Configured `depot_id` with `readonly_on_edit=True` in `sm_depot_store`. `form.html` renders disabled select with hidden fallback input; `depot_store_prepare` guards backend against tampering.
- **D-028:** Distributor Status Inactivation and Soft-Delete Cascade: Updating a Distributor (`sm_depot`) to `INACTIVE` or soft-deleting to `PENDING` cascades synchronously to update all child stores in `sm_depot_store` to matching status (`depot_after_update`, `depot_soft_delete`). Restoring (`depot_restore`) restores child stores to `ACTIVE`.
- **D-029:** Distributor Master Edit Immobility for Distributor ID: Configured `depot_id` with `readonly_on_edit=True` in `sm_depot` module spec and backend guard in `depot_prepare` to prevent primary business key mutation on edit.
- **D-030:** Distributor Stock Module Refinement, Action Restrictions & Zero-Quantity Auto-Provisioning: Renamed module from "Distributor Stock Balance" to "Distributor Stock" (`depot-stock-balance` / `sm_depot_stock_balance`). Configured `no_delete=True, no_import=True` alongside `no_edit=True`; gated delete and upload routes with 303 Redirect; suppressed action buttons and templates across UI; purged delete and import from permissions catalogue (83 → 81). Dropped `status` column from schema, live DB, and module spec; replaced key with `UNQ_DEPOT_STORE_ITEM_BATCH (cid, depot_id, store_id, item_id, batch_id)`. Wired 3 zero-quantity stock auto-provisioning triggers (`qty=0`, `block_qty=0`, `batch_id='1'`, expiry `2100-12-31`) in `app/hooks.py`: (1) `item_after_create` (item creation / Excel import) across all stores, (2) `depot_after_create` (distributor creation) across default stores 140/170 × all items, and (3) `depot_store_after_create` (distributor store creation) across created store × all items. Executed one-time data backfill across all existing stores and items.
- **D-031:** Employee(rep/sup/dm) Dynamic Cascading, Designation-Based ID Generation, MD5 Password Encryption & Avatar Upload: Refined `sm_rep` master module (`MODULES["rep"]`) with title "Employee(rep/sup/dm)". Added `EMP_USER_TYPE` (`rep`, `sup`, `dm`) to `sm_category_type` (category-type count 29 → 32). Implemented client-side cascading script in `form.html` and backend cross-validation in `rep_prepare` (`user_type` cascades to `designation_id`: `rep` → PSR, `dm` → DM, `sup` → non-PSR/non-DM). Auto-generated `rep_id` on UI creation formatted as `{designation_prefix}{seq:04d}` (`PSR0001`, `DM0001`, `SOM0001`), immutable on edit, and nullable for external integration (`emp_integration`). Enforced mandatory `dob` and `doj`. Automated MD5 password hashing with empty-password preservation on edit. Added full image upload parity for `image_path` (up to 5 MB, stored under `/static/uploads/sm_rep_{slug}_image_{timestamp}.{ext}`, thumbnail rendering on view, edit, and list views). Rearranged form fields into logical groups.
- **D-032:** Employee Form Readonly `rep_id` and Layout Adjustment: Added `readonly=False` and `placeholder=None` capability to generic field helper `f(...)` in `app/modules.py`. Marked `rep_id` as `readonly=True, in_list=True, placeholder="(Auto-generated on save)"`. Updated `app/templates/generic/form.html` to output `readonly` and `tabindex="-1"` attributes, with dynamic JS placeholder reflection on designation change (`(Auto-generated: {prefix}xxxx on save)`). Added universal `.field input:read-only` styling in `app/static/css/style.css`. In `app/hooks.py` (`rep_prepare`), treated empty or placeholder string `rep_id` inputs as trigger to generate auto-code. Rearranged form fields in `MODULES["rep"]` so Distributor (`depot_id`) and Photo / Image (`image_path`) are positioned as the last two fields before Note (`note`).
- **D-033:** Employee Date Fields (dob / doj) Made Non-Mandatory Across Create, Edit & Import: Relaxed mandatory constraint on Date of Birth (`dob`) and Date of Joining (`doj`) in `MODULES["rep"]`. In `app/hooks.py` (`rep_prepare`), removed strict required check; sanitized empty, whitespace, or `"-"` inputs to SQL `NULL` (`None`) while extracting date part from Excel timestamps (`YYYY-MM-DD`). In `sm_rep`, columns `dob` and `doj` remain nullable `date DEFAULT NULL`, enabling optional employee dates across manual form creation, edit updates (clearing dates), and bulk Excel imports.

---

## 9. System Health & Audit Checkpoint

- **Context Checker Status:** **PASS (15/15 checks clean)** via `scripts/check_context.py`.
- **Active Master Modules:** 16 master modules registered and verified across BRD/PRD/SRS/README/PROMPTS/INDEX.
- **Verification Milestones:** 19 verification milestones verified live (V-001 through V-019).
- **Known Technical Debt / Pending Actions:**
  1. Untrack legacy session/cookie files (`cookies`, `cookies2`, `server.log`) via `.gitignore`.
  2. Clean cosmetic flash message strings in `app/routers/acl_admin.py:155,242` ("set to INACTIVE" text residue).
