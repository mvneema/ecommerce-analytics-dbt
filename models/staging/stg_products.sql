WITH source AS (
    SELECT * FROM {{ source('bronze_ecommerce', 'products') }}
),

cleaned AS (
    SELECT
        id AS product_id,
        cost,
        category,
        name AS product_name,
        brand,
        retail_price,
        department,
        sku
    FROM source
    WHERE id IS NOT NULL
)

SELECT * FROM cleaned