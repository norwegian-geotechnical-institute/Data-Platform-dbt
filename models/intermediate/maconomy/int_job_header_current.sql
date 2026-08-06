with job_headers as (
    select
        *,
        trim(cast(job_number as string)) as job_number_key
    from {{ ref('stg_maconomy_jobheader') }}
),

ranked as (
    select
        *,
        row_number() over (
            partition by job_number_key
            order by source_transaction_timestamp desc nulls last,
                     ingested_at desc nulls last,
                     job_header_instance_key desc
        ) as row_rank
    from job_headers
    where job_number_key is not null
      and job_number_key != ''
)

select
    job_header_row_id,
    job_header_instance_key,
    job_number_key as job_number,
    job_group,
    job_status,
    blocked_for_time_registrations,
    customer_number,
    customer_name,
    country,
    language,
    created_date,
    starting_date,
    expected_ending_date,
    actual_ending_date,
    project_closed,
    job_name,
    internal_job,
    task_list,
    customer_popup_1,
    project_manager_number,
    company_number,
    location_name,
    project_name,
    source_transaction_timestamp,
    ingested_at,
    ingestion_run_id,
    source_system,
    source_object
from ranked
where row_rank = 1
