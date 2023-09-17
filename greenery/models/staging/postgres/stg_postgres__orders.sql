SELECT order_id
  , user_id
  , promo_id
  , address_id
  , created_at AS created_at_utc
  , order_cost
  , shipping_cost
  , order_total AS total_cost
  , tracking_id
  , shipping_service
  , estimated_delivery_at AS estimated_delivery_at_utc
  , delivered_at AS delivered_at_utc
  , status AS order_status
FROM {{source('postgres','orders')}}