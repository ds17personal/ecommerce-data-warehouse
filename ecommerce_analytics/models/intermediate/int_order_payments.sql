
select
    o.order_id,
    o.customer_id,
    o.order_date,
    o.order_status,
    p.payment_id,
    p.payment_date,
    p.payment_amount,
    p.payment_status

from {{ ref('stg_orders') }} o

left join {{ ref('stg_payments') }} p
    on o.order_id = p.order_id
