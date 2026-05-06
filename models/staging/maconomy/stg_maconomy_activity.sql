with source as (
    select
        rowid,
        activitynumber,
        activitytext,
        instancekey,
        transactiontimestamp,
        ingested_at,
        ingestion_run_id,
        source_system,
        source_object
    from {{ source('maconomy', 'activity') }}
),

renamed as (
    select
        rowid                 as activity_row_id,
        activitynumber        as activity_number,
        activitytext          as activity_text,
        instancekey           as activity_instance_key,
        transactiontimestamp  as source_transaction_timestamp,
        ingested_at,
        ingestion_run_id,
        source_system,
        source_object
    from source
)

select * from renamed