with source as (
    select
        rowid,
        accountnumber,
        accounttext,
        entryaccounttype,
        accountgroup,
        profitandlossstatus,
        departmentnumber,
        statistic1,
        remark1,
        remark3,
        instancekey,
        transactiontimestamp,
        ingested_at,
        ingestion_run_id,
        source_system,
        source_object
    from {{ source('maconomy', 'account') }}
),

renamed as (
    select
        rowid                 as account_row_id,
        accountnumber         as account_number,
        accounttext           as account_text,
        entryaccounttype      as entry_account_type,
        accountgroup          as account_group,
        profitandlossstatus   as profit_and_loss_status,
        departmentnumber      as department_number,
        statistic1            as statistic_1,
        remark1               as remark_1,
        remark3               as remark_3,
        instancekey           as account_instance_key,
        transactiontimestamp  as source_transaction_timestamp,
        ingested_at,
        ingestion_run_id,
        source_system,
        source_object
    from source
)

select * from renamed