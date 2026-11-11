# INDEX — synced at commit 48f846f · 2026-11-11

The retrieval layer. Read this + `brain/STATUS.md` first; load everything else **only** as
directed below. Re-index procedure: §4a. Anchor syntax `file:line (symbol)` — verified by
`scripts/check_context.py`.

## §1 Facts → single source of truth (value stated here once; home = code)
| Fact | Value | Canonical home |
|---|---|---|
| Hierarchy auto-code prefixes | MG=Company, BG=Brand, CG=Type, FG=Flavor | `app/hooks.py:6 (LEVEL_PREFIX)` |
| Hierarchy max depth | 3 | `app/hooks.py:5 (MAX_DEPTH)` |
| Master-module soft-delete value | `status='PENDING'` | `app/routers/crud.py:615` |
| ACL user/role soft-delete value | `status='INACTIVE'` | `app/routers/acl_admin.py:147` |
| Default item batch | `batch_id='1'`, expiry `2100-12-31` | `app/hooks.py:217 (item_after_create)` |
| Default distributor stores | `{depot_id}140` Commercial / `{depot_id}170` Damage | `app/hooks.py:307 (depot_after_create)` |
| `is_leaf` invariant | `1` iff no ACTIVE child | `app/hooks.py:101 (_recompute_is_leaf)` |
| Item status cascade | non-active item status pushed to its batch rows | `app/hooks.py:244 (item_soft_delete)` |
| Permission catalogue | 39 seeded | `scripts/setup_database.py:17 (SEED_PERMISSIONS)` |
| Category-type values | 17 seeded (incl. OUTLET_CATEGORY/OUTLET_SUB_CATEGORY) | `scripts/setup_database.py (SEED_CATEGORY_TYPES)` |
| Module registry | 7 master modules | `app/modules.py:31 (MODULES)` |
| Hook registry | one entry per module | `app/hooks.py:427 (HOOKS)` |
| Frozen schema names | incl. typo `expiary_date` | `scripts/ddl.sql` (header = change-log) |
| Run command + admin creds + DB coords | — | `AGENTS.md` (How to verify / nn5) |
| UI palette values | — | `docs/PRD.md` §2.3 |
| Jinja / Starlette / access / seed pitfalls | — | `.agents/skills/ssms/SKILL.md` |
| Legacy demo codes | existing DBs keep seeded `CG001`(company)/`TG001`(type); fresh installs use MG/CG | `scripts/setup_database.py SEED_HIERARCHY` |

## §2 Module map (task-context entry point: read ONLY the row's anchors for a module task)
| Module | Table | Registry | Hook(s) | Perm | Route | Depends on | Docs |
|---|---|---|---|---|---|---|---|
| brand | sm_item_hierarchy | `app/modules.py:33 ("brand")` | `app/hooks.py:10 (hierarchy_prepare)` + HOOKS `hierarchy` | brand | /brand | — | PRD §2.4.1 |
| item | sm_item | `app/modules.py:64 ("item")` | `app/hooks.py:171 (item_prepare)`, `:217 (item_after_create)`, `:244 (item_soft_delete)` | item | /item | hierarchy | PRD §2.4 |
| item-batch | sm_item_batch | `app/modules.py:113 ("item-batch")` | `app/hooks.py:267 (item_batch_prepare)` | item_batch | /item-batch | item | PRD §2.4 |
| distributor | sm_depot | `app/modules.py:145 ("distributor")` | `app/hooks.py:291 (depot_prepare)`, `:307 (depot_after_create)` | distributor | /distributor | — | PRD §2.4 |
| distributor-store | sm_depot_store | `app/modules.py:194 ("distributor-store")` | `app/hooks.py:323 (depot_store_prepare)` | depot_store | /distributor-store | distributor | PRD §2.4 |
| outlet | sm_client | `app/modules.py:221 ("outlet")` | `app/hooks.py:371 (outlet_prepare)` | outlet | /outlet | category_type, depot, depot_store | *(T-001 backfill pending)* |
| category-type | sm_category_type | `app/modules.py:271 ("category-type")` | `app/hooks.py:342 (category_type_prepare)` | category_type | /category-type | — | PRD §2.4 |

ACL screens: `app/routers/acl_admin.py` (users/roles/permissions — include BEFORE crud router).
Engine: `app/routers/crud.py` (generic CRUD + Excel + `_access` gate). Sidebar/menu: `app/modules.py:298 (MODULE_ORDER)`.

## §3 Doc map (what to read for what; skip unless §4 sends you)
| Question | File | Last-sync |
|---|---|---|
| Business needs, BR1–BR11 rules | `docs/BRD.md` | 48f846f |
| Page journeys, acceptance criteria | `docs/PRD.md` | 48f846f |
| Architecture, FR1–FR6, data model | `docs/SRS.md` | 48f846f |
| How to run, route table | `README.md` | 48f846f |
| Operator prompt templates | `prompts/PROMPTS.md` | 48f846f |
| Original frozen requirements (fidelity disputes ONLY) | `req.txt` | never changes |

## §4 Conditional-loading rules
| IF the task involves… | THEN read | NEVER read |
|---|---|---|
| a specific module | its §2 row anchors (line-ranges only) | whole engine files without an anchor |
| schema / DDL | `scripts/ddl.sql` header + relevant CREATE TABLE | `bll_db.sql` (368KB prod dump — query the live DB instead, targeted SELECT) |
| a fidelity dispute (is the DDL right?) | `req.txt` targeted section | — |
| a business-rule change | BRD rule (§3) → code anchor from §1 | PRD/SRS full read |
| a new master module | AGENTS.md checklist + one similar §2 row | all three docs |
| history ("why is it like this?") | `brain/DECISIONS.md` filtered by module tag | — |
| release / handover | `brain/STATUS.md` + `VERIFICATION_LOG.md` tail + `TASKS.md` | everything else |

## §4a Re-index procedure (change detection)
1. Compare INDEX `synced-at` vs HEAD: equal → trust §1–§5 wholesale, read no docs.
2. HEAD newer → `git diff --stat <synced-at>..HEAD -- app scripts docs brain`: re-verify **only** rows whose anchors/facts the diff touched; re-run `scripts/check_context.py`; update this header stamp.
3. Code vs INDEX disagree → code wins; fix the INDEX row (and the stale doc, if any), never "fix" code to match a doc.

## §5 Tasks
Open work: `brain/TASKS.md` (T-001 outlet docs backfill P0; T-002..T-009). IN_PROGRESS ≤1, with handover block.
