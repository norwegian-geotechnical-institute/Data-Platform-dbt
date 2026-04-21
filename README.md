# dbt Core on Databricks

This folder contains the dbt Core project for transforming landed Bronze data into the `silver` and `gold` schemas in Unity Catalog.

## What is included

- `dbt_project.yml`: dbt project configuration
- `macros/generate_schema_name.sql`: keeps dbt model schemas pinned to exact UC schemas like `silver` and `gold`
- `models/staging/maconomy/`: Bronze source definitions and first staging models
- `models/intermediate/maconomy/`: intermediate Silver models
- `models/marts/core/`: first Gold mart models
- `profiles/profiles.example.yml`: local profile template (do not commit secrets)

## Local setup

### Python version

dbt-core `1.11.x` and `dbt-databricks` `1.11.x` support Python `3.9 - 3.12`. Python `3.13` and `3.14` are **not** supported yet and will fail on import (mashumaro / typing issues). Use Python `3.12`.

### Create a virtual environment

From the repo root:

```bash
/opt/homebrew/bin/python3.12 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
pip install -r platform/dbt/requirements.txt
```

Verify:

```bash
dbt --version
```

### Authentication: OAuth M2M with a Databricks service principal

We use a Databricks-managed service principal with OAuth machine-to-machine auth (no PATs). Create the SP in the Databricks account console, generate an OAuth secret, grant it workspace + Unity Catalog + SQL Warehouse access, then set the env vars below.

See `docs/dbt-service-principal-setup.md` (or the repo README) for the end-to-end click path.

Set environment variables for the Databricks SQL Warehouse connection:

```bash
export DBT_DATABRICKS_HOST="adb-<workspace-id>.<region>.azuredatabricks.net"
export DBT_DATABRICKS_HTTP_PATH="/sql/1.0/warehouses/<warehouse-id>"
export DBT_DATABRICKS_CLIENT_ID="<sp-application-id>"
export DBT_DATABRICKS_CLIENT_SECRET="<oauth-secret>"
export DBT_DATABRICKS_CATALOG="dp_test"
export DBT_DATABRICKS_SCHEMA="silver"
```

Notes:

- `DBT_DATABRICKS_HOST` must **not** include `https://`
- `DBT_DATABRICKS_HTTP_PATH` must start with `/`
- `DBT_DATABRICKS_CLIENT_ID` is the service principal's application ID (UUID)
- Never commit `DBT_DATABRICKS_CLIENT_SECRET` - keep it in your shell profile, a local `.envrc`, or a secret manager

Copy the example profile to a local-only file:

```bash
mkdir -p ~/.dbt
cp platform/dbt/profiles/profiles.example.yml ~/.dbt/profiles.yml
```

## First commands

From `platform/dbt/`:

```bash
dbt debug
dbt parse
dbt run --select stg_maconomy_entity stg_maconomy_jobentry int_maconomy_entity dim_entity
dbt test
```

## Design notes

- Bronze stays source-aligned and retains Maconomy source casing.
- Staging models standardize names into lowercase snake case.
- Logical dbt layers map to physical schemas as follows:
  - `staging` -> `silver`
  - `intermediate` -> `silver`
  - `marts` -> `gold`
- `jobentry` is scaffolded minimally until its business grain and useful downstream fields are confirmed.
