with stage as (
    select
        activity_number,
        activity_text,
        source_system,
        source_object
    from {{ ref('stg_maconomy_activity') }}
),

typed as (
    select
        try_cast(activity_number as int)  as activity_id,
        activity_text as activity_name,
        source_system      as sys_source_system,
        source_object      as sys_source_object
    from stage
)

select * from typed