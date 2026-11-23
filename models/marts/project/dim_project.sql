with job_headers as (
    select
        job_header_instance_key,
        trim(cast(job_number as string)) as job_number,
        job_name,
        project_name,
        job_group,
        job_status,
        blocked_for_time_registrations,
        customer_number,
        customer_name,
        customer_popup_1,
        country,
        language,
        created_date,
        starting_date,
        expected_ending_date,
        actual_ending_date,
        project_closed,
        internal_job,
        task_list,
        trim(cast(project_manager_number as string)) as project_manager_number,
        company_number,
        location_name,
        source_transaction_timestamp
    from {{ ref('int_job_header_current') }}
),

employees as (
    select
        trim(cast(employee_number as string)) as employee_number,
        employee_name
    from {{ ref('int_employee_current') }}
),

scoped as (
    select
        jh.*,
        pm.employee_name as project_manager_name
    from job_headers jh
    left join employees pm
        on jh.project_manager_number = pm.employee_number
    where jh.job_number rlike '^[0-9]{8}$'
)

select
    job_number,
    job_name,
    project_name,
    job_group,
    job_status,
    blocked_for_time_registrations,
    customer_number,
    customer_name,
    customer_popup_1,
    country,
    language,
    coalesce(try_to_date(created_date, 'yyyy.MM.dd'), try_to_date(created_date, 'yyyy-MM-dd')) as created_date,
    coalesce(try_to_date(starting_date, 'yyyy.MM.dd'), try_to_date(starting_date, 'yyyy-MM-dd')) as starting_date,
    coalesce(try_to_date(expected_ending_date, 'yyyy.MM.dd'), try_to_date(expected_ending_date, 'yyyy-MM-dd')) as expected_ending_date,
    coalesce(try_to_date(actual_ending_date, 'yyyy.MM.dd'), try_to_date(actual_ending_date, 'yyyy-MM-dd')) as actual_ending_date,
    project_closed,
    internal_job,
    task_list,
    project_manager_number,
    project_manager_name,
    company_number,
    location_name,
    source_transaction_timestamp
from scoped
