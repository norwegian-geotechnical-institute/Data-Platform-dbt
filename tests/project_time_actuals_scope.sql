select *
from {{ ref('fact_project_time_actuals') }}
where not (trim(cast(job_number as string)) rlike '^[0-9]{8}$')
   or activity_type != 0
   or activity_number != 100
