---
description: Aja testit alustalle ja analysoi tulos
argument-hint: <web|android> [robot-lisäargumentit]
allowed-tools: Bash(scripts/aja.sh:*), Read, Grep
---
Aja `scripts/aja.sh $ARGUMENTS`.
Jos testejä epäonnistuu: lue `results/<alusta>/output.xml` (ei koko log.htmlää), tunnista
epäonnistunut keyword ja syy (lokaattori, ajoitus, data, ympäristö) ja ehdota korjaus
oikeaan tiedostoon CLAUDE.md:n rakenteen mukaan. Älä korjaa testitiedostoa, jos vika on toteutuksessa.
