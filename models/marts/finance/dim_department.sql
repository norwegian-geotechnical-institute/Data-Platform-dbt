with int_department as (
    select
        sub_department_id,
        sub_department_name,
        department_id,
        department_name,
        area_id
    from {{ ref('int_department') }}
),

int_area as (
    select
        area_id,
        area_name
    from {{ ref('int_area') }}
),

joined as (
    select
        dept.sub_department_id,
        dept.sub_department_name,
        dept.department_id,
        dept.department_name,
        dept.area_id,
        area.area_name
    from int_department as dept
    left join int_area as area
        on dept.area_id = area.area_id
    where dept.sub_department_name != 'Default'
)

select * from joined