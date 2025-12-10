#  **Diabetes Data Warehousing Project (Fivetran+ dbt + Snowflake + Tableau)**

This project implements a complete **modern data warehousing pipeline** using **Snowflake**, **dbt (Data Build Tool)**, and **Tableau**.
The objective is to **clean, transform, model, and visualize** a real medical dataset on hospital inpatient diabetes encounters, with a primary focus on **predictors of hospital readmission**.

---

#  **Project Architecture**

```
Extraction (Fivetran Stage)
        │
        ▼
Raw Data (Snowflake Stage)
        │
        ▼
Staging Models (stg_diabetes.sql)
        │
        ▼
Transformation & Business Logic
    ├── dim_patients.sql
    ├── fact_readmission.sql
    └── macros/diag_category.sql
        │
        ▼
Final Analytics Model  
    └── final_diabetes.sql
        │
        ▼
Export to Tableau → Interactive Dashboard
```

---

#  **Project Goals**

1. **Clean and standardize** a noisy medical dataset containing 100K+ diabetes patient encounters.
2. Create usable **dimension** and **fact models** that follow standard DW modeling practices.
3. Perform **categorization of ICD-9 diagnosis codes** into medically meaningful categories.
4. Build an **analytics-ready dataset** for Tableau.
5. Produce **visual insights** on diabetic patient readmission patterns.

---

#  **Repository Structure**

```
diabetes_dbt_project/
│
├── dbt_project.yml           # Main dbt configuration file
│
├── models/
│   ├── staging/
│   │   ├── stg_diabetes.sql          # Cleans & prepares raw data
│   │   └── src_diabetes.yml          # Source definition for Snowflake table
│   │
│   ├── marts/
│   │   ├── dim_patients.sql          # Patient demographic dimension
│   │   ├── fact_readmission.sql      # Fact table for readmission analysis
│   │   └── final_diabetes.sql        # Master analytics dataset for Tableau
│
├── macros/
│   └── diag_category.sql     # Custom macro to categorize ICD diagnosis codes
│
├── logs/                     # (gitignored) dbt log files
├── target/                   # (gitignored) Compiled & executed dbt models
└── README.md                 # Project documentation
```

---

#  **Data Source**

The dataset is derived from the widely used **Diabetes 130-US hospitals for years 1999–2008** dataset.
It contains:

* **100,000+** hospital encounters
* **50+** medical, demographic, and clinical variables
* Diagnosis codes (`diag_1`, `diag_2`, `diag_3`)
* Medication orders
* Procedures
* Readmission indicator (`<30`, `>30`, `NO`)

---

#  **Staging Layer (stg_diabetes.sql)**

The staging model focuses on:

### ✔️ Standardizing missing values (`?`, blank → NULL)

### ✔️ Cleaning diagnosis fields

### ✔️ Creating categorical diagnosis variables using a dbt macro

### ✔️ Normalizing race fields (fill missing as “Caucasian”, based on distribution)

### ✔️ Bucketizing age into meaningful ranges

### ✔️ Preparing medication variables (Metformin, Insulin, etc.)

### ✔️ Selecting only the fields needed for analytics

This model provides a clean, trusted layer for downstream business logic.

---

#  **Macro: Diagnosis Categorization (`diag_category.sql`)**

Since ICD-9 diagnosis codes are numeric but not intuitive, this macro maps them into **medical condition groups**:

* **Circulatory**
* **Respiratory**
* **Digestive**
* **Diabetes**
* **Injury**
* **Musculoskeletal**
* **Genitourinary**
* **Symptoms**
* **Neoplasms**
* **Other**

Usage inside staging model:

```sql
{{ diag_category(diag_1) }} as diag1_cat,
{{ diag_category(diag_2) }} as diag2_cat,
{{ diag_category(diag_3) }} as diag3_cat
```

---

#  **Dimensional Models**

##  `dim_patients.sql`

Creates a **patient dimension** containing:

* Patient ID
* Gender
* Race
* Age bucket
* Diabetes medication usage
* Insulin category
* Comorbidities (from diagnosis categories)

This provides reusable patient-level attributes for BI dashboards.

---

##  `fact_readmission.sql`

This fact table centers around the **readmission event**, the core KPIs include:

* `encounter_id`
* `patient_nbr`
* `readmitted`
* `number_diagnoses`
* `num_procedures`, `num_lab_procedures`, `number_emergency`, etc.
* Length-of-stay (`time_in_hospital`)

This enables:

* Readmission rate analysis
* Utilization patterns
* Severity metrics

---

#  **Final Analytics Model (`final_diabetes.sql`)**

This model **joins dim_patients + fact_readmission** to produce a **single flat table** used in Tableau.

Contains:

* Demographics
* Diagnosis categories
* Medication patterns
* Readmission outcomes
* Clinical procedure counts

This table is exported as a `.csv` and used to power Tableau dashboards.

---

#  **Tableau Dashboard**

The dashboard provides:

###  **Readmission vs Clinical Variables**

* Diagnosis categories
* Age bucket
* Gender
* Race
* Medications
* Comorbidities

###  **Interactive Parameter**

User can dynamically select **ANY dimension** to analyze:

> *Example: “Show readmissions by Diagnosis Category”*
> *Example: “Show readmissions by Race”*

###  **Stacked bar charts**

Visualize distribution of:

* `<30`
* `>30`
* `NO`

###  **Other visuals**

Recommended charts included:

* Heatmaps
* Boxplots of LOS by diagnosis
* Bar charts of readmissions by age
* Pareto charts
* Medication effect comparisons

---

# **Running This Project**

### ** Install and activate dbt environment**

```
pip install dbt-snowflake
```

### ** Configure Snowflake profile**

Add your Snowflake credentials to:

```
~/.dbt/profiles.yml
```

### ** Test connection**

```
dbt debug
```

### ** Run dbt models**

```
dbt run
```

### ** Export final dataset**

Query:

```
SELECT * FROM GORILLA_FINAL.final_diabetes;
```

Then download as CSV for Tableau.

---

# **Security Notes**

This repo **intentionally excludes**:

* `profiles.yml`
* `rsa_key.pem`
* Snowflake credentials
* Local dbt logs
* `target/` and compiled files

These are protected via `.gitignore` following best practices.

---

#  **Future Enhancements**

* Add unit tests using dbt tests
* Add schema documentation with dbt docs
* Implement incremental models for large-scale loads
* Add warehouse cost monitoring
* Integrate ML module to predict readmission risk

---
