*** Settings ***
Documentation     API: HTTP-istunnon avaus ja sulkeminen (RequestsLibrary).
Library           RequestsLibrary

*** Keywords ***
Open App
    [Documentation]    Avaa HTTP-istunnon yle.fi:n rajapintaan aliaksella 'yle'.
    Create Session    yle    ${API_BASE_URL}    timeout=${API_TIMEOUT}    verify=${True}

Close App
    Delete All Sessions
