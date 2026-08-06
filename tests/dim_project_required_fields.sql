select *
from {{ ref('dim_project') }}
where job_number is null
   or not (trim(cast(job_number as string)) rlike '^[0-9]{8}$')
