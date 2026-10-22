*** Settings ***
Documentation     Web: navigointi näkymästä toiseen.
Library           Browser

*** Keywords ***
Go To Front Page
    Go To    ${WEB_BASE_URL}

Go To Login Page
    [Documentation]    Avaa Yle Tunnus -kirjautumisdialogin yläpalkin Kirjaudu-painikkeesta.
    Click    ${LOGIN_ENTRY_BUTTON}
    Wait For Elements State    ${LOGIN_EMAIL_INPUT}    visible
