select *
from {{ ref('fact_project_time_actuals') }}
where job_entry_instance_key is null
   or job_number is null
   or not (trim(cast(job_number as string)) rlike '^[0-9]{8}$')
   or entry_date is null
   or entry_year is null
   or entry_month_number is null
   or entry_year_month is null
