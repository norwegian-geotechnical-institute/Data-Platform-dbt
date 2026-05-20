with stage as (
    select
        omrade_id,
        omrade_name,
        source_system,
        source_object
    from {{ ref('stg_sharepoint_omrader') }}
),

typed as (
    select
        try_cast(omrade_id as int)  as area_id,
        omrade_name as area_name,
        source_system    as sys_source_system,
        source_object    as sys_source_object
    from stage
)

select * from typed