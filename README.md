# Robot Framework + Claude Code (koulutusrepo)

Ylätason testit (`tests/`) ajetaan web-selaimella
(Browser Library) ja Android-emulaattorilla (AppiumLibrary); alusta valitaan muuttujilla.
Lisäksi API-testeillä on oma testitasonsa (`tests/api/`, RequestsLibrary).

| Alusta | Testikohde |
|---|---|
| web | https://yle.fi (työpöytäselain) |
| Android | Yle-sovellus (uutiset) emulaattorissa |
| API-testitaso | yle.fi:n julkiset RSS-syötteet, esim. https://yle.fi/rss/uutiset/tuoreimmat (ei tunnistautumista) |
| Kirjautuminen | Yle Tunnus, ympäristömuuttujat `YLE_USER` ja `YLE_PASSWORD` (tunnus kouluttajalta) |

```
.claude/            Claude Coden projektiasetukset: komennot, subagentit, skill, hookit, oikeudet
.mcp.json           MCP-palvelimet: robotmcp (rf-mcp) ja appium-mcp
CLAUDE.md           Clauden pysyvä konteksti: rakenne ja säännöt
jenkins/ libraries/ resources/{web,native_android,androidtv,api,shared}/ tests/ tests/api/
scripts/            aja.sh, tarkista_ymparisto.sh, selvita_android_paketti.sh, hooks/
```

## 1. Esivaatimukset
| Työkalu | Miksi | Tarkistus |
|---|---|---|
| Python 3.10+ ja `uv` | Robot Framework, rf-mcp | `python3 --version`, `uv --version` |
| Node.js 20+ LTS | Browser Library (Playwright), Appium, appium-mcp | `node --version` |
| VS Code + Claude Code -laajennus + RobotCode | IDE (`.vscode/extensions.json`) | |
| Claude Code CLI | `claude`-komento terminaalissa | `claude --version` |
| Android Studio: SDK, emulaattori, Java 17 | Android-emulaattori, adb | `adb version` |

