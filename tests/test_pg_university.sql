SELECT *
FROM {{ ref('pg_university') }}
WHERE univ_type <> 'PG'