with int_area as (
    select
        area_id,
        area_name
    from {{ ref('int_area') }}
)

select
    area_id,
    area_name
from int_area