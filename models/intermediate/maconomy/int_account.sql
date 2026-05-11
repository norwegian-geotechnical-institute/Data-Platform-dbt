with stage as (
    select
        account_number,
        account_text,
        source_system,
        source_object
    from {{ ref('stg_maconomy_account') }}
),

typed as (
    select
        try_cast(account_number as int)  as account_id,
        account_text as account_name,
        source_system      as sys_source_system,
        source_object      as sys_source_object
    from stage
)

select * from typed