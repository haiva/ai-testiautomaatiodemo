*** Settings ***
Variables         ${CURDIR}/../../resources/shared/environments.py    ${EXEC_ENV}
Variables         ${CURDIR}/../../resources/${OS}/UI_ids.py
Variables         ${CURDIR}/../../resources/${OS}/devices/${DEVICE}.py
Resource          ${CURDIR}/../../resources/${OS}/keywords.resource
Resource          ${CURDIR}/../../resources/shared/shared_keywords.resource
Resource          ${CURDIR}/../../resources/${OS}/${MAIN_OR_SUB}/keywords.resource
Documentation     Uutisosiot (esim. Urheilu).

*** Test Cases ***
User Can Open News Section
    [Tags]    web_test    native_android_test    wip
    [Documentation]    HANDS-ON: toteutetaan koulutuksessa Claude Codella (/uusi-testi).
    # Given User Is On Front Page
    # When User Opens Section    Urheilu
    # Then Section Page Should Be Displayed    Urheilu
    Skip    Toteutetaan koulutuksessa
