# SSMS Project Brain — pointer file

Living memory for anyone (human or agent) picking up this project. This file only routes;
content lives in its one home. **Session start: read `brain/INDEX.md` + `brain/STATUS.md`.**

| Want… | Go to |
|---|---|
| Comprehensive SSOT / Session Resumption Guide | `Resume.md` |
| Current state, verified counts, run line | `brain/STATUS.md` |
| Why something is the way it is (all decisions, dated) | `brain/DECISIONS.md` (append-only) |
| What was verified, when, with what result | `brain/VERIFICATION_LOG.md` (append-only) |
| Open tasks / backlog / handover | `brain/TASKS.md` |
| Fact → single source of truth; module map; loading rules | `brain/INDEX.md` |
| Working conventions, run/verify loop, pitfalls/gotchas | `.agents/skills/ssms/SKILL.md` |
| Business needs (BR rules) | `docs/BRD.md` |
| Page journeys, acceptance criteria | `docs/PRD.md` |
| Architecture, FRs, data model | `docs/SRS.md` |
| How to run / route table | `README.md` |
| Operator prompt templates | `prompts/PROMPTS.md` |

## Where things live (code & schema)
- Business rules: `app/hooks.py` (codes `LEVEL_PREFIX`, default batch/stores, cascades; registry `HOOKS`).
- Column/UI definitions: `app/modules.py` (`MODULES`, `MODULE_ORDER`, `PERM2SLUG`).
- Generic engine: `app/routers/crud.py`; ACL screens: `app/routers/acl_admin.py`; audit writer: `app/audit.py`.
- Schema: `scripts/ddl.sql` (header = schema change-log); seed: `scripts/setup_database.py`.
- Raw intake: `MY_WATCHER.txt` (inbox) → drained into `brain/TASKS.md`; raw history in `brain/archive/`.
