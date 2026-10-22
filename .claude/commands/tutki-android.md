---
description: Tutki Yle Android-sovelluksen näkymä Appium-MCP:llä ja ehdota lokaattorit
argument-hint: <näkymä tai toiminto, esim. "kirjautuminen">
---
Tutki näkymää "$ARGUMENTS" Yle Android-sovelluksessa appium-mcp-työkaluilla.

1. Lue `resources/native_android/devices/emulator-5554.py` (package, activity, udid) ja
   `resources/native_android/UI_ids.py`.
2. Luo Android-sessio näillä tiedoilla (`appium_session_management` action=create).
3. Hae `appium_get_page_source` ja `generate_locators`. Jos näkymä on WebView, tarkista
   kontekstit (`appium_context` action=list) ja kerro siitä.
4. Vahvista lokaattorit `appium_find_element`-kutsuilla. Prioriteetti: accessibility id >
   resource-id > -android uiautomator > xpath.
5. Käytä samoja VAKIO_NIMIÄ kuin `resources/web/UI_ids.py` aina kun käsite on sama.
6. Palauta taulukko: VAKIO_NIMI | AppiumLibrary-muotoinen lokaattori (esim. `accessibility_id=...`,
   `id=fi.example:id/...`, `android=new UiSelector()...`) | vahvistettu | huomio.
7. Sulje sessio lopuksi (action=delete), jotta robot-ajo voi käyttää emulaattoria.

ÄLÄ käytä `appium_generate_tests`-työkalua äläkä kirjoita tiedostoihin tässä vaiheessa.
