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
        case
            when dept.department_id = 607 then 606
            else dept.department_id
        end as department_id,
        case
            when dept.department_id = 607 then 'NGI Digital'
            when department_id = 305 then 'Naturfare Trondheim'
            else replace(dept.department_name, ' - Leiested', '')
        end as department_name,
        dept.area_id,
        area.area_name
    from int_department as dept
    left join int_area as area
        on dept.area_id = area.area_id
    where dept.sub_department_name != 'Default'
)

select * from joined