with source as (
    select
        rowid,
        instancekey,
        jobnumber,
        jobgroup,
        status,
        blockedfortimeregistrations,
        customernumber,
        name1,
        country,
        language,
        createddate,
        startingdate,
        expectedendingdate,
        actualendingdate,
        closed,
        jobname,
        internaljob,
        tasklist,
        customerpopup1,
        projectmanagernumber,
        companynumber,
        locationname,
        projectname,
        transactiontimestamp,
        ingested_at,
        ingestion_run_id,
        source_system,
        source_object
    from {{ source('maconomy', 'jobheader') }}
),

renamed as (
    select
        rowid                       as job_header_row_id,
        instancekey                 as job_header_instance_key,
        jobnumber                   as job_number,
        jobgroup                    as job_group,
        status                      as job_status,
        blockedfortimeregistrations as blocked_for_time_registrations,
        customernumber              as customer_number,
        name1                       as customer_name,
        country,
        language,
        createddate                 as created_date,
        startingdate                as starting_date,
        expectedendingdate          as expected_ending_date,
        actualendingdate            as actual_ending_date,
        closed                      as project_closed,
        jobname                     as job_name,
        internaljob                 as internal_job,
        tasklist                    as task_list,
        customerpopup1              as customer_popup_1,
        projectmanagernumber        as project_manager_number,
        companynumber               as company_number,
        locationname                as location_name,
        projectname                 as project_name,
        transactiontimestamp        as source_transaction_timestamp,
        ingested_at,
        ingestion_run_id,
        source_system,
        source_object
    from source
)

select * from renamed

