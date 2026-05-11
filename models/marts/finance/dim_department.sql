with int_department as (
    select
        location_id,
        sub_department_id,
        sub_department_name,
        omrade_id,
        omrade_name,
        department_id
    from {{ ref('int_department') }}
),

renamed as (
    select
        location_id,
        sub_department_id,
        sub_department_name,
        omrade_id,
        omrade_name,
        department_id
    from int_department
)

select * from renamed