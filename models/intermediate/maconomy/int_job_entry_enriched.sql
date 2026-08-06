with job_entries as (
    select
        job_entry_row_id,
        job_entry_instance_key,
        entry_number,
        job_number,
        transaction_number,
        activity_number,
        activity_type,
        task_name,
        entry_date,
        entry_text,
        employee_number,
        supplier_number,
        number_registered,
        billing_price_reg_base,
        cost_price_reg,
        location_name,
        source_transaction_timestamp
    from {{ ref('stg_maconomy_hours_project') }}
),

job_headers as (
    select
        job_number,
        job_name,
        customer_number,
        customer_name,
        customer_popup_1,
        project_name,
        project_manager_number,
        task_list,
        project_closed
    from {{ ref('int_job_header_current') }}
),

employees as (
    select
        employee_number,
        employee_name
    from {{ ref('int_employee_current') }}
),

task_list_lines as (
    select
        task_list,
        task_name,
        task_description
    from {{ ref('int_task_list_line_current') }}
),

typed as (
    select
        je.job_entry_row_id,
        je.job_entry_instance_key,
        trim(cast(je.job_number as string)) as job_number,
        try_cast(je.entry_number as int) as entry_number,
        try_cast(je.transaction_number as int) as transaction_number,
        try_cast(nullif(trim(cast(je.activity_number as string)), '') as int) as activity_number,
        try_cast(nullif(trim(cast(je.activity_type as string)), '') as int) as activity_type,
        trim(cast(je.task_name as string)) as task_name,
        tll.task_description,
        try_to_date(je.entry_date, 'yyyy.MM.dd') as entry_date,
        je.entry_text,
        trim(cast(je.employee_number as string)) as employee_number,
        e.employee_name,
        trim(cast(je.supplier_number as string)) as supplier_number,
        je.number_registered as number_registered_qty,
        je.billing_price_reg_base as billing_price_reg_base_amt,
        je.cost_price_reg as cost_price_reg_amt,
        je.location_name,
        jh.project_manager_number,
        pm.employee_name as project_manager_name,
        jh.job_name,
        jh.customer_number,
        jh.customer_name,
        jh.customer_popup_1,
        jh.project_name,
        jh.task_list,
        jh.project_closed,
        je.source_transaction_timestamp
    from job_entries je
    left join job_headers jh
        on trim(cast(je.job_number as string)) = trim(cast(jh.job_number as string))
    left join employees e
        on trim(cast(je.employee_number as string)) = trim(cast(e.employee_number as string))
    left join employees pm
        on trim(cast(jh.project_manager_number as string)) = trim(cast(pm.employee_number as string))
    left join task_list_lines tll
        on trim(cast(jh.task_list as string)) = trim(cast(tll.task_list as string))
       and trim(cast(je.task_name as string)) = trim(cast(tll.task_name as string))
)

select
    job_entry_row_id,
    job_entry_instance_key,
    job_number,
    entry_number,
    transaction_number,
    task_name,
    task_description,
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
from typed
