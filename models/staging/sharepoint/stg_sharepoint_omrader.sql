with source as (
    select
        `områdeid`,
        `områdenavn`,
        source_system,
        source_object
    from {{ source('sharepoint', 'omrader') }}
),

renamed as (
    select
        `områdeid`     as omrade_id,
        `områdenavn`   as omrade_name,
        source_system,
        source_object
    from source
)

select * from renamed