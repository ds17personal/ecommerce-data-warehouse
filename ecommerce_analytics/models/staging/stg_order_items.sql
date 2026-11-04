
WITH source_data AS (

    SELECT *
    FROM {{ source('ecommerce_raw', 'order_items') }}

),

cleaned_data AS (

    SELECT
        order_item_id,
        order_id,
        product_id,
        quantity,
        unit_price::NUMBER(10,2) AS unit_price

    FROM source_data

)

SELECT
    order_item_id,
    order_id,
    product_id,
    quantity,
    unit_price,
    quantity * unit_price AS item_total

FROM cleaned_data

WHERE order_item_id IS NOT NULL
  AND order_id IS NOT NULL
  AND product_id IS NOT NULL
  AND quantity > 0
  AND unit_price >= 0
