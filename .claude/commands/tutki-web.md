---
description: Tutki yle.fi:n näkymä RF-MCP:llä ja ehdota lokaattorit
argument-hint: <näkymä tai toiminto, esim. "kirjautuminen">
---
Tutki näkymää "$ARGUMENTS" yle.fi:ssä robotmcp-työkaluilla (Browser Library).

1. Lue `resources/web/UI_ids.py` ja `resources/web/keywords.resource`: mitä on jo olemassa?
2. Avaa selain laitteen `resources/web/devices/chromium_desktop.py` viewportilla osoitteeseen,
   jonka `resources/shared/environments.py` antaa (TEST). Ohita evästedialogi
   (`COOKIE_CONSENT_REJECT_BUTTON`). Tunnukset: `%{YLE_USER}` / `%{YLE_PASSWORD}`. Älä tulosta salasanaa.
3. Kulje näkymä läpi askel kerrallaan. Vahvista jokainen lokaattori oikealla toiminnolla
   (Click / Fill Text / Wait For Elements State), älä pelkästä DOMista päättelemällä.
4. Yle Tunnus -kirjautuminen on iframessa (`#tunnus-sdk__content`): käytä Browserin `>>>`-erotinta.
5. Palauta taulukko: VAKIO_NIMI | lokaattori | strategia | vahvistettu (kyllä/ei) | huomio.

ÄLÄ kirjoita tiedostoihin tässä vaiheessa. Kysy lopuksi, päivitetäänkö `UI_ids.py`.
