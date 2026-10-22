*** Settings ***
Documentation     Alustariippumattomat keywordit. Kutsuvat vain ylätason keywordejä,
...               jotka jokainen alusta toteuttaa omassa keywords.resource-tiedostossaan.

*** Keywords ***
Open App And Login
    [Documentation]    Avaa sovelluksen ja kirjautuu. Käytetään suite setupissa.
    Open App
    Login From UI
    User Should Be Logged In

Not Implemented For This Platform
    [Documentation]    Runko keywordeille, joita ei ole vielä toteutettu tälle alustalle.
    Fail    Not implemented for ${OS}
