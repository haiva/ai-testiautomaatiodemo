*** Settings ***
Documentation     API-testitaso (yle.fi:n julkiset syötteet): keywordit RequestsLibraryllä.
...               Oma testitaso; ei vastinetta käyttöliittymäalustoilla.
Library           RequestsLibrary
Library           XML
Resource          setups_teardowns.resource

*** Keywords ***
User Opens Latest News
    [Documentation]    Hakee tuoreimpien uutisten RSS-syötteen.
    ${response}=    GET On Session    yle    ${LATEST_NEWS_FEED}
    Should Start With    ${response.headers}[Content-Type]    application/rss+xml
    VAR    ${LATEST_NEWS}    ${response.content}    scope=TEST

Latest News Should Contain Headlines
    [Documentation]    Syötteessä on uutisia, ja jokaisella on otsikko ja yle.fi-linkki.
    ${feed}=    Parse XML    ${LATEST_NEWS}
    @{items}=    Get Elements    ${feed}    channel/item
    Should Not Be Empty    ${items}
    FOR    ${item}    IN    @{items}
        ${title}=    Get Element Text    ${item}    title
        Should Not Be Empty    ${title}
        ${link}=    Get Element Text    ${item}    link
        Should Start With    ${link}    ${WEB_BASE_URL}/
    END
