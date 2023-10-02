WITH orders AS (
  SELECT *
  FROM {{ref('cl_orders')}}
), user_attributes AS (
  SELECT *
  FROM {{ref('cl_user_attributes')}}
)
SELECT o.user_id
  , u.user_grade
  , u.state
  , u.country
  , MIN(DATE(o.created_at_utc)) AS first_order
  , MAX(DATE(o.created_at_utc)) AS last_order
  , COUNT(DISTINCT o.order_id) AS orders
  , COUNT(DISTINCT o.product['id']) AS products_types
  , SUM(o.product['quantity']) AS products_quantity
  , COUNT(DISTINCT o.promo_id) AS promotions
  , SUM(o.total_cost) AS amount_spent
FROM orders o
LEFT JOIN user_attributes u ON u.user_id = o.user_id
WHERE is_latest
GROUP BY 1,2,3,4
