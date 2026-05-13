with int_budsjett as (
    select
        department_id,
        sub_department_id,
        account_id,
        sheet,
        budget_date,
        budget_value
    from {{ ref('int_budget_project') }}
),

renamed as (
    select
        department_id,
        sub_department_id,
        account_id,
        sheet,
        budget_date,
        budget_value
    from int_budsjett
)

select * from renamed