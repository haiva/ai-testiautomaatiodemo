---
description: Toteuta uusi ylätason testi kaikille alustoille repon rakennetta noudattaen
argument-hint: <testin kuvaus tai polku testitiedostoon>
---
Toteuta testi: $ARGUMENTS

Noudata CLAUDE.md:n sääntöjä ja tätä järjestystä:

1. **Suunnitelma ensin** (älä kirjoita vielä): listaa ylätason askeleet Given/When/Then-muodossa,
   ja jokaiselle: onko keyword jo olemassa (grep `resources/`), laajennetaanko vai luodaanko uusi,
   ja mihin tiedostoon kukin muutos menee (web + native_android). Odota hyväksyntäni.
2. Tutki tarvittavat näkymät: web robotmcp:llä, Android appium-mcp:llä (kuten /tutki-web ja
   /tutki-android). Käytä tarvittaessa `lokaattori-tutkija`-subagenttia, jotta pääkonteksti pysyy siistinä.
3. Kirjoita: `UI_ids.py` (molemmat alustat) → `keywords.resource` / `navigation.resource` → testi `tests/`-kansioon.
4. Aja `scripts/aja.sh web --dryrun` ja `scripts/aja.sh android --dryrun`, sitten oikeat ajot.
5. Raportoi: muuttuneet tiedostot, uudet keywordit, uudelleenkäytetyt keywordit, avoimet TODOt.
