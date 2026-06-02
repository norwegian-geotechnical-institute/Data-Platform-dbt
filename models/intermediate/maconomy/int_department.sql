with stage as (
    select
        location_name,
        location_description,
        entity_name,
        statistic_2,
        specification_2_name,
        source_system,
        source_object
    from {{ ref('stg_maconomy_location') }}
),

typed as (
    select
        try_cast(location_name as int) as sub_department_id,
        location_description as sub_department_name,
        try_cast(entity_name as int) as department_id,
        statistic_2 as department_name,
        (try_cast(specification_2_name as int) div 10) * 10 as area_id,
        source_system,
        source_object
    from stage
    WHERE location_description != 'Default'
)

select * from typed