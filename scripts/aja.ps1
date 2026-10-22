# Käyttö: scripts\aja.ps1 web|android|api [lisäargumentit robotille, esim. --dryrun tai --include smoke]
# PowerShell-vastine scripts/aja.sh:lle (Windows). Pidä nämä kaksi samassa linjassa.
# Ympäristömuuttujilla voi ohittaa oletukset: DEVICE, MAIN_OR_SUB, EXEC_ENV
# web ja android ajavat käyttöliittymätestit (tests/), api oman testitasonsa (tests/api/).
Set-Location (Split-Path $PSScriptRoot -Parent) -ErrorAction Stop

$Platform = if ($args.Count -gt 0) { $args[0] } else { "web" }
$RobotArgs = @(if ($args.Count -gt 1) { $args[1..($args.Count - 1)] })

switch ($Platform) {
    "web"     { $OS = "web";            $DefaultDevice = "chromium_desktop";   $Tag = "web_test" }
    "android" { $OS = "native_android"; $DefaultDevice = "emulator-5554"; $Tag = "native_android_test" }
    "api"     { $Tag = "api_test" }
    default   { Write-Host "Tuntematon alusta: $Platform (web|android|api)"; exit 1 }
}
$ExecEnv = if ($env:EXEC_ENV) { $env:EXEC_ENV } else { "TEST" }

if ($Platform -eq "api") {
    $Target = "tests/api/"
    $Vars = @()
} else {
    $Target = "tests/"
    $Device    = if ($env:DEVICE)      { $env:DEVICE }      else { $DefaultDevice }
    $MainOrSub = if ($env:MAIN_OR_SUB) { $env:MAIN_OR_SUB } else { "main" }
    $Vars = @("--variable", "OS:$OS", "--variable", "DEVICE:$Device", "--variable", "MAIN_OR_SUB:$MainOrSub")
}

# Käytä projektin venviä automaattisesti, vaikka sitä ei olisi aktivoitu
if (Test-Path ".venv\Scripts\robot.exe") { $Robot = ".venv\Scripts\robot.exe" }
else { $Robot = "robot"; Write-Warning "Huom: .venv puuttuu, käytetään PATHin robot-komentoa" }

# Browser kirjoittaa playwright-log.txt:n outputdiriin; robot ei luo sitä, jos --output/--log/--report ovat NONE
New-Item -ItemType Directory -Force "results\$Platform" | Out-Null

& $Robot `
    @Vars `
    --variable "EXEC_ENV:$ExecEnv" `
    --include $Tag `
    --exclude wip `
    --outputdir "results\$Platform" `
    @RobotArgs $Target
exit $LASTEXITCODE
