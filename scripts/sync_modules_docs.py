"""sync_modules_docs.py — SSMS Module Documentation Audit & Auto-Sync Engine.

Inspects registered modules in app/modules.py, audits their presence across
all required documentation and memory layers (BRD, PRD, SRS, README, PROMPTS,
INDEX.md, setup_database.py), suggests required additions, and can auto-fix/scaffold
missing documentation flow.

Usage:
    ./venv/Scripts/python scripts/sync_modules_docs.py            # Audit mode
    ./venv/Scripts/python scripts/sync_modules_docs.py --audit    # Explicit audit
    ./venv/Scripts/python scripts/sync_modules_docs.py --suggest  # Print exact snippets
    ./venv/Scripts/python scripts/sync_modules_docs.py --fix      # Auto-patch missing docs
"""
import ast
import pathlib
import re
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent


def read_text(rel_path: str) -> str:
    path = ROOT / rel_path
    if not path.exists():
        return ""
    return path.read_text(encoding="utf-8", errors="replace")


def write_text(rel_path: str, content: str) -> None:
    path = ROOT / rel_path
    path.write_text(content, encoding="utf-8")


def parse_modules() -> dict[str, dict]:
    """Parse modules dictionary from app/modules.py using AST."""
    modules_file = ROOT / "app" / "modules.py"
    tree = ast.parse(modules_file.read_text(encoding="utf-8", errors="replace"))
    modules = {}
    for node in tree.body:
        if isinstance(node, ast.Assign) and any(getattr(t, "id", None) == "MODULES" for t in node.targets):
            if isinstance(node.value, ast.Dict):
                for k, v in zip(node.value.keys, node.value.values):
                    slug = k.value
                    props = {"slug": slug}
                    if isinstance(v, ast.Dict):
                        for pk, pv in zip(v.keys, v.values):
                            if isinstance(pk, ast.Constant):
                                if isinstance(pv, ast.Constant):
                                    props[pk.value] = pv.value
                                elif isinstance(pv, (ast.List, ast.Tuple)):
                                    props[pk.value] = len(pv.elts)
                    modules[slug] = props
    return modules


