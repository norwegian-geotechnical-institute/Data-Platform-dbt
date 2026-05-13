with int_finance as (
    select
        transaction_number,
        account_id,
        activity_id,
        entry_date,
        posting_date,
        location_id,
        sub_department_id,
        entry_text,
        debit_base_amt,
        credit_base_amt
    from {{ ref('int_finance_project') }}
),

with_calcs as (
    select
        transaction_number,
        account_id,
        activity_id,
        entry_date,
        posting_date,
        location_id,
        sub_department_id,
        entry_text,
        debit_base_amt,
        credit_base_amt,
        coalesce(credit_base_amt, 0) - coalesce(debit_base_amt, 0)  as salesprice

    from int_finance
)

select * from with_calcs