select *
from {{ ref('dim_project_task') }}
where task_key is null
   or job_number is null
   or not (trim(cast(job_number as string)) rlike '^[0-9]{8}$')
   or task_name is null
