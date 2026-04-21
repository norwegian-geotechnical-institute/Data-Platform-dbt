select
    instance_key,
    row_id,
    entity_name,
    description,
    is_blocked,
    created_by,
    created_date,
    changed_by,
    changed_date,
    transaction_timestamp
from {{ ref('stg_maconomy_entity') }}
