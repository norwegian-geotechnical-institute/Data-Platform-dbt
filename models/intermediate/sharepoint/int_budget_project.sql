with stage as (
    select
        selskapsnummer,
        konto,
        avdeling,
        sheet,
        budget_year,
        month_number,
        budget_value,
        source_system,
        source_object
    from {{ ref('stg_sharepoint_budget_project') }}
),

typed as (
    select
        try_cast(selskapsnummer as int)     as department_id,
        try_cast(konto as int)     as account_id,
        try_cast(avdeling as int)  as sub_department_id,
        sheet,
        make_date(budget_year, month_number, 1) as budget_date,
        budget_value,
        source_system    as sys_source_system,
        source_object    as sys_source_object
    from stage
)

select * from typed