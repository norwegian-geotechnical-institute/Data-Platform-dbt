with stage as (
    select
        location_instance_key,
        location_name,
        location_description,
        is_blocked,
        entity_name,
        specification_2_name,
        statistic_1,
        statistic_2,
        remark_1,
        source_system,
        source_object
    from {{ ref('stg_maconomy_location') }}
),

typed as (
    select
        location_instance_key,
        location_name,
        location_description,
        is_blocked,
        specification_2_name,
        statistic_1,
        statistic_2,
        remark_1,
        entity_name,
        source_system      as sys_source_system,
        source_object      as sys_source_object
    from stage
)

select * from typed