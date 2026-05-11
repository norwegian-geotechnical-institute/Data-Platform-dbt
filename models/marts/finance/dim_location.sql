with int_location as (
    select
        location_id,
        location_name
    from {{ ref('int_location') }}
),

renamed as (
    select
        location_id,
        location_name
    from int_location

    WHERE location_name != 'Default'
)

select * from renamed