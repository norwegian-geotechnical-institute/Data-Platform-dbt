with int_hours as (
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
        cost_price
    from {{ ref('int_hours') }}
),

with_calcs as (
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
        date_trunc('month', entry_date)          as entry_month,
        date_trunc('month', finance_entry_date)  as finance_entry_month,
        entry_text,
        number_registered                        as hours,
        billing_price_reg_base                   as revenue,
        billing_price_up_down_base               as revenue_adjustment,
        cost_price                               as cost
    from int_hours
)

select * from with_calcs