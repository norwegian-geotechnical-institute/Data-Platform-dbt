with int_finance as (
    select
        transaction_number,
        account_id,
        activity_id,
        entry_date,
        posting_date,
        location_id,
        sub_department_id,
        entry_text,
        salesprice,
        scenario
    from {{ ref('int_finance_project') }}
),

category as (
    select
        transaction_number,
        account_id,
        activity_id,
        entry_date,
        posting_date,
        location_id,
        sub_department_id,
        entry_text,
        salesprice,
        scenario,
        case
            when account_id = 7004 
                then 'Revenue production unit'
            when account_id = 3510 
                then 'Compensation EU'
            when account_id = 7000 
                and (location_id - 1000) = sub_department_id 
                then 'Cost of hours worked at production unit'
            when account_id in (7001, 7002, 7005, 7006, 7007, 7008, 7009, 7010) 
                then 'Other cost production unit'
            else null
        end as pl_report
    from int_finance
),

final as (
    select * from category
    where pl_report is not NULL
)

select * from final