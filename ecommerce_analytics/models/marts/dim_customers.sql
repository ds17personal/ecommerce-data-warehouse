SELECT
    customer_id,
    customer_name,
    email,
    city,
    signup_date,
    total_orders,
    first_order_date,
    last_order_date,
    CASE
        WHEN total_orders <= 1 THEN 'New'
        ELSE 'Repeat'
    END AS customer_type
FROM {{ ref('int_order_customers') }}