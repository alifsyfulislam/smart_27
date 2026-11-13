# SSMS Task Register

Single source for task state. Drained from `MY_WATCHER.txt` (the raw inbox).
Format: `- T-nnn | status | module | deps | prio | added | description`
Statuses: `ready` · `needs-verification` (claimed done — verify against code, close or reopen) · `clarify` (ambiguous — ask user) · `blocked` (waiting on deps) · `done`.

## IN_PROGRESS (max 1)
(none)

## OPEN


## DONE (append-only; one line each: id-free entries use date | commit | scope | result)

