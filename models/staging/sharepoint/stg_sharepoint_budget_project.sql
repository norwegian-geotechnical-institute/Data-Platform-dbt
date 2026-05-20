with source as (
    select
        selskapsnummer,
        kontotekst,
        konto,
        avdeling,
        jan, feb, mar, apr, mai, jun,
        jul, aug, sep, okt, nov, des,
        sheet,
        source_filename,
        source_system,
        source_object
    from {{ source('sharepoint', 'budsjett') }}
),

unpivoted as (
    select
        selskapsnummer,
        kontotekst,
        konto,
        avdeling,
        sheet,
        source_filename,
        source_system,
        source_object,
        stack(12,
            1, jan,
            2, feb,
            3, mar,
            4, apr,
            5, mai,
            6, jun,
            7, jul,
            8, aug,
            9, sep,
            10, okt,
            11, nov,
            12, des
        ) as (month_number, budget_value)
    from source
),

renamed as (
    select
        selskapsnummer,
        kontotekst,
        konto,
        avdeling,
        sheet,
        try_cast(substring(source_filename, 1, 4) as int) as budget_year,
        month_number,
        budget_value,
        source_filename,
        source_system,
        source_object
    from unpivoted
)

select * from renamed