with stage as (
    select
        job_entry_instance_key,
        job_number,
        entry_number,
        transaction_number,
        journal_number,
        journal_line_number,
        activity_number,
        entry_date,
        finance_entry_date,
        entry_text,
        number_registered,
        billing_price_reg_base,
        billing_price_up_down_base,
        cost_price,
        ingested_at,
        ingestion_run_id,
        source_system,
        source_object
    from {{ ref('stg_maconomy_jobentry') }}
),

typed as (
    select
        job_entry_instance_key,
        job_number,
        entry_number,
        transaction_number,
        journal_number,
        journal_line_number,
        try_cast(activity_number as int)      as activity_number,
        try_cast(entry_date as date)          as entry_date,
        try_cast(finance_entry_date as date)  as finance_entry_date,
        entry_text,
        number_registered,
        billing_price_reg_base,
        billing_price_up_down_base,
        cost_price,
        source_system       as sys_source_system,
        source_object       as sys_source_object
    from stage
)

select * from typed