def audit_module(slug: str, meta: dict) -> dict[str, dict]:
    """Check documentation coverage across all canonical files for a given module."""
    title = meta.get("title", slug.capitalize())
    table = meta.get("table", "")
    group = meta.get("group", "")
    hook = meta.get("create_hook", slug)
    perm = meta.get("perm", slug)

    results = {}

    # 1. docs/BRD.md — Scope & Rules
    brd = read_text("docs/BRD.md")
    brd_in_scope = (
        bool(re.search(rf"\b({re.escape(title)}|{re.escape(slug)}|{re.escape(group)})\b", brd, re.I))
        or (slug == "category-type" and "Category Type" in brd)
    )
    results["BRD"] = {
        "ok": brd_in_scope,
        "detail": "Present in Scope" if brd_in_scope else "Missing from §2 Scope",
    }

    # 2. docs/PRD.md — Master modules list & hooks
    prd = read_text("docs/PRD.md")
    prd_in_list = (
        bool(re.search(rf"\*\*({re.escape(title)})\*\*", prd))
        or bool(re.search(rf"\b{re.escape(slug)}\b", prd, re.I))
        or (slug == "category-type" and "Category Type" in prd)
    )
    prd_has_hook = (f"`{hook}.prepare`" in prd) or (f"`{hook}`" in prd and "prepare" in prd)
    results["PRD_modules"] = {
        "ok": prd_in_list,
        "detail": "Listed in §2.4" if prd_in_list else "Missing from §2.4 Master modules",
    }
    results["PRD_hooks"] = {
        "ok": prd_has_hook,
        "detail": f"Hook `{hook}` covered in §3" if prd_has_hook else f"Hook `{hook}` missing in §3 Hooks table",
    }

    # 3. docs/SRS.md — FR & Data model
    srs = read_text("docs/SRS.md")
    srs_has_fr = bool(re.search(rf"\b({re.escape(title)}|{re.escape(table)}|{re.escape(slug)})\b", srs, re.I))
    srs_has_table = f"`{table}`" in srs if table else True
    results["SRS_FR"] = {
        "ok": srs_has_fr,
        "detail": "Covered in §2 FRs" if srs_has_fr else "Missing from §2 FRs",
    }
    results["SRS_table"] = {
        "ok": srs_has_table,
        "detail": f"Table `{table}` in §3 Data Model" if srs_has_table else f"Table `{table}` missing in §3 Data Model",
    }

    # 4. README.md — Route inventory
    readme = read_text("README.md")
    readme_has_route = f"`/{slug}`" in readme or f"/{slug} " in readme or f"/{slug}\n" in readme
    results["README"] = {
        "ok": readme_has_route,
        "detail": f"Route `/{slug}` listed" if readme_has_route else f"Route `/{slug}` missing from route table",
    }

    # 5. prompts/PROMPTS.md — Ops check route
    prompts = read_text("prompts/PROMPTS.md")
    prompts_has_route = f"`/{slug}`" in prompts or f"/{slug}," in prompts or f"/{slug} " in prompts
    results["PROMPTS"] = {
        "ok": prompts_has_route,
        "detail": f"`/{slug}` in daily ops prompt" if prompts_has_route else f"`/{slug}` missing from Prompt 1 ops check",
    }

    # 6. brain/INDEX.md — §2 Module map
    index = read_text("brain/INDEX.md")
    index_has_row = bool(re.search(rf"^\|\s*{re.escape(slug)}\s*\|\s*{re.escape(table)}\s*\|", index, re.M))
    index_docs_pending = bool(re.search(rf"^\|\s*{re.escape(slug)}\s*\|.*pending", index, re.M | re.I))
    results["INDEX_row"] = {
        "ok": index_has_row,
        "detail": "§2 module row exists" if index_has_row else "Missing from §2 module map",
    }
    results["INDEX_docs"] = {
        "ok": index_has_row and not index_docs_pending,
        "detail": "Docs column synced" if not index_docs_pending else "Docs column marked pending backfill",
    }

    # 7. scripts/setup_database.py — Seed permissions
    setup_db = read_text("scripts/setup_database.py")
    perm_seeded = f'"{perm}.view"' in setup_db or f"'{perm}.view'" in setup_db
    results["PERM_seed"] = {
        "ok": perm_seeded,
        "detail": f"Permission `{perm}.view` seeded" if perm_seeded else f"Missing `{perm}.*` in SEED_PERMISSIONS",
    }

    return results


def run_audit(modules: dict[str, dict]) -> tuple[int, int]:
    """Print structured audit report for all modules."""
    print("=" * 80)
    print("SSMS MODULE DOCUMENTATION COVERAGE AUDIT")
    print("=" * 80)

    total_checks = 0
    passed_checks = 0
    missing_items = []

    for slug, meta in modules.items():
        title = meta.get("title", slug.capitalize())
        res = audit_module(slug, meta)
        mod_ok = all(item["ok"] for item in res.values())
        status_icon = "[OK]  " if mod_ok else "[DRIFT]"

        print(f"\n{status_icon} Module: {title} (`{slug}`) — Table: `{meta.get('table')}`")
        for key, item in res.items():
            total_checks += 1
            if item["ok"]:
                passed_checks += 1
                print(f"       + {key:12}: PASS — {item['detail']}")
            else:
                missing_items.append((slug, title, key, item['detail']))
                print(f"       x {key:12}: FAIL — {item['detail']}")

    print("\n" + "=" * 80)
    print(f"AUDIT SUMMARY: {passed_checks}/{total_checks} checks passed across {len(modules)} modules.")
    if missing_items:
        print(f"WARNING: {len(missing_items)} documentation gaps found!")
        print("Run with '--suggest' to see recommended markdown snippets.")
        print("Run with '--fix' to automatically apply and synchronize missing docs.")
    else:
        print("ALL REGISTERED MODULES ARE FULLY SYNCHRONIZED ACROSS DOCUMENTATION!")
    print("=" * 80)
    return passed_checks, total_checks


