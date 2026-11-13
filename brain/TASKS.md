# SSMS Task Register

Single source for task state. Drained from `MY_WATCHER.txt` (the raw inbox).
Format: `- T-nnn | status | module | deps | prio | added | description`
Statuses: `ready` · `needs-verification` (claimed done — verify against code, close or reopen) · `clarify` (ambiguous — ask user) · `blocked` (waiting on deps) · `done`.

## IN_PROGRESS (max 1)
- *(none — handover block template: last commit · done this session · next concrete steps · open questions)*

## OPEN
- T-002 | needs-verification | item | - | P1 | 2026-11-11 | ITEM sweep (from MY_WATCHER 2026-11-10): (a) list-page Brand filter from sm_item_hierarchy (brand_id—brand_name); (b) create uniqueness cid+item_id; (c) hierarchy-tagging dropdown keyup search; (d) edit auto-selects all stored values (status, item category, unit type, packsize, CG>BG>TG>FG); (e) float acceptance for weight/invoice price/price/VAT/total/mrp + price+VAT auto-calculates total_amount; (f) item status cascade to its batch rows. Verify each against code/PRD; implement what's missing.
- T-003 | needs-verification | item_batch | T-002 | P1 | 2026-11-11 | ITEM BATCH sweep: (a) create uniqueness cid+item_id+batch_id; (b) item_id searchable dropdown (active items only, "brand_name | item_id item_name"); (c) expiary_date form default 2100-12-31; (d) list-page Brand filter (same as T-002a).
- T-004 | needs-verification | all | - | P2 | 2026-11-11 | Download buttons: template download button on every module list page; hierarchy modules download a hierarchy-based template, others the normal one. Template routes exist (FR3.7) — verify button presence/mode per module.
- T-005 | clarify | core | - | P2 | 2026-11-11 | Sidebar active-state scoping (verbatim: "menu item-batch when active menu item and item-batch both are active but it should only item-batch same Distributor and distributor store as well") — interpretation: on /item-batch both Item and Item-Batch menu entries highlight; only the child should; same for Distributor/Distributor-Store. Confirm with user, then fix active-menu logic.
- T-006 | clarify | brand | - | P3 | 2026-11-11 | Brand delete-button visibility rule (verbatim: "delete button will be invisible if node has no child or leaf=0") — ambiguous: likely hide delete when the node HAS children (leaf=0). Confirm intent, then verify/implement.
- T-007 | ready | api | T-001 | P3 | 2026-11-11 | BACKLOG (not user-requested; from old brain): REST API module for the planned Flutter app (JWT or session tokens).
- T-008 | ready | category_type | - | P3 | 2026-11-11 | BACKLOG (not user-requested; from old brain): more category groups — approval_flag labels, town master.
- T-009 | ready | core | - | P3 | 2026-11-11 | BACKLOG (not user-requested; from old brain): test suite (pytest + httpx) once API surface grows — would also mechanize the verify loop.

## DONE (append-only; one line each: id-free entries use date | commit | scope | result)
- T-001 | done | outlet | - | P0 | 2026-11-13 | outlet docs backfill (PRD §2.4, SRS §2 FR4.8, BRD, README, PROMPTS, INDEX, Resume synced)
- 2026-11-05 | fb0e803 | v1.0.0 core | login, dashboard, 6 master modules (brand/item/item-batch/distributor/depot-store/category-type) create/view/edit/soft-delete/Excel, ACL admin, audit log — verified (V-001)
- 2026-11-09 | af89df6..8b10af5 | brand UX | type-to-search parent picker, image upload+preview+replace, child-levels card, tree list with per-level accordion, is_leaf invariant (BR2) — verified (V-002)
- 2026-11-10 | 7279a94,e33f355 | outlet code | sm_client registry + outlet_prepare hook + outlet.* perms + DISTRIBUTOR_CATEGORY seed rename; docs NOT synced at the time (→ T-001)
- meta | - | intake rules | "update docs accordingly" and "load into skills" instructions are standing policy — now AGENTS.md rules 6-8 + session protocol, not per-task items
