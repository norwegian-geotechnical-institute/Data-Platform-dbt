{#-
  Recreates Maconomy JobEntryJobInvoiceLinePV / EXJobEntryJobInvoiceLinePV as a
  UNION ALL of base tables. Marker 1 = JobEntry rows, marker 2 = JobInvoiceLine rows.
  See: https://help.deltek.com/Products/Maconomy/Documentation/BPMAdmin/Admin_Materialized_Views.html
-#}

with job_entry as (
    select * from {{ ref('stg_maconomy_hours_project') }}
),

job_invoice_line as (
    select * from {{ ref('stg_maconomy_jobinvoiceline') }}
),

job_entry_rows as (
    select
        job_entry_row_id,
        cast(null as bigint) as job_invoice_line_row_id,
        1 as source_marker,
        job_entry_instance_key as instance_key,
        entry_number,
        job_number,
        journal_number,
        journal_line_number,
        transaction_number,
        transaction_type,
        posting_date,
        entry_date,
        finance_entry_date,
        company_number,
        activity_number,
        activity_text,
        entry_text,
        employee_number,
        number_registered,
        cost_price,
        original_cost_price,
        markup_percentage,
        billing_price_reg_base,
        billing_price_up_down_base,
        cast(null as double) as billing_price_invoiced_base,
        cast(null as double) as billing_price_for_invoicing_base,
        cast(null as double) as billing_price_total_base,
        invoice_number,
        location_name,
        entity_name,
        project_name,
        source_transaction_timestamp,
        ingested_at,
        ingestion_run_id,
        source_system,
        source_object
    from job_entry
),

job_invoice_line_rows as (
    select
        cast(null as bigint) as job_entry_row_id,
        job_invoice_line_row_id,
        2 as source_marker,
        job_invoice_line_instance_key as instance_key,
        entry_number,
        job_number,
        journal_number,
        journal_line_number,
        transaction_number,
        transaction_type,
        posting_date,
        entry_date,
        finance_entry_date,
        company_number,
        activity_number,
        activity_text,
        entry_text,
        employee_number,
        number_registered,
        cost_price,
        original_cost_price,
        markup_percentage,
        coalesce(
            billing_price_reg_base,
            billing_price_for_invoicing_base,
            billing_price_invoiced_base,
            billing_price_total_base
        ) as billing_price_reg_base,
        billing_price_up_down_base,
        billing_price_invoiced_base,
        billing_price_for_invoicing_base,
        billing_price_total_base,
        invoice_number,
        location_name,
        entity_name,
        project_name,
        source_transaction_timestamp,
        ingested_at,
        ingestion_run_id,
        source_system,
        source_object
    from job_invoice_line
)

select * from job_entry_rows
union all
select * from job_invoice_line_rows
