*** Settings ***
Documentation     Android (natiivisovellus): ylätason keywordien toteutus AppiumLibraryllä.
...               Samat keyword-nimet kuin resources/web/keywords.resource:ssa.
Library           AppiumLibrary
Resource          setups_teardowns.resource
Resource          navigation.resource

*** Keywords ***
User Should Not Be Logged In
    Go To Profile
    Wait Until Page Contains Element    ${LOGIN_ENTRY_BUTTON}

Login From UI
    [Documentation]    Kirjautuu Yle Tunnuksella käyttöliittymän kautta. Tunnukset ympäristömuuttujista.
    ...    Huom: kirjautuminen voi avautua WebView'hun -> tarkista kontekstit (ks. skill).
    [Arguments]    ${username}=%{YLE_USER}    ${password}=%{YLE_PASSWORD}
    Go To Login Page
    Wait Until Page Contains Element    ${LOGIN_EMAIL_INPUT}
    Input Text    ${LOGIN_EMAIL_INPUT}    ${username}
    Input Password    ${LOGIN_PASSWORD_INPUT}    ${password}
    Click Element    ${LOGIN_SUBMIT_BUTTON}

User Should Be Logged In
    Wait Until Page Contains Element    ${LOGGED_IN_INDICATOR}    timeout=15

Navigation Items Should Be
    [Documentation]    Tarkistaa profiilin (main/sub) navigaatiokohteet, vrt. YLEn esimerkki.
    FOR    ${item}    IN    @{${MAIN_OR_SUB}_ACCOUNT_NAVIGATION_ITEMS}
        Wait Until Page Contains Element    ${item}    timeout=1
    END
