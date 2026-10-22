*** Settings ***
Documentation     Web: sovelluksen avaus, sulkeminen ja teardownit.
Library           Browser

*** Keywords ***
Open App
    [Documentation]    Avaa yle.fi:n selaimeen ja ohittaa evästedialogin.
    New Browser    ${BROWSER}    headless=${HEADLESS}
    New Context    viewport={'width': ${VIEWPORT_WIDTH}, 'height': ${VIEWPORT_HEIGHT}}    locale=${LOCALE}
    New Page    ${WEB_BASE_URL}
    Set Browser Timeout    10s
    Dismiss Cookie Consent

Dismiss Cookie Consent
    [Documentation]    Evästedialogi peittää sivun uudessa selainkontekstissa. Hyväksyy vain välttämättömät.
    Wait For Elements State    ${COOKIE_CONSENT_REJECT_BUTTON}    visible
    Click    ${COOKIE_CONSENT_REJECT_BUTTON}

Close App
    Close Browser    ALL

Logout User Test Teardown
    [Documentation]    Kirjaa käyttäjän ulos testin lopuksi. Ei kaada teardownia.
    Run Keyword If Test Failed    Take Screenshot
    Run Keyword And Ignore Error    Logout From UI
    Clear Session State

Logout From UI
    Click    ${LOGOUT_BUTTON}

Clear Session State
    [Documentation]    Varmistaa puhtaan tilan seuraavalle testille.
    Run Keyword And Ignore Error    Delete All Cookies
    Run Keyword And Ignore Error    LocalStorage Clear
