# SSMS Task Register

Single source for task state. Drained from `MY_WATCHER.txt` (the raw inbox).
Format: `- T-nnn | status | module | deps | prio | added | description`
Statuses: `ready` · `needs-verification` (claimed done — verify against code, close or reopen) · `clarify` (ambiguous — ask user) · `blocked` (waiting on deps) · `done`.

## IN_PROGRESS (max 1)
(none)

## OPEN
(none)

## DONE (append-only; one line each: id-free entries use date | commit | scope | result)
- T-040 | done | supervisor-level | - | P1 | 2026-11-17 | Supervisor Area Hierarchy Tier Filter & searchable dropdown on create/edit and unified level_depth_no calculation (V-021, D-035)
- T-039 | done | rep | T-038 | P1 | 2026-11-17 | Employee create rep_id hidden and rep_username unique on (cid, rep_username) added across form, list, hooks, ddl, and DB (V-020, D-034)
- T-038 | done | rep | T-037 | P1 | 2026-11-17 | Employee dob and doj non-mandatory across create, edit, and Excel import (V-019, D-033)
- T-037 | done | rep | T-036 | P1 | 2026-11-17 | Employee form non-editable rep_id (readonly on create & edit with styling and auto-generation) and field reorder placing Distributor and Photo before Note
- T-036 | done | rep | - | P1 | 2026-11-17 | Refine Employee Master: rename to Employee(rep/sup/dm), EMP_USER_TYPE category type (29->32), rep_id auto-generation & nullable for integration, user_type -> designation cascading dropdown, dob/doj required, md5 password hashing, image_path upload, form rearrangement & doc sync
