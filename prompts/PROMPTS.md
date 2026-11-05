# Prompts — SSMS

Prompt templates an operator or agent can reuse against the running SSMS application.

## 1. Daily operations check
> Verify SSMS health: confirm the server answers 200 on `/`, `/brand`, `/item`, `/item-batch`,
> `/distributor`, `/distributor-store`, `/category-type`, `/users`, `/roles`, `/permissions`,
> `/audit-log` after logging in with admin credentials. Report any non-200 response and the
> new `sm_audit_log` rows since the last check.

## 2. Create a hierarchy branch
> In the Item Info → Brand module, create Brand `BGn "<name>"` under Company and a Type/Flavor
> under it through the UI/API. Confirm the auto-generated level codes continue the existing
> sequence, the parent flips `is_leaf` to 0, path columns (`level0..level3`) are filled, and one
> CREATE row per level appears in the audit log.

## 3. Onboard a distributor
> Create distributor `<depot_id>` named `<name>` (category DISTRIBUTOR). Confirm default stores
> `<depot_id>140` (Commercial) and `<depot_id>170` (Damage) were auto-created with status ACTIVE,
> and audit rows exist for both `sm_depot` and `sm_depot_store` CREATE actions.

## 4. Excel batch import
> Download the `<module>` template from `/<module>/template`, fill N rows, upload at
> `/<module>/upload`. Report created/failed counts, list any row errors verbatim, and verify
> each created row in the DB. Never import rows that violate module uniqueness rules — expect
> the server to reject them and check the error report matches.

## 5. Role provisioning
> Create role `<ROLE_ID>` with permissions `<module>.view/create/…`, assign user `<user_id>` to
> it. Log in as that user and confirm: permitted journeys open, everything else is blocked with
> the "no permission" flash, and the changes appear in the audit log.

## 6. Master change audit
> For the last change on table `<table>` / record `<key>`, show old vs new values from
> `sm_audit_log` in a diff table, including who changed it, IP and timestamp.

## 7. Extension (when asked to add a module)
> Add master module `<name>` using the existing engine only: registry entry in `app/modules.py`,
> hooks in `app/hooks.py`, DDL in `scripts/ddl.sql` (with `status`), permission seeds, ACE-style
> route selection (acl_admin before crud), doc updates per AGENTS.md §Adding a new master module.
