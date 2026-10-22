"""Android-emulaattori (Android Studio AVD). Tiedoston nimi = laitteen serial (adb devices),
kuten YLEn laitefarmissa.

APP_PACKAGE ja APP_ACTIVITY: selvitä skriptillä scripts/selvita_android_paketti.sh
"""
DEVICE_NAME = "emulator-5554"
UDID = "emulator-5554"
PLATFORM_VERSION = "14"        # Pixel 7 AVD, API 34
FORM_FACTOR = "phone"          # phone | tablet -> device_specific/<FORM_FACTOR>/
APPIUM_SERVER = "http://127.0.0.1:4723"

APP_PACKAGE = "TODO"           # TODO: Yle-sovellus, adb shell pm list packages | grep -i yle
APP_ACTIVITY = "TODO"          # TODO: adb shell dumpsys window | grep mCurrentFocus
NO_RESET = True                # säilytä sovelluksen tila ajojen välillä
