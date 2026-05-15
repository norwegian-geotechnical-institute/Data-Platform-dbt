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
        scenario
    from {{ ref('int_hours_project') }}
)

select
    job_id,
    transaction_number,
    activity_id,
    entry_date,
    finance_entry_date,
    location_id,
    entry_text,
    number_registered_qty,
    scenario
from int_hours