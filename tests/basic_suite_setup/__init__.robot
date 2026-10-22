*** Settings ***
Variables         ${CURDIR}/../../resources/shared/environments.py    ${EXEC_ENV}
Variables         ${CURDIR}/../../resources/${OS}/UI_ids.py
Variables         ${CURDIR}/../../resources/${OS}/devices/${DEVICE}.py
Resource          ${CURDIR}/../../resources/${OS}/keywords.resource
Resource          ${CURDIR}/../../resources/shared/shared_keywords.resource
Resource          ${CURDIR}/../../resources/${OS}/${MAIN_OR_SUB}/keywords.resource
Documentation     Perusjoukko: sovellus avataan ja käyttäjä kirjautuu kerran koko kansiolle.
Suite Setup       Open App And Login
Suite Teardown    Close App
