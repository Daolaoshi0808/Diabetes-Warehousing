with base as (

    select
        patient_nbr,
        encounter_id,
        age,

        -- clean race
        case
            when race = '?' or race is null then 'Caucasian'
            else race
        end as race,

        gender,
        admission_type_id,
        discharge_disposition_id,
        admission_source_id,

        time_in_hospital,
        num_lab_procedures,
        num_procedures,
        num_medications,
        number_outpatient,
        number_emergency,
        number_inpatient,
        number_diagnoses,

        -- medications
        metformin,
        insulin,
        glyburide,
        glipizide,
        rosiglitazone,

        readmitted,

        -- numeric conversion for ICD codes
        try_to_number(diag_1) as diag1_num,
        try_to_number(diag_2) as diag2_num,
        try_to_number(diag_3) as diag3_num

    from {{ source('diabetes_src', 'DIABETIC_DATA') }}
),

diag_categorized as (
    select
        *,
        {{ diag_category('diag1_num') }} as diag1_cat,
        {{ diag_category('diag2_num') }} as diag2_cat,
        {{ diag_category('diag3_num') }} as diag3_cat
    from base
)

select *
from diag_categorized
