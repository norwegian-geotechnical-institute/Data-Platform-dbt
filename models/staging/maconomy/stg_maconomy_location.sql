with source as (
    select
        rowid,
        locationname,
        description,
        blocked,
        entityname,
        specification2name,
        statistic1,
        statistic2,
        remark1,
        instancekey,
        transactiontimestamp,
        ingested_at,
        ingestion_run_id,
        source_system,
        source_object
    from {{ source('maconomy', 'location') }}
),

renamed as (
    select
        rowid                  as location_row_id,
        locationname           as location_name,
        description            as location_description,
        cast(blocked as boolean) as is_blocked,
        entityname             as entity_name,
        specification2name     as specification_2_name,
        statistic1             as statistic_1,
        statistic2             as statistic_2,
        remark1                as remark_1,
        instancekey            as location_instance_key,
        transactiontimestamp   as source_transaction_timestamp,
        ingested_at,
        ingestion_run_id,
        source_system,
        source_object
    from source
)

select * from renamed