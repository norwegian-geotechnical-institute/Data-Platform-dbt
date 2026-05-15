with int_budsjett as (
    select
        department_id,
        sub_department_id,
        account_id,
        sheet,
        budget_date,
        budget_value,
        scenario
    from {{ ref('int_budget_project') }}
),

category as (
    select
        department_id,
        sub_department_id,
        account_id,
        sheet,
        budget_date,
        budget_value,
        scenario,
        case
            when account_id = 9025 then 'Revenue hours sold'
            when account_id = 7004 then 'Revenue production unit'
            when account_id = 3510 then 'Compensation EU'
            when account_id = 9060 then 'Net revenue write ups / write downs'
            when account_id = 9070 then 'Revenue from external parties'
            when account_id = 9044 then 'Cost of hours worked at billable projects'
            when account_id = 7000 then 'Cost of hours worked at production unit'
            when account_id in (7001, 7002) then 'Other cost production unit'
            when account_id = 9080 then 'Cost from external parties'
            when account_id in (9041, 9042) then 'Other sales cost (Tender and R&D proposals)'
            when account_id = 9043 then 'Internal Cost'
        end as pl_report
    from int_budsjett
)

select * from category
where pl_report is not null