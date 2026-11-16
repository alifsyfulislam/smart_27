# SSMS Task Register

Single source for task state. Drained from `MY_WATCHER.txt` (the raw inbox).
Format: `- T-nnn | status | module | deps | prio | added | description`
Statuses: `ready` · `needs-verification` (claimed done — verify against code, close or reopen) · `clarify` (ambiguous — ask user) · `blocked` (waiting on deps) · `done`.

## IN_PROGRESS (max 1)
(none)

## OPEN
(none)


## DONE (append-only; one line each: id-free entries use date | commit | scope | result)
- T-024 | done | level | - | P1 | 2026-11-16 | Field Structure territory sync from sm_top_level depth 3 + town-level distributor tagging and route/beat auto-cascade (V-010, D-019).
- T-023 | done | item | - | P1 | 2026-11-16 | Item image upload: replicate Brand image upload pattern for sm_item.image_path on /item/create and /item/edit/{id}, guard against '-' defaults in form.html, and update docs (V-009, D-018).
