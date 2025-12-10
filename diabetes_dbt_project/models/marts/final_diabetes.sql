select
    patient_nbr,
    encounter_id,
    age,
    race,
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

    metformin,
    insulin,
    glyburide,
    glipizide,
    rosiglitazone,

    diag1_cat,
    diag2_cat,
    diag3_cat,

    readmitted

from {{ ref('stg_diabetes') }}
