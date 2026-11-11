"""check_context.py — SSMS context-consistency gate (stdlib only, read-only).

Validates that the knowledge layer (AGENTS.md, brain/*, docs/*, SKILL, README,
prompts) agrees with code truth and with itself. Run before every commit:

    ./venv/Scripts/python scripts/check_context.py

Exit codes: 0 = clean, 1 = drift (fix flagged rows), 2 = structural error.
"""
import ast
import pathlib
import re
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent

# ---- the doc/instruction layer that the phrase scan guards -------------------
SCAN_FILES = [
    "AGENTS.md", "README.md",
    "docs/BRD.md", "docs/PRD.md", "docs/SRS.md",
    "brain/INDEX.md", "brain/STATUS.md", "brain/PROJECT_BRAIN.md", "brain/TASKS.md",
    ".agents/skills/ssms/SKILL.md", "prompts/PROMPTS.md",
]
# history/intake/code layers are exempt (they may legitimately quote old facts)
EXEMPT_PREFIXES = ("brain/archive/",)

# phrase -> files allowed to contain it (within SCAN_FILES); empty set = banned everywhere
PHRASE_HOMES = {
    "2100-12-31": {"brain/INDEX.md", "docs/BRD.md"},
    "{depot_id}140": {"brain/INDEX.md"},
    "MG/BG/CG/FG": {"brain/INDEX.md"},
    "CG/BG/TG/FG": set(),          # the conflicting spelling is banned outright
    "expiary_date": {"AGENTS.md", ".agents/skills/ssms/SKILL.md", "brain/INDEX.md"},
    "admin123": {"AGENTS.md", "README.md"},
    "#1877f2": {"docs/PRD.md"},
}

failures: list[str] = []
passed = 0


def ok(msg: str) -> None:
    global passed
    passed += 1
    print(f"[PASS] {msg}")


def fail(msg: str) -> None:
    failures.append(msg)
    print(f"[FAIL] {msg}")


def read(rel: str) -> str:
    return (ROOT / rel).read_text(encoding="utf-8", errors="replace")


def top_dict_keys(path: pathlib.Path, var: str) -> list[str]:
    """Return the keys of a module-level dict literal via AST (no import side effects)."""
    tree = ast.parse(path.read_text(encoding="utf-8", errors="replace"))
    for node in tree.body:
        if isinstance(node, ast.Assign) and any(getattr(t, "id", None) == var for t in node.targets):
            if isinstance(node.value, ast.Dict):
                return [k.value for k in node.value.keys if isinstance(k, ast.Constant)]
    return []


def top_dict(path: pathlib.Path, var: str) -> dict:
    tree = ast.parse(path.read_text(encoding="utf-8", errors="replace"))
    for node in tree.body:
        if isinstance(node, ast.Assign) and any(getattr(t, "id", None) == var for t in node.targets):
            if isinstance(node.value, ast.Dict):
                out = {}
                for k, v in zip(node.value.keys, node.value.values):
                    if isinstance(k, ast.Constant) and isinstance(v, ast.Constant):
                        out[k.value] = v.value
                return out
    return {}


def list_len(path: pathlib.Path, var: str) -> int:
    tree = ast.parse(path.read_text(encoding="utf-8", errors="replace"))
    for node in tree.body:
        if isinstance(node, ast.Assign) and any(getattr(t, "id", None) == var for t in node.targets):
            if isinstance(node.value, (ast.List, ast.Tuple)):
                return len(node.value.elts)
    return -1


# ---- 1. counts ---------------------------------------------------------------
modules_py = ROOT / "app" / "modules.py"
setup_py = ROOT / "scripts" / "setup_database.py"
n_modules = len(top_dict_keys(modules_py, "MODULES"))
n_perms = list_len(setup_py, "SEED_PERMISSIONS")
n_ctypes = list_len(setup_py, "SEED_CATEGORY_TYPES")
status = read("brain/STATUS.md")
index = read("brain/INDEX.md")

if n_modules > 0:
    ok(f"MODULES parsed: {n_modules} master modules")
else:
    fail("could not parse MODULES from app/modules.py")

claimed = {
    "modules": re.findall(r"\|\s*Master modules\s*\|\s*(\d+)", status),
    "perms": re.findall(r"\|\s*Seeded permissions\s*\|\s*(\d+)", status),
    "ctypes": re.findall(r"\|\s*Category-type values\s*\|\s*(\d+)", status),
}
if claimed["modules"] and int(claimed["modules"][0]) == n_modules:
    ok(f"STATUS modules count == code ({n_modules})")
else:
    fail(f"STATUS.md modules count {claimed['modules']} != code {n_modules}")
if claimed["perms"] and int(claimed["perms"][0]) == n_perms:
    ok(f"STATUS permissions count == code ({n_perms})")
else:
    fail(f"STATUS.md permissions count {claimed['perms']} != code {n_perms}")
if claimed["ctypes"] and int(claimed["ctypes"][0]) == n_ctypes:
    ok(f"STATUS category-types count == code ({n_ctypes})")
else:
    fail(f"STATUS.md category-types count {claimed['ctypes']} != code {n_ctypes}")

