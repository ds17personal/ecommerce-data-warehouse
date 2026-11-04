
WITH source_data AS (

    SELECT *
    FROM {{ source('ecommerce_raw', 'customers') }}

),

cleaned_data AS (

    SELECT
        customer_id,
        TRIM(customer_name) AS customer_name,
        NULLIF(TRIM(email), '') AS email,
        UPPER(TRIM(city)) AS city,
        signup_date,
        updated_at

    FROM source_data

),

deduplicated_data AS (

    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY updated_at DESC
        ) AS row_num

    FROM cleaned_data

)

SELECT
    customer_id,
    customer_name,
    email,
    city,
    signup_date,
    updated_at

FROM deduplicated_data
WHERE row_num = 1
