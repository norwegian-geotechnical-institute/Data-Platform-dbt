select
    INSTANCEKEY as instance_key,
    TRANSACTIONTIMESTAMP as transaction_timestamp,
    ingested_at,
    ingestion_run_id,
    source_system,
    source_object
from {{ source('maconomy_bronze', 'jobentry') }}
