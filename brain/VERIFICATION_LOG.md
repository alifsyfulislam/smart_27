# SSMS Verification Log (append-only)

One entry per verification pass. Format: `V-nnn | date | commit | scope | checks | result`.
Never edit old entries.

- **V-001** · 2026-11-05 · fb0e803 · v1.0.0 end-to-end · Login 303→dashboard 200; all module lists 200; brand create → FG003; item create → default batch; depot create → 2 default stores; template download+upload import; soft delete/restore; audit rows CREATE/DELETE/RESTORE/LOGIN; VIEWER restrictions; /users /roles /permissions 200 · **PASS** (details: docs/SRS.md §5)
- **V-002** · 2026-11-09 · 8b10af5 · brand UX re-verification · leaf invariant through full lifecycle; tree accordion behavior; image upload/replace + extension rejection; add-many children dedupe; default batch/stores; Excel round-trip; VIEWER blocked · **PASS** (details: docs/PRD.md §5)