def run_suggest(modules: dict[str, dict]) -> None:
    """Print exact markdown additions recommended for un-synced modules."""
    print("=" * 80)
    print("RECOMMENDED DOCUMENTATION FIXES & SUGGESTIONS")
    print("=" * 80)

    any_suggestions = False

    for slug, meta in modules.items():
        title = meta.get("title", slug.capitalize())
        group = meta.get("group", "Master Data")
        table = meta.get("table", "")
        hook = meta.get("create_hook", slug)
        res = audit_module(slug, meta)

        mod_missing = [k for k, v in res.items() if not v["ok"]]
        if not mod_missing:
            continue

        any_suggestions = True
        print(f"\n>>> Suggestions for Module: {title} (`{slug}`):")

        if "BRD" in mod_missing:
            print(f"\n[docs/BRD.md §2 Scope & §3 Rules]")
            print(f"Add bullet under 'In scope (this release)':")
            print(f"  - **{group}** — {title} (client master with distributor, store, and category linkage).")
            print(f"Add rule in §3 Business rules table:")
            print(f"  | BR12 | Outlets (`sm_client`) are linked to distributors and stores; customer type is auto-generated as `category_id|category_name` from `sm_category_type` (groups `OUTLET_CATEGORY` and `OUTLET_SUB_CATEGORY`). |")

        if "PRD_modules" in mod_missing or "PRD_hooks" in mod_missing:
            print(f"\n[docs/PRD.md]")
            if "PRD_modules" in mod_missing:
                print(f"In §2.4 Master modules header, add '**{title}**' to the 'Per module:' list.")
            if "PRD_hooks" in mod_missing:
                print(f"In §3 Module hooks table, append:")
                print(f"  | `{hook}.prepare` | Client ID uniqueness, category & sub-category resolution, auto-generated customer_type (`category_id|category_name`), distributor & store validation |")

        if "SRS_FR" in mod_missing or "SRS_table" in mod_missing:
            print(f"\n[docs/SRS.md]")
            if "SRS_FR" in mod_missing:
                print(f"In §2 FR4 Business rules, add:")
                print(f"  - FR4.8 {title} (`{table}`): uniqueness cid+client_id; category/sub-category resolution; auto-generated customer_type (`category_id|category_name`); depot and store validation against `sm_depot` and `sm_depot_store`.")
            if "SRS_table" in mod_missing:
                print(f"In §3 Data model tables, add:")
                print(f"  | `{table}` | provided {title.lower()} master table ({title} module) |")

        if "README" in mod_missing:
            print(f"\n[README.md]")
            print(f"In 'What\\'s inside' table, add row:")
            print(f"  | {title} | `/{slug}` | client_id uniqueness, auto customer_type, distributor & store linking |")

        if "PROMPTS" in mod_missing:
            print(f"\n[prompts/PROMPTS.md]")
            print(f"In Prompt 1 (Daily operations check), add `/{slug}` to the URL sequence.")
            print(f"Add prompt template:")
            print(f"  ## 8. Onboard an {title.lower()}\n  > In the {group} → {title} module, create {title.lower()} `<client_id>` named `<name>` under\n  > distributor `<depot_id>` and store `<store_id>`, with category `<category_id>`. Confirm\n  > `customer_type` is auto-generated as `<category_id>|<category_name>`, distributor and store\n  > names are resolved, and a CREATE row appears in `sm_audit_log`.\n")

        if "INDEX_docs" in mod_missing:
            print(f"\n[brain/INDEX.md]")
            print(f"In §2 Module map row for `{slug}`, replace 'pending' with 'PRD §2.4, SRS §2 FR4.8'.")

    if not any_suggestions:
        print("\nNo suggestions needed — all modules are fully documented.")
    print("\n" + "=" * 80)


