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
)

select * from renamed