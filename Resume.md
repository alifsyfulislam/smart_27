# SSMS Single Source of Truth (SSOT) — Resume.md
<!-- Synced with repo state at commit 70823fb · Date: 2026-11-13 -->

> **Purpose:** This document is the authoritative **Single Source of Truth (SSOT)** and primary **Session Resumption & Alignment Guide** for the Secondary Sales Management System (SSMS). Any developer or AI agent resuming work on this repository must align with the architecture, non-negotiables, conventions, and status codified here.

---

## 1. System Identity & Runtime Environment

| Property | Value / Canonical Definition |
|---|---|
| **Product** | Secondary Sales Management System (SSMS) |
| **Tenant / Company ID** | `SMART` (default multi-tenant prefix `cid`) |
| **Backend Framework** | FastAPI (Python 3.11, server-rendered Jinja2 templates) |
| **Database Engine** | MariaDB 10.4 / MySQL 8 (`smart_27` schema on `127.0.0.1:3306`) |
| **Database Driver** | PyMySQL (raw SQL execution via `app.database.q`, `x`, `scalar`) |
| **DB Credentials** | User: `root`, Password: `""` (empty string) |
| **App Server Command** | `./venv/Scripts/python -m uvicorn app.main:app --host 127.0.0.1 --port 8027` |
| **Bootstrap / DDL** | `./venv/Scripts/python scripts/setup_database.py` (idempotent bootstrap) |
| **Consistency Gate** | `./venv/Scripts/python scripts/check_context.py` (mandatory pre-commit gate) |
| **Default Admin Creds** | User: `admin` / Password: `admin123` (Role: `SUPER_ADMIN`) |
| **Session Cookie** | `ssms_session` (Starlette signed session, 8-hour TTL) |
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
   Every route must enforce `require_perm(user, "module.action")`. Permissions follow `{module}.{action}` syntax (39 canonical permissions). Super administrators (`is_super=1`) bypass checks.
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

### 3.1 Item Hierarchy (`sm_item_hierarchy`)
- **Structure:** 4 strict depth tiers (0 to 3) capped by `app/hooks.py MAX_DEPTH = 3`:
  - Depth 0 = **Company** (`level0`, auto-prefix `MG`)
  - Depth 1 = **Brand** (`level1`, auto-prefix `BG`)
  - Depth 2 = **Type** (`level2`, auto-prefix `CG`)
  - Depth 3 = **Flavor** (`level3`, auto-prefix `FG`, cannot have children)
- **Auto-Coding:** Auto-generated per `app/hooks.py LEVEL_PREFIX`: `{prefix}{seq:03d}` (e.g., `MG001`, `BG001`, `CG001`, `FG001`).
- **Leaf Flag Invariant (`is_leaf`):** Node has `is_leaf='1'` **iff it has no ACTIVE child**. Automatically recomputed on create, rename, soft-delete, and restore (`app/hooks.py _recompute_is_leaf`).
- **Legacy Demo Code Exception:** Existing databases retain demo rows `CG001`(company) and `TG001`(type); fresh database setups initialize with canonical `MG001` and `CG001`.

### 3.2 Soft-Delete Semantics (Unified to `PENDING`)
- **Master Modules:** Soft delete sets `status='PENDING'`. Restore sets `status='ACTIVE'`.
- **ACL Users & Roles:** Soft delete sets `status='PENDING'`. Restore sets `status='ACTIVE'` (unified per Decision D-011).
- **Item Domain Status vs Batches:** Item master status (`ACTIVE`, `INACTIVE`, `PENDING`, `REJECTED`) is a business domain status. Changing an item to non-active cascades the status to its batch rows (`app/hooks.py item_soft_delete`).

### 3.3 Default Auto-Provisions
- **Default Item Batch (BR3):** Creating an item automatically creates default batch `batch_id='1'` with expiry `2100-12-31` (`app/hooks.py item_after_create`).
- **Default Distributor Stores (BR5):** Creating a distributor (depot) automatically creates two default stores: `{depot_id}140` (Commercial) and `{depot_id}170` (Damage) (`app/hooks.py depot_after_create`).

---

## 4. Master Module Directory & Technical Specification

SSMS currently registers **7 master data modules**, plus ACL and Audit engines:

