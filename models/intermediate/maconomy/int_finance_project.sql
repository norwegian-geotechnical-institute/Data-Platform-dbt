with stage as (
    select
        transaction_number,
        account_number,
        activity_number,
        entry_date,
        posting_date,
        location_name,
        entity_name,
        entry_text,
        debit_base,
        credit_base,
        source_system,
        source_object
    from {{ ref('stg_maconomy_finance_project') }}
),

typed as (
    select
        try_cast(transaction_number as int) as transaction_number,
        try_cast(account_number as int)   as account_id,
        try_cast(activity_number as int)  as activity_id,
        try_to_date(entry_date, 'yyyy.MM.dd') as entry_date,
        try_to_date(posting_date, 'yyyy.MM.dd')    as posting_date,
        try_cast(location_name as int) as location_id,
        try_cast(entity_name as int) as sub_department_id,
        entry_text,
        debit_base as debit_base_amt,
        credit_base as credit_base_amt,
        source_system      as sys_source_system,
        source_object      as sys_source_object
    from stage
)

select * from typed