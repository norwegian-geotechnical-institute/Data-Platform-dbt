select fact.job_number
from {{ ref('fact_project_time_actuals') }} fact
left join {{ ref('dim_project') }} project
    on fact.job_number = project.job_number
where project.job_number is null

