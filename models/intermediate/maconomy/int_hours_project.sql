with stage as (
    select
        job_number,
        transaction_number,
        activity_number,
        entry_date,
        finance_entry_date,
        entry_text,
        number_registered,
        billing_price_reg_base,
        billing_price_up_down_base,
        location_name,
        supplier_number,
        cost_price,
        source_system,
        source_object
    from {{ ref('stg_maconomy_hours_project') }}
),

typed as (
    select
        try_cast(job_number as int) as job_id,
        try_cast(transaction_number as int) as transaction_number,
        try_cast(activity_number as int)      as activity_id,
        try_to_date(entry_date, 'yyyy.MM.dd') as entry_date,
        try_to_date(finance_entry_date, 'yyyy.MM.dd')  as finance_entry_date,
        entry_text,
        number_registered as number_registered_qty,
        billing_price_reg_base as billing_price_reg_base_amt,
        billing_price_up_down_base as billing_price_up_down_base_amt,
        try_cast(location_name as int) as sub_department_id,
        try_cast(supplier_number as int) as supplier_id,
        cost_price as cost_price_amt,
        source_system       as sys_source_system,
        source_object       as sys_source_object,
        'actual' as scenario
    from stage
)

select * from typed