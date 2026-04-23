# NGI dbt project launcher
$ErrorActionPreference = "Continue"
$projectPath = "C:\Projects\ngi\Data-Platform-dbt"
$loaderPath  = "$env:USERPROFILE\scripts\ngi\load-dbt-env.ps1"

function Write-Step {
    param([string]$Message, [string]$Status)
    $color = switch ($Status) {
        "OK"    { "Green" }
        "FAIL"  { "Red" }
        "WARN"  { "Yellow" }
        default { "Cyan" }
    }
    $tag = if ($Status) { "[$Status]".PadRight(7) } else { "[....] " }
    Write-Host "$tag $Message" -ForegroundColor $color
}

Clear-Host
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  NGI Data Platform - dbt session" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Step "Checking project folder..."
if (Test-Path $projectPath) {
    Set-Location $projectPath
    Write-Step "Project folder: $projectPath" "OK"
} else {
    Write-Step "Project folder not found: $projectPath" "FAIL"
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Step "Activating virtual environment..."
$activateScript = Join-Path $projectPath ".venv\Scripts\Activate.ps1"
if (Test-Path $activateScript) {
    & $activateScript
    Write-Step "venv activated" "OK"
} else {
    Write-Step "venv not found at $activateScript" "FAIL"
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Step "Checking Azure authentication..."
$azAccount = az account show 2>$null | ConvertFrom-Json
$tokenTest = az account get-access-token --query expiresOn -o tsv 2>$null
if ($azAccount -and $tokenTest) {
    Write-Step "Signed in as: $($azAccount.user.name)" "OK"
    Write-Step "Subscription:  $($azAccount.name)" "OK"
} else {
    Write-Step "Not signed in to Azure. Running az login..." "WARN"
    az login | Out-Null
    $azAccount = az account show 2>$null | ConvertFrom-Json
    if ($azAccount) {
        Write-Step "Signed in as: $($azAccount.user.name)" "OK"
    } else {
        Write-Step "Azure login failed" "FAIL"
        Read-Host "Press Enter to exit"
        exit 1
    }
}

Write-Step "Loading secrets from Key Vault..."
if (Test-Path $loaderPath) {
    . $loaderPath
    if ($env:DBT_DATABRICKS_CLIENT_SECRET) {
        Write-Step "Secrets loaded (catalog=$env:DBT_DATABRICKS_CATALOG, schema=$env:DBT_DATABRICKS_SCHEMA)" "OK"
    } else {
        Write-Step "Secret loader ran but CLIENT_SECRET is empty" "FAIL"
        Write-Step "Check Key Vault RBAC access (Key Vault Secrets User role)" "WARN"
    }
} else {
    Write-Step "Loader not found: $loaderPath" "FAIL"
}

Write-Step "Checking dbt..."
$dbtVersion = (dbt --version 2>&1 | Select-String "installed:" | Select-Object -First 1).ToString().Trim()
if ($dbtVersion) {
    Write-Step "dbt: $dbtVersion" "OK"
} else {
    Write-Step "dbt not found in PATH" "FAIL"
}

Write-Step "Opening VS Code..."
code $projectPath
Write-Step "VS Code launched" "OK"

Write-Host ""
if ($env:DBT_DATABRICKS_CLIENT_SECRET) {
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "  Ready. Secrets loaded." -ForegroundColor Green
    Write-Host "  Run dbt debug to test the connection." -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
} else {
    Write-Host "========================================" -ForegroundColor Yellow
    Write-Host "  Setup incomplete. Secrets not loaded." -ForegroundColor Yellow
    Write-Host "  dbt commands will fail until RBAC is fixed." -ForegroundColor Yellow
    Write-Host "========================================" -ForegroundColor Yellow
}
Write-Host ""
