with stage as (
    select
        finance_entry_instance_key,
        transaction_number,
        line_number,
        journal_number,
        account_number,
        activity_number,
        entry_date,
        posting_date,
        location_name,
        entity_name,
        project_name,
        entry_text,
        debit_base,
        credit_base,
        source_system,
        source_object
    from {{ ref('stg_maconomy_financeentry') }}
),

typed as (
    select
        finance_entry_instance_key,
        transaction_number,
        line_number,
        journal_number,
        try_cast(account_number as int)   as account_number,
        try_cast(activity_number as int)  as activity_number,
        try_cast(entry_date as date)      as entry_date,
        try_cast(posting_date as date)    as posting_date,
        location_name,
        entity_name,
        project_name,
        entry_text,
        debit_base,
        credit_base,
        source_system      as sys_source_system,
        source_object      as sys_source_object
    from stage
)

select * from typed