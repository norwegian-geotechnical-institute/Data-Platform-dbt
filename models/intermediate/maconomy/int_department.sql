with stage as (
    select
        department_instance_key,
        department_name,
        department_description,
        is_blocked,
        location_name,
        departmentnr,
        omradenr,
        omradename,
        source_system,
        source_object
    from {{ ref('stg_maconomy_department') }}
),

typed as (
    select
        department_instance_key,
        department_name,
        department_description,
        is_blocked,
        departmentnr,
        omradenr,
        omradename,
        location_name,
        source_system      as sys_source_system,
        source_object      as sys_source_object
    from stage
)

select * from typed