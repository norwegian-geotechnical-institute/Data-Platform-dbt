with source as (
    select
        rowid,
        instancekey,
        tasklist,
        taskname,
        description,
        activitynumber,
        activitytype,
        blocked,
        canbeusedfortimeregistration,
        allowtimeregistration,
        transactiontimestamp,
        ingested_at,
        ingestion_run_id,
        source_system,
        source_object
    from {{ source('maconomy', 'tasklistline') }}
),

renamed as (
    select
        rowid                as task_list_line_row_id,
        instancekey          as task_list_line_instance_key,
        tasklist             as task_list,
        taskname             as task_name,
        description          as task_description,
        activitynumber       as activity_number,
        activitytype         as activity_type,
        blocked              as is_blocked,
        canbeusedfortimeregistration as can_be_used_for_time_registration,
        allowtimeregistration        as allow_time_registration,
        transactiontimestamp as source_transaction_timestamp,
        ingested_at,
        ingestion_run_id,
        source_system,
        source_object
    from source
)

select * from renamed
