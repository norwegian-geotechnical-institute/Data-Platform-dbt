select
    instance_key as entity_key,
    row_id as entity_row_id,
    entity_name,
    description as entity_description,
    is_blocked,
    created_date,
    changed_date,
    transaction_timestamp
from {{ ref('int_maconomy_entity') }}
