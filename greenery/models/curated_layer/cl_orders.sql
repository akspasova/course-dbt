WITH orders_dataset AS (
  SELECT *
  FROM {{ref('stg_postgres__orders')}}
), ordered_items_dataset AS (
  SELECT *
  FROM {{ref('stg_postgres__order_items')}}
), products_dataset AS (
  SELECT *
  FROM {{ref('stg_postgres__products')}}
), promos_dataset AS (
  SELECT *
  FROM {{ref('stg_postgres__promos')}}
), addresses_dataset AS (
  SELECT *
  FROM {{ref('stg_postgres__addresses')}}
), ordered_products AS (
  SELECT oi.order_id
    , OBJECT_CONSTRUCT(
        'id', oi.product_id, 
        'name',p.product_name,
        'quantity', oi.quantity ::NUMBER,
        'price', ROUND(p.price,2) ::NUMBER(38,2)
      ) AS product
  FROM ordered_items_dataset oi
  LEFT JOIN products_dataset p ON oi.product_id = oi.product_id
), order_promo AS (
  SELECT o.*
    , p.discount
  FROM orders_dataset o
  LEFT JOIN promos_dataset p ON o.promo_id = p.promo_id 
)
SELECT o.created_at_utc ::DATE AS created_date 
  , o.created_at_utc
  , a.country
  , a.state
  , o.order_id
  , o.user_id
  , o.order_cost
  , o.shipping_cost
  , o.total_cost
  , o.tracking_id
  , o.shipping_service
  , o.estimated_delivery_at_utc
  , o.delivered_at_utc
  , o.order_status
  , o.promo_id
  , o.discount
  , p.product
FROM order_promo o
LEFT JOIN ordered_products p ON o.order_id = p.order_id
LEFT JOIN addresses_dataset a ON o.address_id = a.address_id
