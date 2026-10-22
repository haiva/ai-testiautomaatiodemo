#!/usr/bin/env bash
# Selvittää Yle-sovelluksen package- ja activity-nimen emulaattorista.
# 1) Käynnistä emulaattori ja asenna Yle-sovellus  2) Avaa sovellus käsin  3) Aja tämä skripti
set -euo pipefail
echo "== Laitteet =="; adb devices
echo "== Yle-paketit =="; adb shell pm list packages | grep -i yle || echo "Ei löytynyt – onko sovellus asennettu?"
echo "== Etualalla oleva activity (avaa Yle-sovellus ensin) =="
adb shell dumpsys window | grep -E "mCurrentFocus|mFocusedApp" || true
echo
echo "Kirjaa tulokset tiedostoon resources/native_android/devices/emulator-5554.py (APP_PACKAGE, APP_ACTIVITY)"
