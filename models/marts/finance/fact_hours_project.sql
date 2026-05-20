with hours_actual as (
    select
        scenario,
        number_registered_qty as hours_qty,
        entry_date,
        finance_entry_date,
        job_id,
        transaction_number,
        activity_id,
        cast(null as int) as account_id,
        location_id,
        cast(null as int) as sub_department_id,
        cast(null as int) as department_id,
        entry_text
    from {{ ref('int_hours_project') }}
),

hours_budget as (
    select
        scenario,
        budget_value as hours_qty,
        budget_date as entry_date,
        cast(null as date) as finance_entry_date,
        cast(null as int) as job_id,
        cast(null as int) as transaction_number,
        cast(null as int) as activity_id,
        account_id,
        cast(sub_department_id as int) as location_id,
        sub_department_id,
        department_id,
        cast(null as string) as entry_text
    from {{ ref('int_budget_project') }}
    where sheet = 'timer'
),

combined as (
    select * from hours_actual
    union all
    select * from hours_budget
)

select * from combined