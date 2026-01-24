WITH source AS (
    SELECT * FROM {{ source('bronze_ecommerce', 'order_items') }}
),

cleaned AS (
    SELECT
        id AS order_item_id,
        order_id,
        user_id,
        product_id,
        status,
        created_at,      -- Already timestamps
        shipped_at,
        delivered_at,
        returned_at,
        sale_price
    FROM source
    WHERE id IS NOT NULL
)

SELECT * FROM cleaned