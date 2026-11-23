select
    task_list,
    task_name,
    count(*) as row_count
from {{ ref('int_task_list_line_current') }}
group by task_list, task_name
having count(*) > 1
