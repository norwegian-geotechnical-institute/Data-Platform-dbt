# Local dbt development scripts

Helper scripts to streamline starting a dbt development session on Windows. They handle venv activation, Azure authentication, Key Vault secret loading, and launching VS Code.

> **Note:** These scripts are written for a specific developer's setup (paths and schema name). Each developer needs to edit a few lines before using them. See [What you need to change](#what-you-need-to-change) below.

---

## Prerequisites

Before using these scripts, make sure you have:

1. **Installed** Python 3.9+, Git, VS Code, and the Azure CLI (`winget install -e --id Microsoft.AzureCLI`)
2. **Cloned** this repo somewhere on your machine
3. **Created the venv** in the repo root:
   ```powershell
   python -m venv .venv
   .venv\Scripts\Activate.ps1
   python -m pip install --upgrade pip
   python -m pip install dbt-databricks
   ```
4. **Copied** `profiles/profiles.example.yml` to `~\.dbt\profiles.yml`:
   ```powershell
   New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.dbt"
   Copy-Item profiles\profiles.example.yml "$env:USERPROFILE\.dbt\profiles.yml"
   ```
5. **Requested** the Azure role `Key Vault Secrets User` on the `kvdptestngi` vault
6. **Logged in** to Azure once: `az login`
7. **Allowed PowerShell scripts** to run (one time):
   ```powershell
   Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
   ```

---

## What you need to change

The two scripts contain values hardcoded for one developer. Edit these before running.

### `load-dbt-env.ps1`

| Line | Current value | What to change to |
|---|---|---|
| `$env:DBT_DATABRICKS_SCHEMA = "hreine"` | `hreine` | Your personal dev schema name (convention: your surname/initials, e.g. `hreine`, `jdoe`) |

The `$vault`, `$env:DBT_DATABRICKS_HOST`, `$env:DBT_DATABRICKS_HTTP_PATH`, and `$env:DBT_DATABRICKS_CATALOG` values are shared across the team and don't need to change.

### `start-dbt.ps1`

| Line | Current value | What to change to |
|---|---|---|
| `$projectPath = "C:\Projects\ngi\Data-Platform-dbt"` | A specific path | The absolute path where *you* cloned this repo |
| `$loaderPath = "$env:USERPROFILE\scripts\ngi\load-dbt-env.ps1"` | Points to a user folder | Leave as-is if you copy `load-dbt-env.ps1` to `~\scripts\ngi\`, or update to wherever you keep it |

---

## Usage

### Manual

From a PowerShell prompt:

```powershell
# Adjust path if you saved the script elsewhere
& "$env:USERPROFILE\scripts\ngi\start-dbt.ps1"
```

### Desktop shortcut (optional)

Create a desktop shortcut that runs the launcher in a new PowerShell window:

```powershell
$desktop = [Environment]::GetFolderPath("Desktop")
$ws = New-Object -ComObject WScript.Shell
$shortcut = $ws.CreateShortcut("$desktop\NGI dbt.lnk")
$shortcut.TargetPath = "powershell.exe"
$shortcut.Arguments = "-NoExit -ExecutionPolicy Bypass -File `"$env:USERPROFILE\scripts\ngi\start-dbt.ps1`""
$shortcut.WorkingDirectory = "C:\Projects\ngi\Data-Platform-dbt"
$shortcut.IconLocation = "powershell.exe,0"
$shortcut.Description = "Start NGI dbt development session"
$shortcut.Save()
```

Adjust the paths in `Arguments` and `WorkingDirectory` to match your setup.

---

## What the launcher does

Each time you run it:

1. Checks the project folder exists and `cd`s into it
2. Activates the venv
3. Verifies you're signed in to Azure (runs `az login` if not)
4. Loads Databricks credentials from Azure Key Vault into env vars
5. Verifies `dbt` is installed
6. Opens VS Code on the project folder

The shell it leaves you in has all env vars set, so `dbt debug`, `dbt run`, etc. will work immediately.

Expected output on success:

```
========================================
  NGI Data Platform - dbt session
========================================

[OK]    Project folder: C:\Projects\ngi\Data-Platform-dbt
[OK]    venv activated
[OK]    Signed in as: <your.email@fraktal.no>
[OK]    Subscription:  TEST - NGI Digital EA
[OK]    Secrets loaded (catalog=dp_test, schema=<your_schema>)
[OK]    dbt: - installed: 1.11.8
[OK]    VS Code launched
```

---

## Troubleshooting

**`cannot be loaded because running scripts is disabled`**
Run `Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned` and accept.

**`Forbidden` / `ForbiddenByRbac` when loading secrets**
You don't have `Key Vault Secrets User` role on `kvdptestngi`. Ask your Azure admin to assign it.

**`az account show` says you're not logged in**
Run `az login`. Tokens cache for hours to days before expiring.

**venv not found**
You haven't created the venv in the repo root yet. See Prerequisites step 3.

**dbt not found in PATH**
The venv isn't active, or `dbt-databricks` isn't installed in it. Activate the venv manually and check with `dbt --version`.

**Profile not found when running `dbt debug`**
`profiles.yml` isn't at `~\.dbt\profiles.yml`. See Prerequisites step 4.

**VS Code doesn't launch**
You don't have `code` on your PATH. In VS Code, press `Ctrl+Shift+P` and run "Shell Command: Install 'code' command in PATH".
