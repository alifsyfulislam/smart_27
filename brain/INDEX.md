# INDEX — synced at commit 9429b9f · 2026-11-18

The retrieval layer. Read this + `brain/STATUS.md` first; load everything else **only** as
directed below. Re-index procedure: §4a. Anchor syntax `file:line (symbol)` — verified by
`scripts/check_context.py`.

## §1 Facts → single source of truth (value stated here once; home = code)
| Fact | Value | Canonical home |
|---|---|---|
| Hierarchy auto-code prefixes | MG=Company, BG=Brand, CG=Type, FG=Flavor | `app/hooks.py:6 (LEVEL_PREFIX)` |
| Hierarchy max depth | 3 | `app/hooks.py:5 (MAX_DEPTH)` |
| Master-module soft-delete value | `status='PENDING'` | `app/routers/crud.py:970` |
| ACL user/role soft-delete value | `status='PENDING'` (unified with master modules 2026-11-12, see D-011) | `app/routers/acl_admin.py:149 (to_status)` |
| Default item batch | `batch_id='1'`, expiry `2100-12-31` | `app/hooks.py:231 (item_after_create)` |
| Default distributor stores | `{depot_id}140` Commercial / `{depot_id}170` Damage | `app/hooks.py:431 (depot_after_create)` |
| `is_leaf` invariant | `1` iff no ACTIVE child | `app/hooks.py:113 (_recompute_is_leaf)` |
| Item status cascade | non-active item status pushed to its batch rows | `app/hooks.py:272 (item_soft_delete)` |
| Permission catalogue | 81 seeded | `scripts/setup_database.py:17 (SEED_PERMISSIONS)` |
| Category-type values | 43 seeded (incl. OUTLET_CATEGORY/OUTLET_SUB_CATEGORY, EMP_DESIGNATION, EMP_USER_TYPE, WEEK_DAYS, FREQUENCY_TYPE) | `scripts/setup_database.py (SEED_CATEGORY_TYPES)` |
| Module registry | 17 master modules | `app/modules.py:34 (MODULES)` |
| Hook registry | one entry per module | `app/hooks.py:1537 (HOOKS)` |
| Frozen schema names | incl. typo `expiary_date` | `scripts/ddl.sql` (header = change-log) |
| Run command + admin creds + DB coords | — | `AGENTS.md` (How to verify / nn5) |
| UI palette values | — | `docs/PRD.md` §2.3 |
| Jinja / Starlette / access / seed pitfalls | — | `.agents/skills/ssms/SKILL.md` |
| Legacy demo codes | existing DBs keep seeded `CG001`(company)/`TG001`(type); fresh installs use MG/CG | `scripts/setup_database.py SEED_HIERARCHY` |