> **Jos sinulla on Windows-käyttöjärjestelmä:** komennot alla ovat bashia (macOS/Linux/Git Bash). Asenna ja aseta ympäristö ensin kohdan [Windows 11](#windows-11) PowerShell-ohjeilla.

## 2. Robot Framework -ympäristö
```bash
python3 -m venv .venv && source .venv/bin/activate     # Windows: .venv\Scripts\activate
pip install -r requirements.txt
rfbrowser init chromium          # Playwright-selain Browser Librarylle
```
`scripts/aja.sh` ja hookit käyttävät `.venv`:iä automaattisesti, vaikka sitä ei olisi aktivoitu.
Aktivoi venv silti ennen `claude`-komentoa, jotta Clauden omat Bash-komennot näkevät saman ympäristön.

## 3. Appium (robot-ajoja varten)
```bash
npm install -g appium
appium driver install uiautomator2
appium                            # jätä käyntiin omaan terminaaliin (portti 4723)
```

## 4. Android-emulaattori ja Yle-sovellus
```bash
emulator -list-avds
emulator -avd <AVD-nimi>          # esim. Pixel_7_API_34, Google Play -imagella
adb devices                       # -> emulator-5554
```
Asenna **Yle**-sovellus (uutiset) emulaattorin Play Storesta. Avaa sovellus kerran käsin ja aja
`scripts/selvita_android_paketti.sh` → kirjaa `APP_PACKAGE` ja `APP_ACTIVITY` tiedostoon
`resources/native_android/devices/emulator-5554.py`.

> **Huom:** yle.fi:llä ja Yle-sovelluksella ei ole julkista testiympäristöä, joten testit ajetaan
> tuotantoa vasten (`EXEC_ENV=TEST` osoittaa https://yle.fi:hin). Käytä vain koulutuksen testitunnusta.

## 5. MCP-palvelimet
```bash
uv tool install "rf-mcp[all]"     # robotmcp-komento PATHiin (Browser, Selenium, Appium, Requests…)
robotmcp init --browsers          # Playwright-selaimet rf-mcp:n omaan ympäristöön
robotmcp doctor -C .              # tarkistaa mitä projektin kirjastoja rf-mcp näkee
```
**Suositus:** aja venv aktiivisena projektikansiossa `robotmcp install --agents claude-code`,
jolloin rf-mcp käyttää samaa Robot Framework- ja Browser-versiota kuin `scripts/aja.sh`.
Tarkista sen jälkeen, että `.mcp.json`:ssa on vain yksi `robotmcp`-merkintä.

appium-mcp käynnistyy automaattisesti `npx`:llä `.mcp.json`:n kautta; se tarvitsee vain
`ANDROID_HOME`-muuttujan. Vaihtoehtoisesti `robotmcp install --agents claude-code` projektikansiossa
kirjoittaa rf-mcp:n käynnistyksen, joka näkee myös projektin oman Python-ympäristön.

## 6. Tunnukset ja tarkistus
```bash
cp .env.example .env && $EDITOR .env && source .env
scripts/tarkista_ymparisto.sh
```

## 7. Claude Code
```bash
code .            # VS Code; avaa Claude Code -paneeli, tai terminaalissa: claude
```
Claude Codessa: `/mcp` (molemmat palvelimet "connected"), `/permissions`, `/agents`, `/hooks`.
Hyväksy projektin MCP-palvelimet, kun Claude Code kysyy ensimmäisellä kerralla.

Projektin omat komennot:
| Komento | Tekee |
|---|---|
| `/tutki-web kirjautuminen` | tutkii näkymän rf-mcp:llä, palauttaa vahvistetut lokaattorit |
| `/tutki-android kirjautuminen` | sama Android-emulaattorille appium-mcp:llä |
| `/uusi-testi tests/basic_suite_setup/article.robot` | suunnitelma → tutkimus → toteutus kaikille alustoille → ajo |
| `/aja web` / `/aja android` | ajaa ja analysoi epäonnistumiset |
| `/katselmoi` | `rakenne-katselmoija`-subagentti tarkistaa muutokset sääntöjä vasten |

## 8. Ajaminen ilman Claudea
```bash
scripts/aja.sh web
scripts/aja.sh android
scripts/aja.sh api                                                 # API-testitaso (tests/api/), ei selainta eikä laitetta
scripts/aja.sh web --dryrun                                        # pelkkä rakennetarkistus
```
Vastaa muotoa: `robot --variable OS:androidtv --variable DEVICE:emulator-5554 --include androidtv_test --variable MAIN_OR_SUB:main --variable EXEC_ENV:TEST tests/`

## Windows 11
Komennot ajetaan **PowerShellissä**. Ympäristömuuttujien asettamisen jälkeen sulje *kaikki*
terminaalit ja **käynnistä VS Code uudelleen** – muuten VS Code, Claude Code ja MCP-palvelimet
näkevät vanhat arvot.

### Työkalut
```powershell
winget install Git.Git Python.Python.3.12 OpenJS.NodeJS.LTS astral-sh.uv
winget install Google.AndroidStudio EclipseAdoptium.Temurin.17.JDK
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned   # sallii .ps1-skriptit ja venvin aktivoinnin
uv tool update-shell                                  # uv-työkalut (robotmcp) PATHiin
```
Claude Code käyttää Windowsilla Git Bashia, joten Git for Windows tarvitaan joka tapauksessa.

### Android SDK ääkköstä sisältävällä käyttäjänimellä
Jos käyttäjänimessä on ä/ö/å (esim. `C:\Users\MattiMäki`), **Android-emulaattori kaatuu**,
kun SDK tai AVD:t ovat käyttäjäkansion alla. Käytä ASCII-polkuja (suositus kaikille):

1. Android Studion ensimmäisessä käynnistyksessä valitse SDK-sijainniksi `C:\Android\Sdk`
   (jälkikäteen: *Settings → Languages & Frameworks → Android SDK → Android SDK Location*).
2. Aseta muuttujat ja PATH:
```powershell
$sdk = "C:\Android\Sdk"
New-Item -ItemType Directory -Force C:\Android\avd | Out-Null
[Environment]::SetEnvironmentVariable("ANDROID_HOME", $sdk, "User")
[Environment]::SetEnvironmentVariable("ANDROID_SDK_ROOT", $sdk, "User")
[Environment]::SetEnvironmentVariable("ANDROID_AVD_HOME", "C:\Android\avd", "User")
$jdk = (Get-ChildItem "C:\Program Files\Eclipse Adoptium" -Directory | Where-Object Name -like "jdk-17*" | Select-Object -First 1).FullName
[Environment]::SetEnvironmentVariable("JAVA_HOME", $jdk, "User")   # Appium UiAutomator2 tarvitsee
$p = [Environment]::GetEnvironmentVariable("Path", "User")
[Environment]::SetEnvironmentVariable("Path", "$p;$sdk\platform-tools;$sdk\emulator;$jdk\bin", "User")
```
3. Luo AVD vasta tämän jälkeen (Device Manager → Pixel 7, API 34, Google Play).

Jos SDK on jo asennettu `%LOCALAPPDATA%\Android\Sdk`:hen, siirrä se (Android Studio ja emulaattori kiinni):
`adb kill-server; robocopy "$env:LOCALAPPDATA\Android\Sdk" C:\Android\Sdk /E /MOVE /NFL /NDL`,
korjaa PATH vastaavasti ja luo AVD uudelleen.

Tarkistus uudessa terminaalissa: `java -version` (17), `adb version`, `emulator -accel-check`
(`accel ok`; jos ei, ota käyttöön *Windows Hypervisor Platform*), `emulator -list-avds`.

### Robot Framework -ympäristö
```powershell
python -m venv .venv
.venv\Scripts\Activate.ps1
pip install -r requirements.txt
rfbrowser init chromium
```

### Tunnukset
`.env` + `source` toimii vain yhdessä Git Bash -ikkunassa, eikä VS Code tai Claude Code näe sitä.
Aseta tunnukset käyttäjän ympäristömuuttujiksi. Salasana kysytään piilotettuna, joten se ei jää
PowerShellin komentohistoriaan:
```powershell
[Environment]::SetEnvironmentVariable("YLE_USER", "<Yle Tunnus -sähköposti>", "User")
$s = Read-Host "YLE_PASSWORD" -AsSecureString
[Environment]::SetEnvironmentVariable("YLE_PASSWORD", [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($s)), "User")
```

### Ajaminen ja skriptit
`scripts\aja.ps1` on `aja.sh`:n PowerShell-vastine:
```powershell
scripts\aja.ps1 web
scripts\aja.ps1 android
scripts\aja.ps1 api
scripts\aja.ps1 web --dryrun
```
Muut skriptit (`tarkista_ymparisto.sh`, `selvita_android_paketti.sh`) ajetaan Git Bashilla:
```powershell
& "$env:ProgramFiles\Git\bin\bash.exe" scripts/tarkista_ymparisto.sh
& "$env:ProgramFiles\Git\bin\bash.exe" scripts/selvita_android_paketti.sh
```
Kohtien 3 (Appium), 5 (MCP) ja 7 (Claude Code) komennot toimivat PowerShellissä sellaisenaan.

## Repon tila
Rakenne, testit ja keywordit ovat valmiit ja läpäisevät `--dryrun`-tarkistuksen kaikilla alustoilla.
API-testitasolla `tests/api/latest_news.robot` on valmis, vihreä esimerkki RSS-syötteen testauksesta.
`UI_ids.py`-tiedostojen `TODO`-lokaattorit vahvistetaan tarkoituksella koulutuksen demossa
MCP-työkaluilla (`/tutki-web`, `/tutki-android`) – se on demon ydin.
