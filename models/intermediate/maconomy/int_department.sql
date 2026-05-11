with stage as (
    select
        department_name,
        department_description,
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
        try_cast(location_name as int) as location_id,
        try_cast(department_name as int) as sub_department_id,
        department_description as sub_department_name,
        try_cast(omradenr as int) as omrade_id,
        omradename as omrade_name,
        try_cast(departmentnr as int)  as department_id,
        source_system      as sys_source_system,
        source_object      as sys_source_object
    from stage
)

select * from typed