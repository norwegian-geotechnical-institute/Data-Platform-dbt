with int_account as (
    select
        account_id,
        account_name

    from {{ ref('int_account') }}
),

renamed as (
    select
        account_id,
        account_name
        
    from int_account
)

select * from renamed