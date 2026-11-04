
WITH source_data AS (

    SELECT *
    FROM {{ source('ecommerce_raw', 'products') }}

),

cleaned_data AS (

    SELECT
        product_id,
        TRIM(product_name) AS product_name,
        INITCAP(TRIM(category)) AS category,
        price::NUMBER(10,2) AS price

    FROM source_data

)

SELECT *
FROM cleaned_data
WHERE product_id IS NOT NULL
  AND price >= 0
