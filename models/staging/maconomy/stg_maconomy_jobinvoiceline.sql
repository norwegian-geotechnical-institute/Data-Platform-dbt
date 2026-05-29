with source as (
    select
        rowid,
        instancekey,
        entrynumber,
        jobnumber,
        debitcredit,
        typeofentry,
        transactiontyperegistered,
        invoicedate,
        financeentrydate,
        companynumber,
        activitynumber,
        text,
        employeenumber,
        numberof,
        costpricetotal,
        billingpricebase,
        billingpriceupdownbase,
        billingpricetotalbase,
        invoicenumber,
        locationname,
        entityname,
        projectname,
        transactiontimestamp,
        ingested_at,
        ingestion_run_id,
        source_system,
        source_object
    from {{ source('maconomy', 'jobinvoiceline') }}
),

renamed as (
    select
        rowid                    as job_invoice_line_row_id,
        instancekey              as job_invoice_line_instance_key,
        entrynumber              as entry_number,
        jobnumber                as job_number,
        debitcredit              as debit_credit,
        cast(null as bigint)     as journal_number,
        cast(null as bigint)     as journal_line_number,
        cast(null as bigint)     as transaction_number,
        coalesce(transactiontyperegistered, typeofentry) as transaction_type,
        invoicedate              as posting_date,
        cast(null as date)       as entry_date,
        financeentrydate         as finance_entry_date,
        companynumber            as company_number,
        activitynumber           as activity_number,
        cast(null as string)     as activity_text,
        text                     as entry_text,
        employeenumber           as employee_number,
        case
            when debitcredit = 1 and coalesce(numberof, 0) = 0 then numberof
            when debitcredit = 1 then -numberof
            else numberof
        end                      as number_registered,
        case
            when debitcredit = 1 and coalesce(costpricetotal, 0) = 0 then costpricetotal
            when debitcredit = 1 then -costpricetotal
            else costpricetotal
        end                      as cost_price,
        cast(null as double)     as original_cost_price,
        cast(null as double)     as markup_percentage,
        case
            when debitcredit = 1 and coalesce(billingpricebase, 0) = 0 then billingpricebase
            when debitcredit = 1 then -billingpricebase
            else billingpricebase
        end                      as billing_price_reg_base,
        billingpriceupdownbase   as billing_price_up_down_base,
        case
            when debitcredit = 1 and coalesce(billingpricetotalbase, 0) = 0 then billingpricetotalbase
            when debitcredit = 1 then -billingpricetotalbase
            else billingpricetotalbase
        end                      as billing_price_invoiced_base,
        cast(null as double)     as billing_price_for_invoicing_base,
        case
            when debitcredit = 1 and coalesce(billingpricetotalbase, 0) = 0 then billingpricetotalbase
            when debitcredit = 1 then -billingpricetotalbase
            else billingpricetotalbase
        end                      as billing_price_total_base,
        invoicenumber            as invoice_number,
        locationname             as location_name,
        entityname               as entity_name,
        projectname              as project_name,
        transactiontimestamp     as source_transaction_timestamp,
        ingested_at,
        ingestion_run_id,
        source_system,
        source_object
    from source
)

select * from renamed
