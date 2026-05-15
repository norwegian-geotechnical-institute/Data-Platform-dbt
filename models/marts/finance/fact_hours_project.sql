with int_hours as (
    select
        job_id,
        transaction_number,
        activity_id,
        entry_date,
        finance_entry_date,
        location_id,
        entry_text,
        number_registered_qty,
        billing_price_reg_base_amt,
        billing_price_up_down_base_amt,
        cost_price_amt,
        scenario
    from {{ ref('int_hours_project') }}
),

-- Conflict case 1: activity 100 → two output rows
revenue_hours_sold as (
    select
        job_id,
        transaction_number,
        activity_id,
        entry_date,
        finance_entry_date,
        location_id,
        entry_text,
        scenario,
        'Revenue hours sold'        as pl_report,
        billing_price_reg_base_amt  as amount
    from int_hours
    where activity_id = 100
),

cost_hours_billable_projects as (
    select
        job_id,
        transaction_number,
        activity_id,
        entry_date,
        finance_entry_date,
        location_id,
        entry_text,
        scenario,
        'Cost of hours worked at billable projects'  as pl_report,
        cost_price_amt                  as amount
    from int_hours
    where activity_id = 100
),

-- Conflict case 2: activity 900, 906, 908, 910 → two output rows
revenue_external_parties as (
    select
        job_id,
        transaction_number,
        activity_id,
        entry_date,
        finance_entry_date,
        location_id,
        entry_text,
        scenario,
        'Revenue from external parties'  as pl_report,
        billing_price_reg_base_amt  as amount
    from int_hours
    where activity_id in (900, 906, 908, 910)
        and transaction_number <> 102481307
),

cost_external_parties as (
    select
        job_id,
        transaction_number,
        activity_id,
        entry_date,
        finance_entry_date,
        location_id,
        entry_text,
        scenario,
        'Cost from external parties'  as pl_report,
        cost_price_amt           as amount
    from int_hours
    where activity_id in (900, 906, 908, 910)
),

-- Non-conflict cases: each input row produces one output row
single_category_rows as (
    select
        job_id,
        transaction_number,
        activity_id,
        entry_date,
        finance_entry_date,
        location_id,
        entry_text,
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
        end as amount
    from int_hours
    where activity_id in (102, 103, 104, 105, 115, 116, 113, 114)
        or billing_price_up_down_base_amt <> 0
),

combined as (
    select * from revenue_hours_sold
    union all
    select * from cost_hours_billable_projects
    union all
    select * from revenue_external_parties
    union all
    select * from cost_external_parties
    union all
    select * from single_category_rows
)

select * from combined