with int_location as (
    select
        location_id,
        location_name,
        sub_department_id,
        sub_department_name,
        department_id
    from {{ ref('int_location') }}
),

renamed as (
    select
        location_id,
        location_name,
        sub_department_id,
        sub_department_name,
        department_id
    from int_location

    WHERE location_name != 'Default'
)

select * from renamed