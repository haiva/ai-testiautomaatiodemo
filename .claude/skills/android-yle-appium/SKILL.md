---
name: android-yle-appium
description: Yle Android-sovelluksen Appium-erityispiirteet Robot Frameworkissa (AppiumLibrary). Käytä aina kun kirjoitat tai korjaat native_android-keywordejä tai tutkit emulaattoria.
---
# Yle-sovellus (Android) + AppiumLibrary

## Ympäristö
- Emulaattori: `adb devices` -> `emulator-5554`. Laitetiedot: `resources/native_android/devices/emulator-5554.py`.
- Robot-ajo tarvitsee erillisen Appium-palvelimen (`appium`, portti 4723).
  Appium-MCP käyttää omaa sisäänrakennettua ajuria -> **vain yksi sessio kerrallaan**:
  sulje MCP-sessio ennen robot-ajoa.

## Lokaattorit AppiumLibraryssä
- `accessibility_id=Kirjaudu` (content-desc)
- `id=<package>:id/<nimi>` (resource-id)
- `android=new UiSelector().text("Kirjaudu")` tai `.textContains("...")`
- Vieritys näkyviin: `android=new UiScrollable(new UiSelector().scrollable(true)).scrollIntoView(new UiSelector().text("Urheilu"))`
- xpath vain viimeisenä keinona; ei koskaan absoluuttista xpathia.

## WebView-kirjautuminen
Jos kirjautumislomake on WebView:
1. `@{contexts}=    Get Contexts` -> etsi `WEBVIEW_*`
2. `Switch To Context    WEBVIEW_...` -> lokaattorit css/xpath
3. Takaisin: `Switch To Context    NATIVE_APP`
Kääri tämä keywordiksi `navigation.resource`:en, älä testiin.

## Hyvät käytännöt
- `Wait Until Page Contains Element` ennen vuorovaikutusta, ei `Sleep`.
- `Hide Keyboard` tekstinsyötön jälkeen, jos näppäimistö peittää painikkeen.
- `noReset=True` nopeuttaa ajoja; kirjautumistilan nollaus teardownissa.
- Puhelin vs. tabletti: erot `device_specific/<phone|tablet>/`-kansioon, valinta `${FORM_FACTOR}`.
