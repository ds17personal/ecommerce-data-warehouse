select 
    p.product_id,
    p.product_name,
    p.category,
    coalesce(sum(o.quantity), 0) as total_units_sold,
    coalesce(sum(o.item_total), 0) as total_sales_amount,
    count(o.order_item_id) as total_order_items
from {{ ref('stg_products') }} p 
left join {{ ref('stg_order_items') }} o
    on p.product_id = o.product_id
group by 1, 2, 3