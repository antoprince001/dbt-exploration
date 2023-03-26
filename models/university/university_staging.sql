{{ config(materialized='table') }}

-- Add new column name to univ_id
-- Modify univ_name column
-- Add univ_code column by concatenating 
-- Add constant to column
-- Macros for reusable logic (compute_student_dept_ratio)
-- Aggregated column values
-- Referencing other table column by join
-- Split column using delimiter (univ_address)

WITH univ_stats AS (
    SELECT 
        univ_id, 
        count(univ_id) as dept_count,
        SUM(dept_student_count) student_count
    FROM {{ source('dbt_department', 'department') }}
    GROUP BY univ_id
),

univ_dept_joined AS (
    SELECT 
        univ.univ_id,
        univ_name,
        univ_address,
        univ_type,
        student_count,
        dept_count
    FROM {{ source('dbt_university', 'university') }} as univ 
    INNER JOIN univ_stats as stats
    ON univ.univ_id = stats.univ_id
)


SELECT 
    univ_id as id,
    TRIM(univ_name) as trimmed_univ_name,
    split_part(univ_address,'-', 1) as city,
	split_part(univ_address,'-', 2) as country,
	split_part(univ_address,'-', 3) as continent,
    univ_type,
    CONCAT('CODE',univ_type,univ_id) as univ_code,
    student_count,
    dept_count,
    CAST({{ compute_student_dept_ratio('student_count','dept_count')}} AS double precision) as student_dept_ratio
FROM univ_dept_joined