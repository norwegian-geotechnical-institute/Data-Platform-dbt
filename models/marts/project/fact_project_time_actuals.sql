with entries as (
    select *
    from {{ ref('int_job_entry_enriched') }}
)

select
    job_entry_row_id,
    job_entry_instance_key,
    job_number,
    entry_number,
    transaction_number,
    task_name,
    task_description,
    concat(job_number, '-', coalesce(task_name, '')) as task_key,
    activity_number,
    activity_type,
    employee_number,
    employee_name,
    supplier_number,
    number_registered_qty,
    billing_price_reg_base_amt,
    cost_price_reg_amt,
    location_name,
    entry_text,
    entry_date,
    year(entry_date) as entry_year,
    month(entry_date) as entry_month_number,
    date_format(entry_date, 'yyyy-MM') as entry_year_month,
    project_manager_number,
    project_manager_name,
    job_name,
    customer_number,
    customer_name,
    customer_popup_1,
    project_name,
    task_list,
    project_closed,
    source_transaction_timestamp
from entries
where job_number rlike '^[0-9]{8}$'
  and activity_type = 0
  and activity_number = 100
  and entry_date is not null