## §2 Module map (task-context entry point: read ONLY the row's anchors for a module task)
| Module | Table | Registry | Hook(s) | Perm | Route | Depends on | Docs |
|---|---|---|---|---|---|---|---|
| brand | sm_item_hierarchy | `app/modules.py:35 ("brand")` | `app/hooks.py:21 (hierarchy_prepare)` + HOOKS `hierarchy` | brand | /brand | — | PRD §2.4.1 |
| item | sm_item | `app/modules.py:66 ("item")` | `app/hooks.py:182 (item_prepare)`, `:231 (item_after_create)`, `:272 (item_soft_delete)` | item | /item | hierarchy | PRD §2.4 |
| item-batch | sm_item_batch | `app/modules.py:121 ("item-batch")` | `app/hooks.py:295 (item_batch_prepare)` | item_batch | /item-batch | item | PRD §2.4 |
| rack | sm_rack | `app/modules.py:153 ("rack")` | `app/hooks.py:338 (rack_prepare)` + HOOKS `rack` | rack | /rack | — | PRD §2.4.4, SRS §2 FR4.16 |
| distributor | sm_depot | `app/modules.py:184 ("distributor")` | `app/hooks.py:356 (depot_prepare)`, `:431 (depot_after_create)` | distributor | /distributor | — | PRD §2.4.4, SRS §2 FR4.5 |
| distributor-store | sm_depot_store | `app/modules.py:234 ("distributor-store")` | `app/hooks.py:460 (depot_store_prepare)` | depot_store | /distributor-store | distributor | PRD §2.4.4, SRS §2 FR4.6 |
| depot-stock-balance | sm_depot_stock_balance | `app/modules.py:261 ("depot-stock-balance")` | `app/hooks.py:495 (depot_stock_balance_prepare)` + HOOKS `depot_stock_balance` | depot_stock_balance | /depot-stock-balance | distributor, distributor-store, item, item-batch | PRD §2.4.4, SRS §2 FR4.17 |
| depot-rack-stock-balance | sm_depot_rack_stock_balance | `app/modules.py:303 ("depot-rack-stock-balance")` | `app/hooks.py:538 (depot_rack_stock_balance_prepare)` + HOOKS `depot_rack_stock_balance` | depot_rack_stock_balance | /depot-rack-stock-balance | distributor, outlet, rack | PRD §2.4.4, SRS §2 FR4.18 |
| outlet | sm_client | `app/modules.py:350 ("outlet")` | `app/hooks.py:590 (outlet_prepare)` | outlet | /outlet | category-type, distributor, distributor-store | PRD §2.4, SRS §2 FR4.8 |
| category-type | sm_category_type | `app/modules.py:409 ("category-type")` | `app/hooks.py:543 (category_type_prepare)` | category_type | /category-type | — | PRD §2.4 |
| top-level | sm_top_level | `app/modules.py:435 ("top-level")` | `app/hooks.py:686 (top_level_prepare)` + HOOKS `top_level` | top_level | /top-level | — | PRD §2.4, SRS §2 FR4.9 |
| level | sm_level | `app/modules.py:460 ("level")` | `app/hooks.py:812 (level_prepare)` + HOOKS `level` | level | /level | top-level, distributor | PRD §2.4, SRS §2 FR4.10 |
| rep | sm_rep | `app/modules.py:486 ("rep")` | `app/hooks.py:1090 (rep_prepare)` + HOOKS `rep` | rep | /rep | category-type, distributor | PRD §2.4, SRS §2 FR4.11 |
| supervisor-level | sm_supervisor_level | `app/modules.py:538 ("supervisor-level")` | `app/hooks.py:1186 (supervisor_level_prepare)` + HOOKS `supervisor_level` | supervisor_level | /supervisor-level | rep, top-level, level | PRD §2.4, SRS §2 FR4.12 |
| rep-area | sm_rep_area | `app/modules.py:566 ("rep-area")` | `app/hooks.py:1232 (rep_area_prepare)` + HOOKS `rep_area` | rep_area | /rep-area | rep, level | PRD §2.4, SRS §2 FR4.13 |
| visit-plan | sm_visit_plan | `app/modules.py:590 ("visit-plan")` | `app/hooks.py:1352 (visit_plan_prepare)` + HOOKS `visit_plan` | visit_plan | /visit-plan | rep, level | PRD §2.4, SRS §2 FR4.14 |
| client-visit-plan | sm_client_visit_plan | `app/modules.py:630 ("client-visit-plan")` | `app/hooks.py:1502 (client_visit_plan_prepare)` + HOOKS `client_visit_plan` | client_visit_plan | /client-visit-plan | outlet, level | PRD §2.4, SRS §2 FR4.15 |

ACL screens: `app/routers/acl_admin.py` (users/roles/permissions — include BEFORE crud router).
Engine: `app/routers/crud.py` (generic CRUD + Excel + `_access` gate). Sidebar/menu: `app/modules.py:677 (MODULE_ORDER)`.

## §3 Doc map (what to read for what; skip unless §4 sends you)
| Question | File | Last-sync |
|---|---|---|
| Business needs, BR1–BR20 rules | `docs/BRD.md` | 84e6d8b |
| Page journeys, acceptance criteria | `docs/PRD.md` | 14fd314 |
| Architecture, FR1–FR6, data model | `docs/SRS.md` | 14fd314 |
| How to run, route table | `README.md` | 14fd314 |
| Operator prompt templates | `prompts/PROMPTS.md` | 14fd314 |
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
