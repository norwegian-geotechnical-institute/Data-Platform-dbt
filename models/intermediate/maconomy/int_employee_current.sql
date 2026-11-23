with employees as (
    select
        *,
        trim(cast(employee_number as string)) as employee_number_key
    from {{ ref('stg_maconomy_employee') }}
),

ranked as (
    select
        *,
        row_number() over (
            partition by employee_number_key
            order by source_transaction_timestamp desc nulls last,
                     ingested_at desc nulls last,
                     employee_instance_key desc
        ) as row_rank
    from employees
    where employee_number_key is not null
      and employee_number_key != ''
)

select
    employee_row_id,
    employee_instance_key,
    employee_number_key as employee_number,
    employee_name,
    employee_email,
    location_name,
    entity_name,
    department_number,
    source_transaction_timestamp,
    ingested_at,
    ingestion_run_id,
    source_system,
    source_object
from ranked
where row_rank = 1
