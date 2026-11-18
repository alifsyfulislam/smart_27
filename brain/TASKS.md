# SSMS Task Register

Single source for task state. Drained from `MY_WATCHER.txt` (the raw inbox).
Format: `- T-nnn | status | module | deps | prio | added | description`
Statuses: `ready` · `needs-verification` (claimed done — verify against code, close or reopen) · `clarify` (ambiguous — ask user) · `blocked` (waiting on deps) · `done`.

## IN_PROGRESS (max 1)
(none)

## OPEN
(none)

## DONE (append-only; one line each: id-free entries use date | commit | scope | result)
- T-051 | done | outlet, client-visit-plan | - | P1 | 2026-11-18 | Add "All Beat" and "All Distributor" dropdown filters to /outlet and /client-visit-plan list views (V-032, D-046)
- T-050 | done | outlet, level | - | P1 | 2026-11-18 | Outlet ID form behavior alignment (hide on create, readonly on edit with tabindex -1), Beat distributor validation, auto-record depot and default commercial store, level depot select enable on depths 1-3 (V-031, D-045)
- T-049 | done | visit-plan, rep-area | - | P1 | 2026-11-18 | Aligned Representative input with Delivery Man (searchable single-select, placeholder, -- Select Representative --, active PSR/rep query) (V-030, D-044)
- T-048 | done | client-visit-plan | - | P1 | 2026-11-18 | Outlet Visit Plan form reordering (Area first with Route filter), dynamic Beat-to-Outlet cascading with count badge, and FREQUENCY_TYPE category-type sourcing (V-029, D-043)
- T-047 | done | outlet | - | P1 | 2026-11-18 | Outlet form refinement: auto-incrementing numeric client_id >= 1000001 (hidden on create, readonly on edit), Beat selector with Route filter, image_path upload, removed depot/store/old_id (V-028, D-042)
- T-046 | done | depot-stock-balance, depot-rack-stock-balance | - | P1 | 2026-11-18 | Rename Distributor Stock to Item Stock + add All Distributor Store filter; Rename Distributor Rack Stock to Rack Stock + add All Rack filter (V-027, D-041)
- T-045 | done | depot-rack-stock-balance | - | P1 | 2026-11-18 | Distributor Rack Stock: read-only distributor rack inventory balance & tracking master module sm_depot_rack_stock_balance (no_create, no_edit, no_delete, no_import; perm depot_rack_stock_balance.view, 80->81 seeded perms) under Distributor Info (V-026, D-040)
- T-044 | done | level, rep, visit-plan | - | P1 | 2026-11-18 | Field Structure: remove Distributor in Town form; Employee: rename title to Employee and remove Distributor from form; PSR Visit Plan: remove Distributor from form (V-025, D-039)
- T-043 | done | depot-stock-balance, item, item-batch, distributor, distributor-store | - | P1 | 2026-11-18 | Auto-provision sm_depot_stock_balance (qty=0, block_qty=0) on 4 triggers (item, batch, depot, store); remove create permission (81->80 seeded perms); add All Item filter on list (V-024, D-038)
- T-042 | done | visit-plan, supervisor-level, item-batch, distributor | - | P1 | 2026-11-18 | Distributor option and WEEK_DAYS order collection day in visit-plan; auto-calculated delivery day (Thu/Fri->Sat); custom search placeholders; removed order day filter; redundant fields hidden in item-batch (Name) and distributor (Town ID); label renamed to Town (V-023, D-037)
- T-041 | done | visit-plan | - | P1 | 2026-11-18 | PSR Visit Plan Route/Beat hierarchy tier filter, sidebar consolidation (hiding rep-area), and full lifecycle auto-synchronization to sm_rep_area (V-022, D-036)
- T-040 | done | supervisor-level | - | P1 | 2026-11-17 | Supervisor Area Hierarchy Tier Filter & searchable dropdown on create/edit and unified level_depth_no calculation (V-021, D-035)
- T-039 | done | rep | T-038 | P1 | 2026-11-17 | Employee create rep_id hidden and rep_username unique on (cid, rep_username) added across form, list, hooks, ddl, and DB (V-020, D-034)
- T-038 | done | rep | T-037 | P1 | 2026-11-17 | Employee dob and doj non-mandatory across create, edit, and Excel import (V-019, D-033)
- T-037 | done | rep | T-036 | P1 | 2026-11-17 | Employee form non-editable rep_id (readonly on create & edit with styling and auto-generation) and field reorder placing Distributor and Photo before Note
- T-036 | done | rep | - | P1 | 2026-11-17 | Refine Employee Master: rename to Employee(rep/sup/dm), EMP_USER_TYPE category type (29->32), rep_id auto-generation & nullable for integration, user_type -> designation cascading dropdown, dob/doj required, md5 password hashing, image_path upload, form rearrangement & doc sync

