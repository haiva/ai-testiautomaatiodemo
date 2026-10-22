*** Settings ***
Documentation     Android: navigointi sovelluksen näkymien välillä.
Library           AppiumLibrary

*** Keywords ***
Go To Profile
    Wait Until Page Contains Element    ${PROFILE_TAB}
    Click Element    ${PROFILE_TAB}

Go To Login Page
    Go To Profile
    Wait Until Page Contains Element    ${LOGIN_ENTRY_BUTTON}
    Click Element    ${LOGIN_ENTRY_BUTTON}

Press Back
    Go Back
