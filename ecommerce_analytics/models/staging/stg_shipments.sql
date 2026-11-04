WITH source_data AS (

    SELECT *
    FROM {{ source('ecommerce_raw', 'shipments') }}

),

cleaned_data AS (

    SELECT
        shipment_id,
        order_id,
        TO_DATE(ship_date) AS ship_date,
        TO_DATE(delivery_date) AS delivery_date,
        UPPER(TRIM(shipping_status)) AS shipping_status

    FROM source_data

)

SELECT
    shipment_id,
    order_id,
    ship_date,
    delivery_date,
    shipping_status

FROM cleaned_data

WHERE shipment_id IS NOT NULL
  AND order_id IS NOT NULL
  AND ship_date IS NOT NULL
  AND shipping_status IN (
      'DELIVERED',
      'IN_TRANSIT',
      'RETURNED'
  )