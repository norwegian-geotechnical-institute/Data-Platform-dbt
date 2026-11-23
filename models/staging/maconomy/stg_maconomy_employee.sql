with source as (
    select
        rowid,
        instancekey,
        employeenumber,
        name1,
        locationname,
        entityname,
        departmentnumber,
        electronicmailaddress,
        transactiontimestamp,
        ingested_at,
        ingestion_run_id,
        source_system,
        source_object
    from {{ source('maconomy', 'employee') }}
),

renamed as (
    select
        rowid                 as employee_row_id,
        instancekey           as employee_instance_key,
        employeenumber        as employee_number,
        name1                 as employee_name,
        locationname          as location_name,
        entityname            as entity_name,
        departmentnumber      as department_number,
        electronicmailaddress as employee_email,
        transactiontimestamp  as source_transaction_timestamp,
        ingested_at,
        ingestion_run_id,
        source_system,
        source_object
    from source
)

select * from renamed

