{{ config(materialized='table') }}

with base as (

    select
        ENCOUNTER_ID,
        PATIENT_NBR,
        GENDER,
        
        -- Replace '?' race with 'Caucasian'
        case 
            when RACE in ('?', '') or RACE is null then 'Caucasian'
            else RACE
        end as RACE,

        AGE,
        TIME_IN_HOSPITAL,
        NUM_PROCEDURES,
        NUM_MEDICATIONS,
        NUMBER_DIAGNOSES,

        -- Readmission fact
        READMITTED,

        -- Medication indicators
        METFORMIN,
        INSULIN,

        -- Categorized diagnoses
        DIAG1_CAT,
        DIAG2_CAT,
        DIAG3_CAT

    from {{ ref('stg_diabetes') }}

)

select * from base
