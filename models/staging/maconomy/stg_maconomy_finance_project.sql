with source as (
    select
        transactionnumber,
        accountnumber,
        activitynumber,
        entrydate,
        postingdate,
        locationname,
        entityname,
        customernumber,
        entrytext,
        debitbase,
        creditbase,
        ingested_at,
        ingestion_run_id,
        source_system,
        source_object
    from {{ source('maconomy', 'financeentry') }}
),

renamed as (
    select
        transactionnumber      as transaction_number,
        accountnumber          as account_number,
        activitynumber         as activity_number,
        entrydate              as entry_date,
        postingdate            as posting_date,
        locationname           as location_name,
        entityname             as entity_name,
        customernumber         as customer_number,
        entrytext              as entry_text,
        debitbase              as debit_base,
        creditbase             as credit_base,
        ingested_at,
        ingestion_run_id,
        source_system,
        source_object
    from source
)

select * from renamed