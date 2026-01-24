WITH source AS (
    SELECT * FROM {{ source('bronze_ecommerce', 'users') }}
),

cleaned AS (
    SELECT
        id AS user_id,
        created_at,  -- Already a timestamp, no parsing needed
        email,
        first_name,
        last_name,
        gender,
        age,
        country,
        city,
        state,
        traffic_source
    FROM source
    WHERE id IS NOT NULL
)

SELECT * FROM cleaned