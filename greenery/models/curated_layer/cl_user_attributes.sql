WITH user_data AS (
  SELECT *
    , ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY updated_at_utc DESC) AS row_num
  FROM {{ref('stg_postgres__users')}}
), address_data AS (
  SELECT *
  FROM {{ref('stg_postgres__addresses')}}
), orders_dataset AS (
  SELECT *
  FROM {{ref('stg_postgres__orders')}}
), user_orders AS (
  SELECT user_id
    , COUNT(DISTINCT order_id) AS orders
    , MAX(promo_id) AS promo_id
  FROM orders_dataset
  GROUP BY 1
)
SELECT u.user_id
  , u.created_at_utc AS activated_at_utc
  , u.first_name
  , u.last_name
  , u.email
  , u.phone_number
  , a.address
  , a.zipcode
  , a.state
  , a.country
  , IFF(u.row_num = 1, TRUE, FALSE) AS is_latest
  , CASE
      WHEN o.orders >= 6
        THEN 'A'
      WHEN o.orders BETWEEN 2 AND 5
        THEN 'B'
      WHEN o.orders = 1
        THEN 'C'
      ELSE 'D'
    END AS vendor_grade
  , IFF(o.promo_id IS NOT NULL, TRUE, FALSE) AS uses_promo_codes
FROM user_data u
LEFT JOIN address_data a ON u.address_id = a.address_id
LEFT JOIN user_orders o ON u.user_id = o.user_id
