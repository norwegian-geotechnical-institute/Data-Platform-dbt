with int_finance as (
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
        credit_base
    from {{ ref('int_finance') }}
),

with_calcs as (
    select
        finance_entry_instance_key,
        transaction_number,
        line_number,
        journal_number,
        account_number,
        activity_number,
        location_name,
        entity_name,
        project_name,
        entry_date,
        posting_date,
        date_trunc('month', entry_date)  as entry_month,
        entry_text,
        debit_base,
        credit_base,
        coalesce(credit_base, 0) - coalesce(debit_base, 0)  as salgspris

    from int_finance
)

select * from with_calcs