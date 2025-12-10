{{ config(materialized='table') }}

with base as (
    select
        PATIENT_NBR,

        -- Standardize race
        case 
            when RACE in ('?', '') or RACE is null then 'Caucasian'
            else RACE
        end as RACE,

        GENDER,
        AGE,
        READMITTED
    from {{ ref('stg_diabetes') }}
),

aggregated as (
    select
        PATIENT_NBR as patient_id,

        -- Demographics
        any_value(GENDER) as gender,
        any_value(RACE) as race,

        -- Age bucket
        min(AGE) as first_visit_age,

        -- Encounter-level metrics
        count(*) as num_encounters,
        count_if(READMITTED != 'NO') as num_readmissions

    from base
    group by PATIENT_NBR
)

select * from aggregated
