with stage as (
    select
        account_instance_key,
        account_number,
        account_text,
        entry_account_type,
        account_group,
        profit_and_loss_status,
        department_number,
        statistic_1,
        remark_1,
        remark_3,
        source_system,
        source_object
    from {{ ref('stg_maconomy_account') }}
),

typed as (
    select
        account_instance_key,
        try_cast(account_number as int)  as account_number,
        account_text,
        entry_account_type,
        account_group,
        profit_and_loss_status,
        department_number,
        statistic_1,
        remark_1,
        remark_3,
        source_system      as sys_source_system,
        source_object      as sys_source_object
    from stage
)

select * from typed