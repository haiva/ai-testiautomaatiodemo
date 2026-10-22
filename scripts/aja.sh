#!/usr/bin/env bash
# Käyttö: scripts/aja.sh web|android|api [lisäargumentit robotille, esim. --dryrun tai --include smoke]
# Ympäristömuuttujilla voi ohittaa oletukset: DEVICE, MAIN_OR_SUB, EXEC_ENV
# web ja android ajavat käyttöliittymätestit (tests/), api oman testitasonsa (tests/api/).
set -euo pipefail
cd "$(dirname "$0")/.."

PLATFORM="${1:-web}"; shift || true
case "$PLATFORM" in
  web)     OS=web;            DEVICE="${DEVICE:-chromium_desktop}";   TAG=web_test ;;
  android) OS=native_android; DEVICE="${DEVICE:-emulator-5554}"; TAG=native_android_test ;;
  api)     TAG=api_test ;;
  *) echo "Tuntematon alusta: $PLATFORM (web|android|api)"; exit 1 ;;
esac

if [ "$PLATFORM" = api ]; then
  TARGET=tests/api/
  VARS=()
else
  TARGET=tests/
  VARS=(--variable "OS:$OS" --variable "DEVICE:$DEVICE" --variable "MAIN_OR_SUB:${MAIN_OR_SUB:-main}")
fi

# Käytä projektin venviä automaattisesti, vaikka sitä ei olisi aktivoitu
if   [ -x .venv/bin/robot ];         then ROBOT=.venv/bin/robot
elif [ -x .venv/Scripts/robot.exe ]; then ROBOT=.venv/Scripts/robot.exe
else ROBOT=robot; echo "Huom: .venv puuttuu, käytetään PATHin robot-komentoa" >&2
fi

# Browser kirjoittaa playwright-log.txt:n outputdiriin; robot ei luo sitä, jos --output/--log/--report ovat NONE
mkdir -p "results/$PLATFORM"

"$ROBOT" \
  ${VARS[@]+"${VARS[@]}"} \
  --variable "EXEC_ENV:${EXEC_ENV:-TEST}" \
  --include "$TAG" \
  --exclude wip \
  --outputdir "results/$PLATFORM" \
  "$@" "$TARGET"
