"""Lokaattorit: Yle-sovellus (Android), AppiumLibrary.

Prioriteetti: accessibility_id > id (resource-id) > android (UiAutomator) > xpath.
Kaikki 'TODO'-arvot vahvistetaan Appium-MCP:llä (/tutki-android).
"""

# --- Kirjautuminen (Yle Tunnus) ---
PROFILE_TAB = "accessibility_id=TODO"
LOGIN_ENTRY_BUTTON = 'android=new UiSelector().text("Kirjaudu")'   # TODO: vahvista
LOGIN_EMAIL_INPUT = "TODO"
LOGIN_PASSWORD_INPUT = "TODO"
LOGIN_SUBMIT_BUTTON = "TODO"
LOGGED_IN_INDICATOR = "TODO"
LOGOUT_BUTTON = 'android=new UiSelector().text("Kirjaudu ulos")'   # TODO: vahvista

# --- Navigaatio (vrt. YLEn esimerkki) ---
# TODO: sovelluksen alapalkin välilehdet
MAIN_ACCOUNT_NAVIGATION_ITEMS = ["TODO"]
SUB_ACCOUNT_NAVIGATION_ITEMS = ["TODO"]
