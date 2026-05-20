with int_department as (
    select
        sub_department_id,
        sub_department_name,
        department_id,
        department_name,
        area_id
    from {{ ref('int_department') }}
),

renamed as (
    select
        sub_department_id,
        sub_department_name,
        department_id,
        department_name,
        area_id
    from int_department
    where sub_department_name != 'Default'
)

select * from renamed