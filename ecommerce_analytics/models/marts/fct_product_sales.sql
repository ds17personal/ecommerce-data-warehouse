SELECT
    product_id,
    product_name,
    category,
    COALESCE(total_units_sold, 0) AS total_units_sold,
    COALESCE(total_sales_amount, 0) AS total_sales_amount,
    COALESCE(total_order_items, 0) AS total_order_items,
    CASE
        WHEN total_units_sold > 0
        THEN total_sales_amount / total_units_sold
        ELSE NULL
    END AS average_selling_price

FROM {{ ref('int_product_sales') }}