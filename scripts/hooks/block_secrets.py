#!/usr/bin/env python3
"""PreToolUse-hook: estää salasanojen kirjoittamisen tiedostoihin.

Claude Code antaa työkalukutsun JSONina stdinissä. Exit code 2 estää kutsun ja
näyttää stderr-viestin Claudelle, joka korjaa toimintansa.
"""
import json
import re
import sys

data = json.load(sys.stdin)
tool_input = data.get("tool_input", {})
path = tool_input.get("file_path", "")

texts = [tool_input.get("content", ""), tool_input.get("new_string", "")]
texts += [e.get("new_string", "") for e in tool_input.get("edits", [])]
text = "\n".join(t for t in texts if t)

if path.endswith((".env", ".env.example")):
    sys.exit(0)

patterns = [
    r"a1111111",                                      # koulutuksen testisalasana
    r"(?i)password\s*[=:]\s*['\"][^'\"$%{][^'\"]+['\"]",  # password = "literal"
    r"(?i)\$\{PASSWORD\}\s{2,}\S*\d",                 # RF Variables-taulukon literaali
]
for p in patterns:
    if re.search(p, text):
        print(
            "ESTETTY: tiedostoon ollaan kirjoittamassa salasanaa. Käytä "
            "%{YLE_PASSWORD}-ympäristömuuttujaa (ks. CLAUDE.md sääntö 7).",
            file=sys.stderr,
        )
        sys.exit(2)
sys.exit(0)