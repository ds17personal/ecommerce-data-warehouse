select 
product_id,
product_name,
category,
price,
case
when price < 500 then 'Budget'
when price between 500 and 1500 then 'Mid-Range'
else 'Premium' end as product_price_band
from {{ref('stg_products')}}