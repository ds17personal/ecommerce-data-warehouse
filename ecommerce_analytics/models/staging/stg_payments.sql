
WITH source_data AS (

    SELECT *
    FROM {{ source('ecommerce_raw', 'payments') }}

),

cleaned_data AS (

    SELECT
        payment_id,
        order_id,
        TO_DATE(payment_date) AS payment_date,
        amount::NUMBER(12,2) AS payment_amount,
        UPPER(TRIM(payment_status)) AS payment_status

    FROM source_data

)

SELECT
    payment_id,
    order_id,
    payment_date,
    payment_amount,
    payment_status

FROM cleaned_data

WHERE payment_id IS NOT NULL
  AND order_id IS NOT NULL
  AND payment_amount >= 0
  AND payment_status IN (
      'SUCCESS',
      'FAILED',
      'PENDING',
      'REFUNDED'
  )
