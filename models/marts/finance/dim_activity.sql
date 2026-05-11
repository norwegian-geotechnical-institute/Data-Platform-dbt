with int_activity as (
    select
        activity_id,
        activity_name
    from {{ ref('int_activity') }}
),

renamed as (
    select
        activity_id,
        activity_name
    from int_activity
)

select * from renamed