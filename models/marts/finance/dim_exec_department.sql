with int_department as (
    select
        department_id,
        department_name,
        area_id
    from {{ ref('int_department') }}
    where sub_department_name != 'Default'
),

int_area as (
    select
        area_id,
        area_name
    from {{ ref('int_area') }}
),

joined as (
    select
        dept.department_id,
        case
            when dept.department_id = 607 then 'NGI Digital'
            when dept.department_id = 305 then 'Naturfare Trondheim'
            else replace(dept.department_name, ' - Leiested', '')
        end as department_name,
        dept.area_id,
        area.area_name
    from int_department as dept
    left join int_area as area
        on dept.area_id = area.area_id
),

deduplicated as (
    select
        department_id,
        department_name,
        area_id,
        area_name
    from joined
    qualify row_number() over (
        partition by department_id
        order by area_id
    ) = 1
)

select * from deduplicated