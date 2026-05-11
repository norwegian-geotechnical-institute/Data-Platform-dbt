with stage as (
    select
        location_name,
        location_description,
        source_system,
        source_object
    from {{ ref('stg_maconomy_location') }}
),

typed as (
    select
        try_cast(location_name as int) as location_id,
        location_description as location_name,
        source_system,
        source_object
    from stage
)

select * from typed