#!/usr/bin/env bash
# Esitarkistus ennen koulutusta. Aja: scripts/tarkista_ymparisto.sh
ok(){ printf "  [OK]  %s\n" "$1"; }; ng(){ printf "  [!!]  %s\n" "$1"; }
chk(){ command -v "$1" >/dev/null 2>&1 && ok "$1: $($1 ${2:---version} 2>&1 | head -1)" || ng "$1 puuttuu"; }
echo "== Python-ympäristö =="
{ [ -x .venv/bin/robot ] || [ -x .venv/Scripts/robot.exe ]; } && ok ".venv löytyy ja robot asennettu" || ng ".venv puuttuu (python3 -m venv .venv && pip install -r requirements.txt)"
command -v robotmcp >/dev/null 2>&1 && robotmcp doctor -C . >/dev/null 2>&1 && ok "robotmcp doctor OK" || ng "robotmcp doctor -C . ilmoitti ongelmasta tai robotmcp puuttuu"
echo "== Työkalut =="
chk python3; chk node; chk npx; chk robot; chk claude; chk uv; chk robotmcp " --help"; chk appium; chk adb " version"; chk emulator " -version"
echo "== Ympäristömuuttujat =="
[ -n "${ANDROID_HOME:-}" ] && ok "ANDROID_HOME=$ANDROID_HOME" || ng "ANDROID_HOME puuttuu"
[ -n "${YLE_USER:-}" ] && ok "YLE_USER asetettu" || ng "YLE_USER puuttuu"
[ -n "${YLE_PASSWORD:-}" ] && ok "YLE_PASSWORD asetettu" || ng "YLE_PASSWORD puuttuu"
echo "== Android =="
adb devices 2>/dev/null | grep -q "emulator-" && ok "emulaattori käynnissä" || ng "emulaattori ei käynnissä (emulator -avd <nimi>)"
curl -s http://127.0.0.1:4723/status | grep -q '"ready":true' && ok "Appium-palvelin vastaa (4723)" || ng "Appium-palvelin ei käynnissä (aja: appium)"
echo "== Rakenne (dryrun) =="
scripts/aja.sh web --dryrun --output NONE --report NONE --log NONE >/dev/null 2>&1 && ok "web dryrun" || ng "web dryrun epäonnistui"
scripts/aja.sh android --dryrun --output NONE --report NONE --log NONE >/dev/null 2>&1 && ok "android dryrun" || ng "android dryrun epäonnistui"
scripts/aja.sh api --dryrun --output NONE --report NONE --log NONE >/dev/null 2>&1 && ok "api dryrun" || ng "api dryrun epäonnistui"
