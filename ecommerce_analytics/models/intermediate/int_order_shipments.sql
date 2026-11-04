SELECT
        o.order_id,
        o.customer_id,
        o.order_date,
        o.order_status,
        s.shipment_id,
        s.ship_date,
        s.delivery_date,
        s.shipping_status
    FROM {{ref ('stg_orders' )}} o
    LEFT JOIN {{ref ('stg_shipments')}} s ON o.order_id = s.order_id

