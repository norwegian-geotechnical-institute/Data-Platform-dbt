select fact.task_key
from {{ ref('fact_project_time_actuals') }} fact
left join {{ ref('dim_project_task') }} task
    on fact.task_key = task.task_key
where task.task_key is null

