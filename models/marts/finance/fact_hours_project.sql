with int_hours as (
    select
        job_id,
        transaction_number,
        activity_id,
        entry_date,
        finance_entry_date,
        entry_text,
        number_registered_qty,
        billing_price_reg_base_amt,
        billing_price_up_down_base_amt,
        cost_price_amt
    from {{ ref('int_hours_project') }}
),

with_calcs as (
    select
        job_id,
        transaction_number,
        activity_id,
        entry_date,
        finance_entry_date,
        entry_text,
        number_registered_qty,
        billing_price_reg_base_amt,
        billing_price_up_down_base_amt,
        cost_price_amt
    from int_hours
)

select * from with_calcs