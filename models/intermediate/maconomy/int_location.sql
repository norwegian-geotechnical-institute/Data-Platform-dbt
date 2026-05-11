with stage as (
    select
        location_name,
        location_description
    from {{ ref('stg_maconomy_location') }}
),

typed as (
    select
        try_cast(location_name as int) as location_id,
        location_description as location_name
    from stage
)

select * from typed