
WITH source_data AS (

    SELECT *
    FROM {{ source('ecommerce_raw', 'orders') }}

),

cleaned_data AS (

    SELECT
        order_id,
        customer_id,
        TO_DATE(order_date) AS order_date,
        UPPER(TRIM(status)) AS order_status

    FROM source_data

)

SELECT
    order_id,
    customer_id,
    order_date,
    order_status

FROM cleaned_data

WHERE order_id IS NOT NULL
  AND customer_id IS NOT NULL
  AND order_date IS NOT NULL
