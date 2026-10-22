*** Settings ***
Documentation     Android: sovelluksen avaus, sulkeminen ja teardownit (AppiumLibrary).
Library           AppiumLibrary

*** Keywords ***
Open App
    [Documentation]    Käynnistää Yle-sovelluksen laitteella, jonka tiedot ovat devices/${DEVICE}.py:ssä.
    Open Application    ${APPIUM_SERVER}
    ...    platformName=Android
    ...    appium:automationName=UiAutomator2
    ...    appium:udid=${UDID}
    ...    appium:deviceName=${DEVICE_NAME}
    ...    appium:appPackage=${APP_PACKAGE}
    ...    appium:appActivity=${APP_ACTIVITY}
    ...    appium:noReset=${NO_RESET}
    ...    appium:newCommandTimeout=300
    Set Appium Timeout    10s

Close App
    Close All Applications

Logout User Test Teardown
    [Documentation]    Kirjaa käyttäjän ulos testin lopuksi. Ei kaada teardownia.
    Run Keyword If Test Failed    Capture Page Screenshot
    Run Keyword And Ignore Error    Logout From UI

Logout From UI
    Go To Profile
    Click Element    ${LOGOUT_BUTTON}