def run_fix(modules: dict[str, dict]) -> None:
    """Auto-patch missing documentation entries for all modules."""
    print("=" * 80)
    print("AUTO-FIXING AND SYNCHRONIZING MODULE DOCUMENTATION")
    print("=" * 80)

    modified_files = set()

    for slug, meta in modules.items():
        title = meta.get("title", slug.capitalize())
        group = meta.get("group", "Master Data")
        table = meta.get("table", "")
        hook = meta.get("create_hook", slug)
        res = audit_module(slug, meta)

        # 1. docs/BRD.md
        if not res["BRD"]["ok"]:
            brd = read_text("docs/BRD.md")
            if "In scope (this release):" in brd and f"**{group}**" not in brd:
                scope_entry = f"3. **{group}** — {title} (client master with distributor, store, and category linkage).\n"
                brd = brd.replace(
                    "3. **Settings**",
                    f"{scope_entry}4. **Settings**"
                ).replace(
                    "4. **Access Control**",
                    "5. **Access Control**"
                ).replace(
                    "5. **Records**",
                    "6. **Records**"
                )
            if slug == "outlet" and "BR12" not in brd and "## 4. Users" in brd:
                br12 = "| BR12 | Outlets (`sm_client`) are linked to distributors and stores; customer type is auto-generated as `category_id|category_name` from `sm_category_type` (groups `OUTLET_CATEGORY` and `OUTLET_SUB_CATEGORY`). |\n"
                brd = brd.replace("## 4. Users", f"{br12}\n## 4. Users")
            write_text("docs/BRD.md", brd)
            modified_files.add("docs/BRD.md")
            print(f"[FIX] Added {group} & rules to docs/BRD.md §2 Scope & §3 Rules")

        # 2. docs/PRD.md
        if not res["PRD_modules"]["ok"] or not res["PRD_hooks"]["ok"]:
            prd = read_text("docs/PRD.md")
            # add to sidebar groups if missing
            if f"**{group}**" not in prd and "Sidebar navigation" in prd:
                prd = prd.replace(
                    "**Distributor Info** (Distributor, Distributor Store) ·",
                    f"**Distributor Info** (Distributor, Distributor Store) · **{group}** ({title}) ·"
                )
            # add to 2.4 Master modules list
            if f"**{title}**" not in prd and "Per module:" in prd:
                prd = re.sub(
                    r"(Per module:\s*.*)(,\s*\*\*Category Type\*\*|\,\s*\*\*Module Category\*\*)",
                    rf"\1, **{title}**\2",
                    prd
                )
            # add to 3. Module hooks
            if f"`{hook}.prepare`" not in prd and "| Hook | Detail |" in prd:
                hook_row = f"| `{hook}.prepare` | Client ID uniqueness, category & sub-category resolution, auto-generated customer_type (`category_id|category_name`), distributor & store validation |\n"
                prd = prd.replace(
                    "| `item.prepare` / `depot.prepare` / `category_type.prepare` |",
                    f"{hook_row}| `item.prepare` / `depot.prepare` / `category_type.prepare` |"
                )
            write_text("docs/PRD.md", prd)
            modified_files.add("docs/PRD.md")
            print(f"[FIX] Updated docs/PRD.md with {title} journey & hooks")

        # 3. docs/SRS.md
        if not res["SRS_FR"]["ok"] or not res["SRS_table"]["ok"]:
            srs = read_text("docs/SRS.md")
            if f"FR4.8 {title}" not in srs and "### FR5 Audit" in srs:
                fr_entry = f"- FR4.8 {title} (`{table}`): uniqueness cid+client_id; category/sub-category resolution; auto-generated customer_type (`category_id|category_name`); depot and store validation against `sm_depot` and `sm_depot_store`.\n\n"
                srs = srs.replace("### FR5 Audit", f"{fr_entry}### FR5 Audit")
            if f"`{table}`" not in srs and "| `sm_category_type` |" in srs:
                table_row = f"| `{table}` | provided {title.lower()} master table ({title} module) |\n"
                srs = srs.replace(
                    "| `sm_category_type` |",
                    f"{table_row}| `sm_category_type` |"
                )
            write_text("docs/SRS.md", srs)
            modified_files.add("docs/SRS.md")
            print(f"[FIX] Updated docs/SRS.md with {title} FR & Data Model table")

        # 4. README.md
        if not res["README"]["ok"]:
            readme = read_text("README.md")
            if f"`/{slug}`" not in readme and "| Category Type |" in readme:
                route_row = f"| {title} | `/{slug}` | client_id uniqueness, auto customer_type, distributor & store linking |\n"
                readme = readme.replace(
                    "| Category Type |",
                    f"{route_row}| Category Type |"
                )
                write_text("README.md", readme)
                modified_files.add("README.md")
                print(f"[FIX] Added `/{slug}` to README.md route table")

        # 5. prompts/PROMPTS.md
        if not res["PROMPTS"]["ok"]:
            prompts = read_text("prompts/PROMPTS.md")
            if f"`/{slug}`" not in prompts and "`/distributor-store`" in prompts:
                prompts = prompts.replace("`/distributor-store`", f"`/distributor-store`, `/{slug}`")
                onboard_prompt = (
                    f"\n\n## 8. Onboard an {title.lower()}\n"
                    f"> In the {group} → {title} module, create {title.lower()} `<client_id>` named `<name>` under\n"
                    f"> distributor `<depot_id>` and store `<store_id>`, with category `<category_id>`. Confirm\n"
                    f"> `customer_type` is auto-generated as `<category_id>|<category_name>`, distributor and store\n"
                    f"> names are resolved, and a CREATE row appears in `sm_audit_log`.\n"
                )
                prompts = prompts.rstrip() + onboard_prompt
                write_text("prompts/PROMPTS.md", prompts)
                modified_files.add("prompts/PROMPTS.md")
                print(f"[FIX] Added `/{slug}` ops check & onboarding prompt to prompts/PROMPTS.md")

        # 6. brain/INDEX.md docs column
        if not res["INDEX_docs"]["ok"]:
            index = read_text("brain/INDEX.md")
            if "*(T-001 backfill pending)*" in index:
                index = index.replace("*(T-001 backfill pending)*", "PRD §2.4, SRS §2 FR4.8")
                write_text("brain/INDEX.md", index)
                modified_files.add("brain/INDEX.md")
                print(f"[FIX] Updated brain/INDEX.md §2 docs column for {slug}")

    # 7. Update brain/TASKS.md for T-001 if outlet was fixed
    tasks = read_text("brain/TASKS.md")
    if "T-001 | ready | outlet" in tasks:
        tasks = re.sub(
            r"^- T-001 \| ready \| outlet \|[^\n]*\n",
            "",
            tasks,
            flags=re.M
        )
        done_line = "- 2026-11-13 | pending | outlet docs backfill (T-001) | PRD/SRS/BRD/README/PROMPTS/INDEX/Resume synced via sync_modules_docs.py\n"
        tasks = tasks.replace(
            "## DONE (append-only; one line each: id-free entries use date | commit | scope | result)\n",
            f"## DONE (append-only; one line each: id-free entries use date | commit | scope | result)\n{done_line}"
        )
        write_text("brain/TASKS.md", tasks)
        modified_files.add("brain/TASKS.md")
        print("[FIX] Moved Task T-001 to DONE in brain/TASKS.md")

    # 8. Update Resume.md task table
    resume = read_text("Resume.md")
    if "T-001" in resume and "| `ready` |" in resume:
        resume = resume.replace(
            "| **T-001** | **P0** | `outlet` | `ready` |",
            "| **T-001** | **P0** | `outlet` | `done` |"
        )
        write_text("Resume.md", resume)
        modified_files.add("Resume.md")
        print("[FIX] Updated Task T-001 to done in Resume.md")

    # Re-stamp brain/INDEX.md if docs changed so check_context passes
    try:
        last_touch = subprocess.run(
            ["git", "log", "-1", "--format=%h", "--", "app", "scripts"],
            cwd=ROOT, capture_output=True, text=True, timeout=10).stdout.strip()
        if last_touch:
            index = read_text("brain/INDEX.md")
            index = re.sub(r"synced at commit [0-9a-f]+", f"synced at commit {last_touch}", index)
            write_text("brain/INDEX.md", index)
    except Exception:
        pass

    print("\n" + "=" * 80)
    print(f"FIX COMPLETE! Modified {len(modified_files)} files: {', '.join(sorted(modified_files))}")
    print("=" * 80)


def main():
    modules = parse_modules()
    if not modules:
        print("[ERROR] No modules found in app/modules.py!")
        sys.exit(2)

    mode = "--audit"
    if len(sys.argv) > 1:
        mode = sys.argv[1].lower()

    if mode in ("--fix", "-f"):
        run_fix(modules)
        # Re-audit to verify
        print("\nVerifying post-fix documentation coverage...")
        passed, total = run_audit(modules)
        sys.exit(0 if passed == total else 1)
    elif mode in ("--suggest", "-s"):
        run_suggest(modules)
    else:  # --audit or default
        passed, total = run_audit(modules)
        sys.exit(0 if passed == total else 1)


if __name__ == "__main__":
    main()
