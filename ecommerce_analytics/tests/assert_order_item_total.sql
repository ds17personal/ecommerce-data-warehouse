select *
from {{ ref('int_order_items_enriched') }}
where quantity * unit_price != item_total