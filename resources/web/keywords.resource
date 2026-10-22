*** Settings ***
Documentation     Web (yle.fi, työpöytäselain): ylätason keywordien toteutus Browser Libraryllä.
...               Samat keyword-nimet toteutetaan jokaiselle alustalle.
Library           Browser
Resource          setups_teardowns.resource
Resource          navigation.resource

*** Keywords ***
User Should Not Be Logged In
    [Documentation]    Yläpalkissa näkyy Kirjaudu-painike eli käyttäjä ei ole kirjautunut.
    Wait For Elements State    ${LOGIN_ENTRY_BUTTON}    visible

Login From UI
    [Documentation]    Kirjautuu Yle Tunnuksella käyttöliittymän kautta. Tunnukset ympäristömuuttujista.
    [Arguments]    ${username}=%{YLE_USER}    ${password}=%{YLE_PASSWORD}
    Go To Login Page
    Fill Text    ${LOGIN_EMAIL_INPUT}    ${username}
    Fill Secret    ${LOGIN_PASSWORD_INPUT}    $password
    Click    ${LOGIN_SUBMIT_BUTTON}

User Should Be Logged In
    Wait For Elements State    ${LOGGED_IN_INDICATOR}    visible    timeout=15s

Navigation Items Should Be
    [Documentation]    Tarkistaa profiilin (main/sub) navigaatiokohteet, vrt. YLEn esimerkki.
    FOR    ${item}    IN    @{${MAIN_OR_SUB}_ACCOUNT_NAVIGATION_ITEMS}
        Wait For Elements State    ${item}    visible    timeout=1s
    END
