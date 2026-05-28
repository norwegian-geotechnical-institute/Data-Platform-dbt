with finance_actual as (
    select
        scenario,
        case
            when account_id = 7004 
                then 'Revenue production unit'
            when account_id = 3510 
                then 'Compensation EU'
            when account_id = 7000 
                and (sub_department_id - 1000) = entity_id 
                then 'Cost of hours worked at production unit'
            when account_id in (7001, 7002, 7005, 7006, 7007, 7008, 7009, 7010) 
                then 'Other cost production unit'
        end as pl_report,
        salesprice as amount,
        entry_date,
        posting_date,
        account_id,
        activity_id,
        sub_department_id,
        transaction_number,
        cast(null as string) as sheet
    from {{ ref('int_finance_project') }}
),

hours_revenue_sold as (
    select
        scenario,
        'Revenue hours sold' as pl_report,
        billing_price_reg_base_amt as amount,
        entry_date,
        cast(null as date) as posting_date,
        cast(null as int) as account_id,
        activity_id,
        sub_department_id,
        transaction_number,
        cast(null as string) as sheet
    from {{ ref('int_hours_project') }}
    where activity_id = 100
),

hours_cost_billable as (
    select
        scenario,
        'Cost of hours worked at billable projects' as pl_report,
        cost_price_reg_amt * -1 as amount,
        entry_date,
        cast(null as date) as posting_date,
        cast(null as int) as account_id,
        activity_id,
        sub_department_id,
        transaction_number,
        cast(null as string) as sheet
    from {{ ref('int_hours_project') }}
    where activity_id = 100
),

hours_revenue_external as (
    select
        scenario,
        'Revenue from external parties' as pl_report,
        billing_price_reg_base_amt as amount,
        entry_date,
        cast(null as date) as posting_date,
        cast(null as int) as account_id,
        activity_id,
        sub_department_id,
        transaction_number,
        cast(null as string) as sheet
    from {{ ref('int_hours_project') }}
    where activity_id in (900, 906, 908, 910)
        and transaction_number <> 102481307
        and (supplier_id is null or supplier_id <> 29999)
        and billing_price_reg_base_amt not in (212636.92, 2497000)
),

hours_cost_external as (
    select
        scenario,
        'Cost from external parties' as pl_report,
        cost_price_amt as amount,
        entry_date,
        cast(null as date) as posting_date,
        cast(null as int) as account_id,
        activity_id,
        sub_department_id,
        transaction_number,
        cast(null as string) as sheet
    from {{ ref('int_hours_project') }}
    where activity_id in (900, 906, 908, 910)
),

hours_single_category as (
    select
        scenario,
        case
            when activity_id in (102, 103, 104, 105, 115, 116) then 'Internal cost'
            when activity_id in (113, 114)                     then 'Other sales cost (Tender and R&D proposals)'
            when billing_price_up_down_base_amt <> 0           then 'Net revenue write ups / write downs'
        end as pl_report,
        case
            when activity_id in (102, 103, 104, 105, 115, 116) then cost_price_amt
            when activity_id in (113, 114)                     then cost_price_amt
            when billing_price_up_down_base_amt <> 0           then billing_price_up_down_base_amt
        end as amount,
        entry_date,
        cast(null as date) as posting_date,
        cast(null as int) as account_id,
        activity_id,
        sub_department_id,
        transaction_number,
        cast(null as string) as sheet
    from {{ ref('int_hours_project') }}
    where activity_id in (102, 103, 104, 105, 115, 116, 113, 114)
        or billing_price_up_down_base_amt <> 0
),

budget as (
    select
        scenario,
        case
            when account_id = 9025 then 'Revenue hours sold'
            when account_id = 7004 then 'Revenue production unit'
            when account_id = 3510 then 'Compensation EU'
            when account_id = 9060 then 'Net revenue write ups / write downs'
            when account_id = 9070 then 'Revenue from external parties'
            when account_id = 9044 then 'Cost of hours worked at billable projects'
            when account_id = 7000 then 'Cost of hours worked at production unit'
            when account_id in (7001, 7002) then 'Other cost production unit'
            when account_id = 9080 then 'Cost from external parties'
            when account_id in (9041, 9042) then 'Other sales cost (Tender and R&D proposals)'
            when account_id = 9043 then 'Internal cost'
        end as pl_report,
        case
            when account_id in (9025, 9060, 7004, 3510, 9070, 7000, 7001, 7002)
                then budget_value * -1
            else budget_value
        end as amount,
        budget_date as entry_date,
        cast(null as date) as posting_date,
        account_id,
        cast(null as int) as activity_id,
        cast(sub_department_id as int) as sub_department_id,
        cast(null as int) as transaction_number,
        sheet
    from {{ ref('int_budget_project') }}
),

combined as (
    select * from finance_actual
    union all
    select * from hours_revenue_sold
    union all
    select * from hours_cost_billable
    union all
    select * from hours_revenue_external
    union all
    select * from hours_cost_external
    union all
    select * from hours_single_category
    union all
    select * from budget
)

select * from combined
where pl_report is not null