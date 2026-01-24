SELECT
    {{ dbt_utils.generate_surrogate_key(['product_id']) }} AS product_key,
    product_id,
    product_name,
    brand,
    category,
    department,
    cost,
    retail_price,
    sku,
    retail_price - cost AS margin
FROM {{ ref('stg_products') }}