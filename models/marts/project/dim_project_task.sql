with projects as (
    select
        job_number,
        task_list
    from {{ ref('dim_project') }}
),

task_list_lines as (
    select
        trim(cast(task_list as string)) as task_list,
        trim(cast(task_name as string)) as task_name,
        task_description,
        try_cast(nullif(trim(cast(activity_number as string)), '') as int) as activity_number,
        try_cast(nullif(trim(cast(activity_type as string)), '') as int) as activity_type,
        is_blocked,
        can_be_used_for_time_registration,
        allow_time_registration,
        task_list_line_instance_key,
        source_transaction_timestamp
    from {{ ref('int_task_list_line_current') }}
),

joined as (
    select
        p.job_number,
        tll.task_list,
        tll.task_name,
        concat(p.job_number, '-', coalesce(tll.task_name, '')) as task_key,
        tll.task_description,
        tll.activity_number,
        tll.activity_type,
        tll.is_blocked,
        tll.can_be_used_for_time_registration,
        tll.allow_time_registration,
        tll.source_transaction_timestamp
    from projects p
    inner join task_list_lines tll
        on trim(cast(p.task_list as string)) = tll.task_list
    where tll.task_name is not null
)

select
    task_key,
    job_number,
    task_list,
    task_name,
    task_description,
    activity_number,
    activity_type,
    is_blocked,
    can_be_used_for_time_registration,
    allow_time_registration,
    source_transaction_timestamp
from joined