| Module Slug | Title / Group | Database Table | Primary / Unique Keys | Permissions | Hooks (`app/hooks.py`) |
|---|---|---|---|---|---|
| `brand` | Brand / *Item Info* | `sm_item_hierarchy` | `id`, (`cid`, `level_id`) | `brand.{view,create,edit,delete,import}` | `hierarchy_prepare`, `_recompute_is_leaf` |
| `item` | Item / *Item Info* | `sm_item` | `id`, (`cid`, `item_id`) | `item.{view,create,edit,delete,import}` | `item_prepare`, `item_after_create`, `item_soft_delete` |
| `item-batch` | Item Batch / *Item Info* | `sm_item_batch` | `id`, (`cid`, `item_id`, `batch_id`) | `item_batch.{view,create,edit,delete,import}` | `item_batch_prepare` |
| `distributor` | Distributor / *Distributor Info* | `sm_depot` | `id`, (`cid`, `depot_id`) | `distributor.{view,create,edit,delete,import}` | `depot_prepare`, `depot_after_create` |
| `distributor-store` | Distributor Store / *Distributor Info* | `sm_depot_store` | `id`, (`cid`, `depot_id`, `store_id`) | `depot_store.{view,create,edit,delete,import}` | `depot_store_prepare` |
| `outlet` | Outlet / *Outlet Info* | `sm_client` | `id`, (`cid`, `client_id`) | `outlet.{view,create,edit,delete,import}` | `outlet_prepare` |
| `category-type` | Module Category / *Settings* | `sm_category_type` | `id`, (`cid`, `type_name`, `cat_type_id`) | `category_type.{view,create,edit,delete,import}` | `category_type_prepare` |
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
   ├── brain/DECISIONS.md           # Permanent append-only architectural log (D-001 to D-011)
   └── brain/VERIFICATION_LOG.md    # Append-only verified test logs (V-001, V-002)

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

### Active Milestones Verified
- **V-001 (2026-11-05 · fb0e803):** Core v1.0.0 end-to-end verified (Login, dashboard, 6 master modules, ACL admin, audit log).
- **V-002 (2026-11-09 · 8b10af5):** Brand UX verified (Tree list, accordion per level, parent picker, image upload, multi-child addition, `is_leaf` invariant).

### Open Task Register (`brain/TASKS.md`)

| Task ID | Priority | Module | Status | Scope / Description |
|---|---|---|---|---|
| **T-001** | **P0** | `outlet` | `done` | Backfill outlet module documentation: PRD journey, SRS FR row, `sm_client` schema doc, README route table, PROMPTS template, STATUS count sync, and live verification (V-003). |
| **T-002** | **P1** | `item` | `needs-verification` | Item sweep: list Brand filter, uniqueness check, hierarchy dropdown search, edit pre-selects, float fields calculation, status cascade to batches. |
| **T-003** | **P1** | `item_batch` | `needs-verification` | Item batch sweep: cid+item_id+batch_id uniqueness, active items dropdown, expiry default 2100-12-31, list Brand filter. |
| **T-004** | **P2** | `all` | `needs-verification` | Template download buttons presence and mode (hierarchy-mode vs standard) across all list views. |
| **T-005** | **P2** | `core` | `clarify` | Scoping active-menu highlight on sidebar when sub-modules share names (e.g., `item` vs `item-batch`). |
| **T-006** | **P3** | `brand` | `clarify` | Confirm brand delete button visibility condition (`is_leaf` logic). |
| **T-007** | **P3** | `api` | `ready` | REST API routes for planned Flutter mobile application. |
| **T-008** | **P3** | `category_type` | `ready` | Backlog: Additional category type groups (town master, approval flags). |
| **T-009** | **P3** | `core` | `ready` | Backlog: Automated test suite (pytest + httpx) for continuous verification. |

---

## 8. Architectural Decision Summary (D-001 to D-011)

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

---

## 9. System Health & Audit Checkpoint

- **Context Checker Status:** **PASS (14/14 checks clean)** at commit `70823fb`.
- **Known Technical Debt / Pending Actions:**
  1. Complete T-001 (Outlet documentation and memory backfill).
  2. Untrack legacy session/cookie files (`cookies`, `cookies2`, `server.log`) via `.gitignore` (Step 15 from Phase 4).
  3. Clean cosmetic flash message strings in `app/routers/acl_admin.py:155,242` ("set to INACTIVE" text residue).
