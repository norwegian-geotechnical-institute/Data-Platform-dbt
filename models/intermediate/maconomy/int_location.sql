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
        try_cast(location_name as int) as location_id,
        location_description as location_name,
        try_cast(entity_name as int) as sub_department_id,
        statistic_2 as sub_department_name,
        try_cast(specification_2_name as int) as department_id,
        source_system,
        source_object
    from stage
)

select * from typed