index_rows = len(re.findall(r"^\| [a-z-]+ \| sm_", index, re.M))
if index_rows == n_modules:
    ok(f"INDEX module map has {index_rows} rows == registry")
else:
    fail(f"INDEX §2 has {index_rows} module rows != registry {n_modules}")

# ---- 2. vocabulary vs code ---------------------------------------------------
crud = read("app/routers/crud.py")
if "status='PENDING'" in crud:
    ok("master soft-delete vocabulary: crud.py uses status='PENDING'")
else:
    fail("crud.py no longer uses status='PENDING' — update INDEX §1 and SKILL")

hooks_py = ROOT / "app" / "hooks.py"
prefix = top_dict(hooks_py, "LEVEL_PREFIX")
expected_prefix = {0: "MG", 1: "BG", 2: "CG", 3: "FG"}
if prefix == expected_prefix:
    ok("LEVEL_PREFIX == MG/BG/CG/FG (matches INDEX §1)")
else:
    fail(f"LEVEL_PREFIX changed to {prefix} — update INDEX §1 and AGENTS pointer")

if "MG=Company" in index:
    ok("INDEX §1 states the prefix map")
else:
    fail("INDEX §1 missing prefix-map statement")

skill = read(".agents/skills/ssms/SKILL.md")
if re.search(r"uses `status INACTIVE`", skill):
    fail("SKILL.md still claims master soft-delete is INACTIVE")
else:
    ok("SKILL.md soft-delete vocabulary clean")

# ---- 3. INDEX anchors --------------------------------------------------------
anchor_re = re.compile(r"`([\w./\\-]+):(\d+) \(([^)`]+)\)`")
anchors = anchor_re.findall(index)
bad = []
for f, ln, sym in anchors:
    p = ROOT / f
    if not p.exists():
        bad.append(f"{f} missing")
        continue
    lines = p.read_text(encoding="utf-8", errors="replace").splitlines()
    lo, hi = max(0, int(ln) - 6), int(ln) + 5
    if sym not in "\n".join(lines[lo:hi]):
        bad.append(f"{f}:{ln} ({sym}) moved")
if bad:
    fail("INDEX anchors drifted: " + "; ".join(bad) + " — re-index those rows")
else:
    ok(f"all {len(anchors)} INDEX anchors resolve")

# ---- 4. duplicate-fact scan --------------------------------------------------
for rel in SCAN_FILES:
    if any(rel.startswith(p) for p in EXEMPT_PREFIXES) or not (ROOT / rel).exists():
        continue
    text = read(rel)
    for phrase, homes in PHRASE_HOMES.items():
        if phrase in text and rel not in homes:
            fail(f"duplicated fact '{phrase}' in {rel} (allowed: {sorted(homes) or 'nowhere'})")
ok("duplicate-fact scan complete")

# ---- 5. task register integrity ---------------------------------------------
tasks = read("brain/TASKS.md")
ids = set(re.findall(r"^- (T-\d+) \|", tasks, re.M))
if len(ids) == len(re.findall(r"^- T-\d+ \|", tasks, re.M)):
    ok(f"task ids unique ({len(ids)} tasks)")
else:
    fail("duplicate task ids in brain/TASKS.md")
for m in re.finditer(r"^- (T-\d+) \|[^|]*\|[^|]*\|\s*([^|]*)\|", tasks, re.M):
    deps = [d.strip() for d in m.group(2).split(",") if d.strip() not in ("-", "")]
    for d in deps:
        if d not in ids:
            fail(f"{m.group(1)} depends on unknown task {d}")
inprog = re.findall(r"^- (T-\d+) \|", tasks.split("## IN_PROGRESS")[1].split("## OPEN")[0], re.M)
if len(inprog) <= 1:
    ok("IN_PROGRESS <= 1")
else:
    fail(f"{len(inprog)} tasks IN_PROGRESS (max 1)")

# ---- 6. INDEX stamp vs code/doc changes --------------------------------------
m = re.search(r"synced at commit ([0-9a-f]+)", index)
if not m:
    fail("INDEX header missing 'synced at commit <hash>'")
else:
    stamp = m.group(1)
    try:
        last_touch = subprocess.run(
            ["git", "log", "-1", "--format=%h", "--", "app", "scripts", "docs",
             ".agents", "prompts", "AGENTS.md", "README.md"],
            cwd=ROOT, capture_output=True, text=True, timeout=15).stdout.strip()
        if last_touch:
            anc = subprocess.run(
                ["git", "merge-base", "--is-ancestor", last_touch, stamp],
                cwd=ROOT, capture_output=True, text=True, timeout=15)
            if anc.returncode == 0 or last_touch == stamp:
                ok(f"INDEX stamp {stamp} covers last code/doc change {last_touch}")
            else:
                fail(f"code/docs changed after INDEX stamp ({last_touch} > {stamp}) — re-index per §4a")
        else:
            print("[WARN] git log empty; stamp check skipped")
    except (OSError, subprocess.TimeoutExpired):
        print("[WARN] git unavailable; stamp check skipped")

# ---- summary -----------------------------------------------------------------
print(f"\n{'OK' if not failures else 'DRIFT'}: {passed} passed, {len(failures)} failed")
sys.exit(0 if not failures else 1)
