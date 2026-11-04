select
    c.customer_id,
    c.total_orders,
    coalesce(sum(f.order_amount), 0) as total_revenue,
    avg(f.order_amount) as avg_order_value

from {{ ref('dim_customers') }} c

left join {{ ref('fct_order_sales') }} f
    on c.customer_id = f.customer_id

group by
    c.customer_id,
    c.total_orders