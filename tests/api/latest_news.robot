*** Settings ***
Documentation     Tuoreimmat uutiset: RSS-syötteen sisältö rajapintatasolla.
Variables         ${CURDIR}/../../resources/shared/environments.py    ${EXEC_ENV}
Variables         ${CURDIR}/../../resources/api/endpoints.py
Resource          ${CURDIR}/../../resources/api/keywords.resource

Suite Setup       Open App
Suite Teardown    Close App

*** Test Cases ***
Latest News Contain Headlines
    [Tags]    api_test    smoke
    When User Opens Latest News
    Then Latest News Should Contain Headlines
