WITH products_data AS (
  SELECT *
  FROM {{ref('stg_postgres__products')}}
), events_data AS (
  SELECT *
  FROM {{ref('stg_postgres__events')}}
), user_location AS (
  SELECT *
  FROM {{ref('cl_user_attributes')}}
  WHERE is_latest
), session_duration AS (
  SELECT session_id
    , MIN(created_at_utc) AS starts_at_utc
    , MAX(created_at_utc) AS ends_at_utc
    , MAX(IFF(event_type = 'checkout', created_at_utc, NULL)) AS last_checkout_at_utc
  FROM events_data
  GROUP BY 1
)
SELECT DATE(e.created_at_utc) AS created_date_utc
  , e.created_at_utc
  , e.event_id
  , e.session_id
  , s.starts_at_utc AS session_starts_at
  , TIMESTAMPDIFF('second', s.starts_at_utc, s.ends_at_utc) AS session_duration_sec
  , s.last_checkout_at_utc
  , e.order_id
  , e.event_type
  , e.user_id
  , u.state
  , u.country
  , p.product_id
  , p.product_name
FROM events_data e
LEFT JOIN products_data p ON e.product_id = p.product_id
LEFT JOIN user_location u ON e.user_id = u.user_id
LEFT JOIN session_duration s ON e.session_id = s.session_id
