WITH orders_with_customers AS (

    SELECT
        o.order_id,
        o.order_date,
        o.customer_id,
        o.order_status,
        c.customer_name,
        c.city

    FROM {{ ref('stg_orders') }} AS o

    INNER JOIN {{ ref('stg_customers') }} AS c
        ON o.customer_id = c.customer_id

),

order_items_with_products AS (

    SELECT
        oi.order_item_id,
        oi.order_id,
        oi.product_id,
        oi.quantity,
        oi.unit_price,
        oi.item_total,

        p.product_name,
        p.category

    FROM {{ ref('stg_order_items') }} AS oi

    INNER JOIN {{ ref('stg_products') }} AS p
        ON oi.product_id = p.product_id

)

SELECT
    oi.order_item_id,
    oi.order_id,
    oc.order_date,

    oc.customer_id,
    oc.customer_name,
    oc.city,

    oi.product_id,
    oi.product_name,
    oi.category,

    oi.quantity,
    oi.unit_price,
    oi.item_total,

    oc.order_status

FROM order_items_with_products AS oi

INNER JOIN orders_with_customers AS oc
    ON oi.order_id = oc.order_id
