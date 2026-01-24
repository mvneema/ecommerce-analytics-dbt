SELECT
    {{ dbt_utils.generate_surrogate_key(['oi.order_item_id']) }} AS order_key,
    oi.order_item_id,
    oi.order_id,
    oi.user_id,
    oi.product_id,
    oi.sale_price,
    o.status AS order_status,
    oi.status AS item_status,
    oi.created_at AS order_created_at,
    o.shipped_at,
    o.delivered_at,
    o.returned_at,
    u.created_at AS user_created_at,
    u.country AS user_country,
    u.city AS user_city,
    u.traffic_source,
    p.category,
    p.brand,
    p.department,
    p.cost AS product_cost,
    p.retail_price,
    oi.sale_price - p.cost AS profit,
    CASE 
        WHEN o.returned_at IS NOT NULL THEN TRUE 
        ELSE FALSE 
    END AS is_returned,
    DATE_DIFF(DATE(oi.created_at), DATE(u.created_at), DAY) AS days_since_user_signup
FROM {{ ref('stg_order_items') }} oi
LEFT JOIN {{ ref('stg_orders') }} o ON oi.order_id = o.order_id
LEFT JOIN {{ ref('stg_users') }} u ON oi.user_id = u.user_id
LEFT JOIN {{ ref('stg_products') }} p ON oi.product_id = p.product_id