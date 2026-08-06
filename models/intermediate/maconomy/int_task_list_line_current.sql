with task_list_lines as (
    select
        *,
        trim(cast(task_list as string)) as task_list_key,
        trim(cast(task_name as string)) as task_name_key
    from {{ ref('stg_maconomy_tasklistline') }}
),

ranked as (
    select
        *,
        row_number() over (
            partition by task_list_key, task_name_key
            order by source_transaction_timestamp desc nulls last,
                     ingested_at desc nulls last,
                     task_list_line_instance_key desc
        ) as row_rank
    from task_list_lines
    where task_list_key is not null
      and task_list_key != ''
      and task_name_key is not null
      and task_name_key != ''
)

select
    task_list_line_row_id,
    task_list_line_instance_key,
    task_list_key as task_list,
    task_name_key as task_name,
    task_description,
    activity_number,
    activity_type,
    is_blocked,
    can_be_used_for_time_registration,
    allow_time_registration,
    source_transaction_timestamp,
    ingested_at,
    ingestion_run_id,
    source_system,
    source_object
from ranked
where row_rank = 1
