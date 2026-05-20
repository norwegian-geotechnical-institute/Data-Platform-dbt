with source as (
    select
        rowid,
        instancekey,
        entityname,
        description,
        blocked,
        locationname,
        specification3name,
        statistic1,
        statistic2,
        transactiontimestamp,
        ingested_at,
        ingestion_run_id,
        source_system,
        source_object
    from {{ source('maconomy', 'entity') }}
),

renamed as (
    select
        rowid                  as department_row_id,
        instancekey            as department_instance_key,
        entityname             as department_name,
        description            as department_description,
        cast(blocked as boolean) as is_blocked,
        locationname           as location_name,
        specification3name     as departmentnr,
        statistic1             as omradenr,
        statistic2             as omradename,
        transactiontimestamp   as source_transaction_timestamp,
        ingested_at            as ingested_at,
        ingestion_run_id       as ingestion_run_id,
        source_system          as source_system,
        source_object          as source_object
    from source
)

select * from renamed