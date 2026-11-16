# SSMS Task Register

Single source for task state. Drained from `MY_WATCHER.txt` (the raw inbox).
Format: `- T-nnn | status | module | deps | prio | added | description`
Statuses: `ready` · `needs-verification` (claimed done — verify against code, close or reopen) · `clarify` (ambiguous — ask user) · `blocked` (waiting on deps) · `done`.

## IN_PROGRESS (max 1)
(none)

## OPEN
- T-002 | needs-verification | item | - | P1 | 2026-11-11 | ITEM sweep (from MY_WATCHER 2026-11-10): (a) list-page Brand filter from sm_item_hierarchy (brand_id—brand_name); (b) create uniqueness cid+item_id; (c) hierarchy-tagging dropdown keyup search; (d) edit auto-selects all stored values (status, item category, unit type, packsize, CG>BG>TG>FG); (e) float acceptance for weight/invoice price/price/VAT/total/mrp + price+VAT auto-calculates total_amount; (f) item status cascade to its batch rows. Verify each against code/PRD; implement what's missing.
- T-003 | needs-verification | item_batch | T-002 | P1 | 2026-11-11 | ITEM BATCH sweep: (a) create uniqueness cid+item_id+batch_id; (b) item_id searchable dropdown (active items only, "brand_name | item_id item_name"); (c) expiary_date form default 2100-12-31; (d) list-page Brand filter (same as T-002a).
- T-005 | clarify | core | - | P2 | 2026-11-11 | Sidebar active-state scoping (verbatim: "menu item-batch when active menu item and item-batch both are active but it should only item-batch same Distributor and distributor store as well") — interpretation: on /item-batch both Item and Item-Batch menu entries highlight; only the child should; same for Distributor/Distributor-Store. Confirm with user, then fix active-menu logic.
- T-006 | clarify | brand | - | P3 | 2026-11-11 | Brand delete-button visibility rule (verbatim: "delete button will be invisible if node has no child or leaf=0") — ambiguous: likely hide delete when the node HAS children (leaf=0). Confirm intent, then verify/implement.
- T-007 | ready | api | T-001 | P3 | 2026-11-11 | BACKLOG (not user-requested; from old brain): REST API module for the planned Flutter app (JWT or session tokens).
- T-008 | ready | category_type | - | P3 | 2026-11-11 | BACKLOG (not user-requested; from old brain): more category groups — approval_flag labels, town master.
- T-009 | ready | core | - | P3 | 2026-11-11 | BACKLOG (not user-requested; from old brain): test suite (pytest + httpx) once API surface grows — would also mechanize the verify loop.

## DONE (append-only; one line each: id-free entries use date | commit | scope | result)
- T-013 | done | national_structure | - | P1 | 2026-11-14 | Fieldforce National Structure (sm_top_level): 4-tier hierarchy National(H) > Area(A) > Zone(Z) > Territory(T) with auto-incremental level_id, max depth 3 (Territory), path columns level0..level3, is_leaf recomputation, and central audit logging (verified live V-006).
- T-014 | done | field_structure | T-013 | P1 | 2026-11-14 | Fieldforce Field Structure (sm_level): 4-tier hierarchy Territory(T) > Town(TW) > Route(R) > Beat(B) with auto-incremental level_id, depth 0 Territory sourced from sm_top_level depth 3 suggestions, max depth 3 (Beat), and central audit logging (verified live V-006).
- T-015 | done | employee | - | P1 | 2026-11-14 | Fieldforce Employee Master (sm_rep): cid+rep_id unique, immutable auto-generated rep_id based on dynamic sm_category_type designation prefix (HOS, SOM, ASM, ASE, CE, PSR, DM), dual user types [rep, sup], and central audit logging (verified live V-006).
- T-016 | done | supervisor_area | T-013,T-014,T-015 | P1 | 2026-11-14 | Supervisor Area Assignment (sm_supervisor_level): links supervisor reps (user_type='sup') to any hierarchy node across National (sm_top_level) or Field (sm_level) structures at any depth tier, with central audit logging (verified live V-006).
- T-017 | done | psr_area | T-014,T-015 | P1 | 2026-11-14 | PSR Area Assignment & Cascading Beat Auto-Population (sm_rep_area): links PSR reps (user_type='rep') to Route (sm_level depth 2); on save automatically associates all active Beats under that Route and generates corresponding visit planning rows in sm_visit_plan (verified live V-006).
- T-018 | done | psr_visit_plan | T-017 | P1 | 2026-11-14 | PSR Visit Plan (sm_visit_plan): extended scheduling mapping Beat to order collection weekday (order_col_day) and auto-deriving next-day delivery (delivery_day), with central audit logging (verified live V-006).
- T-019 | done | outlet_visit_plan | T-017 | P1 | 2026-11-14 | Outlet Exceptional Visit Plan (sm_client_visit_plan): exceptional outlet visit planning mapping client_id, area_id, frequency, week plan flags (w1..w5), and day schedule (sat..fri), with central audit logging (verified live V-006).
- T-012 | done | all | - | P1 | 2026-11-13 | Dynamic dropdowns sweep: (a) hierarchy cascade searchable select un-occluded open on focus/click; (b) sequential cascade hydration on item edit; (c) ID | Name option format across dynamic dropdowns (V-005)
- T-010 | done | ui | - | P2 | 2026-11-13 | Compact list-page layout: minimal cell padding (5px 8px), card headers, margins, and search bar (verified live V-004)
- T-011 | done | ui | - | P2 | 2026-11-13 | List-page search filter column multi-select and type-to-search for filter dropdowns (verified live V-004)
- T-004 | done | all | - | P2 | 2026-11-13 | Download data button on all list pages (filtered visible page data; hierarchy-based Excel for hierarchy-synced modules)
- T-001 | done | outlet | - | P0 | 2026-11-13 | outlet docs backfill (PRD §2.4, SRS §2 FR4.8, BRD, README, PROMPTS, INDEX, Resume synced)
- 2026-11-05 | fb0e803 | v1.0.0 core | login, dashboard, 6 master modules (brand/item/item-batch/distributor/depot-store/category-type) create/view/edit/soft-delete/Excel, ACL admin, audit log — verified (V-001)
- 2026-11-09 | af89df6..8b10af5 | brand UX | type-to-search parent picker, image upload+preview+replace, child-levels card, tree list with per-level accordion, is_leaf invariant (BR2) — verified (V-002)
- 2026-11-10 | 7279a94,e33f355 | outlet code | sm_client registry + outlet_prepare hook + outlet.* perms + DISTRIBUTOR_CATEGORY seed rename; docs NOT synced at the time (→ T-001)
- meta | - | intake rules | "update docs accordingly" and "load into skills" instructions are standing policy — now AGENTS.md rules 6-8 + session protocol, not per-task items
