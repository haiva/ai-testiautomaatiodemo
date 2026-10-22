*** Settings ***
Documentation     Kirjautuminen. Samat ylätason testit kaikille alustoille;
...               toteutus valitaan ajossa muuttujilla OS, DEVICE ja MAIN_OR_SUB.
Variables         ${CURDIR}/../resources/shared/environments.py    ${EXEC_ENV}
Variables         ${CURDIR}/../resources/${OS}/UI_ids.py
Variables         ${CURDIR}/../resources/${OS}/devices/${DEVICE}.py
Resource          ${CURDIR}/../resources/${OS}/keywords.resource
Resource          ${CURDIR}/../resources/shared/shared_keywords.resource
Resource          ${CURDIR}/../resources/${OS}/${MAIN_OR_SUB}/keywords.resource

Suite Setup       Open App
Suite Teardown    Close App

*** Test Cases ***
Login To Yle
    [Tags]    web_test    native_android_test    androidtv_test    smoke
    User Should Not Be Logged In
    Login From UI
    User Should Be Logged In
    [Teardown]    Logout User Test Teardown
