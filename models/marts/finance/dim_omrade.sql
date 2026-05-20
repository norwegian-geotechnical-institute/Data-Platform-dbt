with int_omrader as (
    select
        omrade_id,
        omrade_name
    from {{ ref('int_omrader') }}
)

select
    omrade_id,
    omrade_name
from int_omrader