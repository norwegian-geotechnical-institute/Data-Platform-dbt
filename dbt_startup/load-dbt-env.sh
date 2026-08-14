#!/usr/bin/env bash
# Load local dbt environment variables for macOS/Linux shells.
#
# Usage from the Data-Platform-dbt repo:
#   source dbt_startup/load-dbt-env.sh
#   ./.venv/bin/dbt debug
#
# Override any default before sourcing, for example:
#   export DBT_DATABRICKS_SILVER_CATALOG=dpx_am
#   source dbt_startup/load-dbt-env.sh

if [[ -n "${ZSH_VERSION:-}" ]]; then
  case "${ZSH_EVAL_CONTEXT:-}" in
    *:file*) _dbt_loader_sourced=1 ;;
    *) _dbt_loader_sourced=0 ;;
  esac
elif [[ -n "${BASH_VERSION:-}" ]]; then
  if [[ "${BASH_SOURCE[0]}" != "$0" ]]; then
    _dbt_loader_sourced=1
  else
    _dbt_loader_sourced=0
  fi
else
  _dbt_loader_sourced=1
fi

if [[ "${_dbt_loader_sourced}" != "1" ]]; then
  echo "Source this script so exports remain in your shell:"
  echo "  source dbt_startup/load-dbt-env.sh"
  exit 1
fi
unset _dbt_loader_sourced

if [[ -n "${ZSH_VERSION:-}" ]]; then
  _dbt_loader_path="${(%):-%x}"
else
  _dbt_loader_path="${BASH_SOURCE[0]}"
fi

_dbt_startup_dir="$(cd "$(dirname "${_dbt_loader_path}")" && pwd)"
_dbt_project_root="$(cd "${_dbt_startup_dir}/.." && pwd)"
unset _dbt_loader_path _dbt_startup_dir

_dbt_fail() {
  echo "[FAIL] $*" >&2
  return 1
}

_dbt_ok() {
  echo "[OK] $*"
}

if [[ -f "${_dbt_project_root}/.venv/bin/activate" ]]; then
  # shellcheck disable=SC1091
  source "${_dbt_project_root}/.venv/bin/activate"
  _dbt_ok "venv activated"
else
  _dbt_fail "venv not found at ${_dbt_project_root}/.venv/bin/activate"
  unset _dbt_project_root
  return 1
fi

if ! command -v az >/dev/null 2>&1; then
  _dbt_fail "Azure CLI not found. Install Azure CLI and run az login."
  unset _dbt_project_root
  return 1
fi

if ! az account show >/dev/null 2>&1; then
  _dbt_fail "Not signed in to Azure. Run az login, then source this script again."
  unset _dbt_project_root
  return 1
fi
_dbt_ok "Azure CLI authenticated"

if ! az account get-access-token --resource https://vault.azure.net --query expiresOn --output tsv >/dev/null 2>&1; then
  _dbt_fail "Azure token for Key Vault is expired or unavailable. Run az login, then source this script again."
  unset _dbt_project_root
  return 1
fi
_dbt_ok "Azure Key Vault token available"

: "${DBT_KEY_VAULT:=kvdptestngi}"
: "${DBT_DATABRICKS_HOST:=adb-7405612986875506.6.azuredatabricks.net}"
: "${DBT_DATABRICKS_HTTP_PATH:=/sql/1.0/warehouses/6af0e104f64d67eb}"
: "${DBT_DATABRICKS_CATALOG:=dpx_am}"
: "${DBT_DATABRICKS_SCHEMA:=am}"
: "${DBT_DATABRICKS_SILVER_CATALOG:=dpx_am}"
: "${DBT_DATABRICKS_GOLD_CATALOG:=dpx_am}"
: "${DBT_DATABRICKS_CLIENT_ID_SECRET_NAME:=dbt-sp-test-client-id}"
: "${DBT_DATABRICKS_CLIENT_SECRET_SECRET_NAME:=dbt-sp-test-client-secret}"

_dbt_secret() {
  local secret_name="$1"
  local value

  if ! value="$(az keyvault secret show \
    --vault-name "${DBT_KEY_VAULT}" \
    --name "${secret_name}" \
    --query value \
    --output tsv 2>/dev/null)"; then
    _dbt_fail "Could not read Key Vault secret '${secret_name}' from '${DBT_KEY_VAULT}'. Check RBAC or override the relevant env var before sourcing."
    return 1
  fi

  if [[ -z "${value}" ]]; then
    _dbt_fail "Key Vault secret '${secret_name}' is empty."
    return 1
  fi

  printf '%s' "${value}"
}

if [[ -z "${DBT_DATABRICKS_CLIENT_ID:-}" ]]; then
  if ! DBT_DATABRICKS_CLIENT_ID="$(_dbt_secret "${DBT_DATABRICKS_CLIENT_ID_SECRET_NAME}")"; then
    unset _dbt_project_root
    return 1
  fi
  export DBT_DATABRICKS_CLIENT_ID
fi

if [[ -z "${DBT_DATABRICKS_CLIENT_SECRET:-}" ]]; then
  if ! DBT_DATABRICKS_CLIENT_SECRET="$(_dbt_secret "${DBT_DATABRICKS_CLIENT_SECRET_SECRET_NAME}")"; then
    unset _dbt_project_root
    return 1
  fi
  export DBT_DATABRICKS_CLIENT_SECRET
fi

export DBT_DATABRICKS_HOST
export DBT_DATABRICKS_HTTP_PATH
export DBT_DATABRICKS_CATALOG
export DBT_DATABRICKS_SCHEMA
export DBT_DATABRICKS_SILVER_CATALOG
export DBT_DATABRICKS_GOLD_CATALOG

_dbt_ok "Databricks dbt env loaded"
echo "      host=${DBT_DATABRICKS_HOST}"
echo "      http_path=${DBT_DATABRICKS_HTTP_PATH}"
echo "      catalog=${DBT_DATABRICKS_CATALOG}"
echo "      schema=${DBT_DATABRICKS_SCHEMA}"
echo "      silver_catalog=${DBT_DATABRICKS_SILVER_CATALOG}"
echo "      gold_catalog=${DBT_DATABRICKS_GOLD_CATALOG}"
echo ""
echo "Run:"
echo "  ./.venv/bin/dbt debug"
echo "  ./.venv/bin/dbt build --select +fact_project_time_actuals"

unset _dbt_project_root
unset -f _dbt_fail _dbt_ok _dbt_secret
