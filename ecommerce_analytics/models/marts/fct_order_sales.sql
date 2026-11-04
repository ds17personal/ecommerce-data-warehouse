SELECT
    s.customer_id,
    s.order_id,
    s.order_date,
    s.order_status,

    COUNT(o.order_item_id) AS total_items,
    COALESCE(SUM(o.quantity), 0) AS total_quantity,
    COALESCE(SUM(o.item_total), 0) AS order_amount,

    COALESCE(SUM(o.item_total), 0)
        / NULLIF(COALESCE(SUM(o.quantity), 0), 0)
        AS average_selling_price

FROM {{ ref('stg_orders') }} s

LEFT JOIN {{ ref('int_order_items_enriched') }} o
    ON s.order_id = o.order_id

GROUP BY 1, 2, 3, 4