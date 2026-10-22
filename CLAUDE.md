# Yle – Robot Framework -testiautomaatio

Tämä repo peilaa YLEn tuotantorepon rakennetta: **yksi repo, samat ylätason testitapaukset
kaikille päätelaitteille, alustakohtainen toteutus omissa kansioissaan.**
Rakenteen säilyttäminen on tärkeämpää kuin nopeus.

Testikohteet: web = https://yle.fi (työpöytäselain), Android = Yle-sovellus (uutiset) emulaattorissa.
Kirjautuminen Yle Tunnuksella. Lisäksi oma API-testitaso: yle.fi:n julkiset RSS-syötteet (RequestsLibrary).

## Rakenne (älä muuta ilman erillistä pyyntöä)
```
jenkins/                      Jenkins-putkien groovy-tiedostot
libraries/                    Omat Python-kirjastot (RF libraries)
resources/
  <OS>/                       web | native_android | androidtv (käyttöliittymäalustat)
    devices/<DEVICE>.py       laitekohtaiset arvot (serial, capabilities, viewport)
    device_specific/          phone/tablet-erot (vain mobiili)
    main/ sub/                pää- ja alaprofiilin erot (${MAIN_OR_SUB})
    keywords.resource         ylätason keywordien toteutus tälle alustalle
    navigation.resource       navigointi (näkymästä toiseen)
    setups_teardowns.resource Open App, Close App, teardownit
    UI_ids.py                 KAIKKI lokaattorit tälle alustalle
  api/                        API-testitaso (ei ${OS}-valintaa, ei devices/main/sub)
    endpoints.py              KAIKKI rajapinnan polut
    keywords.resource         API-keywordit (RequestsLibrary)
    setups_teardowns.resource Open App, Close App (HTTP-istunto)
  shared/                     alustariippumattomat keywordit ja muuttujat
tests/                        VAIN ylätason testitapaukset (.robot)
  api/                        API-testit; tuovat resources/api/-tiedostot suoraan
```

## Kultaiset säännöt
1. `tests/**/*.robot` sisältää vain ylätason liiketoimintakeywordejä. Ei lokaattoreita,
   ei Browser- tai AppiumLibrary-keywordejä, ei `Sleep`-kutsuja.
2. Jokainen käyttöliittymätestin ylätason keyword toteutetaan **samalla nimellä** jokaiselle
   käyttöliittymäalustalle (web, native_android, androidtv): `resources/web/keywords.resource` ja
   `resources/native_android/keywords.resource`.
   Jos toteutat vain yhdelle, lisää muille runko `Fail    Not implemented for ${OS}` ja kerro siitä.
   API on oma testitasonsa: sen keywordeille ei tehdä vastineita eikä runkoja käyttöliittymäalustoille.
3. Lokaattorit vain `UI_ids.py`-tiedostoihin, ISOILLA_KIRJAIMILLA (esim. `LOGIN_EMAIL_INPUT`).
   API-polut vain `resources/api/endpoints.py`:hin (esim. `LATEST_NEWS_FEED`).
4. Ennen uutta keywordia: etsi olemassa olevat (`grep -rn "Keyword Name" resources/`).
   Järjestys: uudelleenkäytä → laajenna argumentilla → luo uusi.
5. Alustariippumaton logiikka → `resources/shared/shared_keywords.resource`.
6. Laitekohtaiset arvot → `resources/<OS>/devices/<DEVICE>.py`.
   Profiilierot → `resources/<OS>/<main|sub>/keywords.resource`.
7. Tunnukset vain ympäristömuuttujista `%{YLE_USER}` ja `%{YLE_PASSWORD}`.
   Älä koskaan kirjoita salasanaa mihinkään tiedostoon.
8. Tagit: `web_test`, `native_android_test`, `androidtv_test`, `api_test` + tarvittaessa `smoke`, `wip`.
9. Odotukset: Browser → `Wait For Elements State` (auto-wait), Appium →
   `Wait Until Page Contains Element`. Ei kiinteitä `Sleep`-viiveitä.
   API: `Create Session` aliaksella `yle` → `GET On Session` (tarkistaa statuksen automaattisesti).
10. Keywordien nimet englanniksi Title Case (YLEn käytäntö). `[Documentation]` lyhyesti.
11. Ylätason testit kirjoitetaan Given/When/Then-henkisinä lauseina, kun se on luontevaa.

## MCP-työkalut
- **robotmcp (rf-mcp)**: web-sovelluksen ja rajapintojen tutkiminen ja keywordien kokeilu askel
  kerrallaan Browser Libraryllä / RequestsLibraryllä *ennen* tiedostoon kirjoittamista.
  Kokeile, vahvista, kirjoita vasta sitten.
- **appium-mcp**: Android-emulaattorin tutkiminen (`appium_get_page_source`, `generate_locators`,
  `appium_find_element`). **Älä käytä `appium_generate_tests`-työkalun Java-koodia** – käännä
  löydökset RF-keywordeiksi tämän repon rakenteeseen.
- Sulje appium-mcp-sessio (`appium_session_management` action=delete) ennen kuin ajat
  robot-testit emulaattoria vastaan: UiAutomator2 sallii vain yhden session kerrallaan.
- Ota sovelluksen package/activity tiedostosta `resources/native_android/devices/<DEVICE>.py`
  kun luot appium-mcp-session.
- Lokaattoriprioriteetti:
  - Android: accessibility id > resource-id > `-android uiautomator` > xpath (viimeinen keino)
  - Web: `data-testid` / aria / role > id > css > text > xpath (viimeinen keino)

## Ajaminen
```bash
scripts/aja.sh web                  # Browser Library, Chromium työpöytäresoluutiolla
scripts/aja.sh android              # Appium + emulator-5554 (Appium-palvelin käynnissä)
scripts/aja.sh api                  # API-testitaso: tests/api/, RequestsLibrary
scripts/aja.sh web --dryrun         # rakenteen tarkistus ilman selainta
```
Windowsissa PowerShellistä: `scripts\aja.ps1 web` (samat argumentit).
Vastaa YLEn komentoa:
`robot --variable OS:web --variable DEVICE:chromium_desktop --variable MAIN_OR_SUB:main --variable EXEC_ENV:TEST --include web_test tests/`
API: `robot --variable EXEC_ENV:TEST --include api_test tests/api/`

## Työtapa jokaisessa tehtävässä
1. Suunnittele ensin: mitkä keywordit ovat jo olemassa, mitkä uusia, mihin tiedostoihin.
2. Tutki sovellus MCP:llä ja vahvista lokaattorit.
3. Kirjoita järjestyksessä: `UI_ids.py` → alustan keywordit → testitapaus.
4. Aja `--dryrun`, sitten oikea ajo. Korjaa kunnes vihreä.
5. Raportoi lopuksi muutokset tiedostoittain ja avoimet TODOt.
