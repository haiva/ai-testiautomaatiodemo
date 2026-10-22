#!/usr/bin/env python3
"""PostToolUse-hook: valvoo repon rakennesääntöjä deterministisesti.

1. tests/**/*.robot ei saa sisältää matalan tason kirjasto-keywordejä tai lokaattoreita.
2. .resource-tiedostoissa ei kovakoodattuja lokaattoreita (kuuluvat UI_ids.py:hin).
3. Robocop-lint virhetasolla, jos robocop on asennettu.

Exit code 2 -> stderr näytetään Claudelle, joka korjaa ongelman heti.
"""
import json
import re
import shutil
import subprocess
import sys
from pathlib import Path

data = json.load(sys.stdin)
path = data.get("tool_input", {}).get("file_path", "")
if not path.endswith((".robot", ".resource")):
    sys.exit(0)

p = Path(path)
try:
    content = p.read_text(encoding="utf-8")
except OSError:
    sys.exit(0)

problems = []
parts = p.parts

LOW_LEVEL = [
    # Browser Library
    "Click", "Fill Text", "Fill Secret", "Type Text", "Wait For Elements State",
    "Get Element", "Get Text", "New Page", "Go To", "Keyboard Key",
    # AppiumLibrary
    "Tap", "Input Text", "Input Password", "Click Element",
    "Wait Until Page Contains Element", "Swipe", "Open Application",
    # RequestsLibrary / XML
    "Create Session", "GET On Session", "POST On Session", "Parse XML", "Get Elements",
    # yleiset
    "Sleep",
]
LOCATOR_RE = re.compile(r"(css=|xpath=|//\w+\[|accessibility_id=|id=[\w.]+:id/|\[data-testid)")

if "tests" in parts:
    for n, line in enumerate(content.splitlines(), 1):
        stripped = line.strip()
        if not line.startswith((" ", "\t")) or stripped.startswith("#"):
            continue
        first = re.split(r"\s{2,}|\t", stripped)[0]
        if first in LOW_LEVEL:
            problems.append(f"{path}:{n}: matalan tason keyword '{first}' testitiedostossa "
                            "-> siirrä resources/<OS>/keywords.resource:een (sääntö 1)")
        if LOCATOR_RE.search(line):
            problems.append(f"{path}:{n}: lokaattori testitiedostossa -> UI_ids.py (sääntö 3)")

if path.endswith(".resource"):
    for n, line in enumerate(content.splitlines(), 1):
        if LOCATOR_RE.search(line) and not line.strip().startswith("#"):
            problems.append(f"{path}:{n}: kovakoodattu lokaattori -> siirrä UI_ids.py:hin (sääntö 3)")

def find_robocop():
    """Projektin .venv ensin, sitten PATH. Toimii ilman venvin aktivointia."""
    root = Path(__file__).resolve().parents[2]
    for c in (root / ".venv/bin/robocop", root / ".venv/Scripts/robocop.exe"):
        if c.exists():
            return str(c)
    return shutil.which("robocop")


robocop = find_robocop()
if robocop:
    r = subprocess.run([robocop, "check", "--threshold", "E", path],
                       capture_output=True, text=True)
    if r.returncode != 0 and r.stdout.strip():
        problems.append("Robocop:\n" + r.stdout.strip())

if problems:
    print("RAKENNETARKISTUS EPÄONNISTUI:\n" + "\n".join(problems), file=sys.stderr)
    sys.exit(2)
sys.exit(0)
