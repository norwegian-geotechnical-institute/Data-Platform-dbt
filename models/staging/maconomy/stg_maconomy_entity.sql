select
    INSTANCEKEY as instance_key,
    ROWID as row_id,
    ENTITYNAME as entity_name,
    DESCRIPTION as description,
    cast(BLOCKED as boolean) as is_blocked,
    CREATEDBY as created_by,
    CREATEDDATE as created_date,
    CHANGEDBY as changed_by,
    CHANGEDDATE as changed_date,
    TRANSACTIONTIMESTAMP as transaction_timestamp,
    ingested_at,
    ingestion_run_id,
    source_system,
    source_object
from {{ source('maconomy_bronze', 'entity') }}
