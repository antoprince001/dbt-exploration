{{ config(materialized='view') }}

-- Filter based on column

SELECT *
FROM {{ ref('university_staging') }}
WHERE univ_type = 'UG'