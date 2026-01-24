WITH users_deduplicated AS (
    SELECT
        user_id,
        created_at,
        email,
        first_name,
        last_name,
        gender,
        age,
        country,
        city,
        state,
        traffic_source,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY created_at) AS row_num
    FROM {{ ref('stg_users') }}
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['user_id', 'created_at']) }} AS user_key,
    user_id,
    email,
    first_name,
    last_name,
    gender,
    age,
    country,
    city,
    state,
    traffic_source,
    created_at AS valid_from,
    LEAD(created_at) OVER (PARTITION BY user_id ORDER BY created_at) AS valid_to,
    CASE 
        WHEN LEAD(created_at) OVER (PARTITION BY user_id ORDER BY created_at) IS NULL 
        THEN TRUE 
        ELSE FALSE 
    END AS is_current
FROM users_deduplicated
WHERE row_num = 1