WITH events_curated_data AS (
  SELECT *
  FROM {{ref('cl_events')}}
), session_add_product_bought_flag AS (
  SELECT session_id
    , product_id
    , CAST(MAX(IFF(event_type = 'add_to_cart' AND created_at_utc < last_checkout_at_utc , 1, 0)) AS BOOLEAN) AS product_bought_flag
  FROM events_curated_data
  WHERE product_id IS NOT NULL
  GROUP BY all
), combine_events_with_flag AS (
  -- checkout and shipping events do not contain product ids
  SELECT e.*
    , f.product_bought_flag
  FROM cl_events e
  -- used to filter out product unrelated events
  INNER JOIN session_add_product_bought_flag f ON e.session_id = f.session_id
  AND e.product_id = f.product_id
)
SELECT created_date_utc
  , country
  , state
  , user_id
  , SUM(session_duration_sec) AS daily_time_on_site_sec
  , COUNT(DISTINCT session_id) AS daily_sessions
  , product_id
  , product_name
  -- agg needed as data is on a daily not session level
  , MAX(product_bought_flag) AS product_bought_flag
  -- events
  , COUNT(DISTINCT IFF(event_type = 'page_view', event_id, NULL)) AS page_views_events
  , COUNT(DISTINCT IFF(event_type = 'add_to_cart', event_id, NULL)) AS add_to_cart_events
  -- sessions
  , COUNT(DISTINCT IFF(event_type = 'page_view', session_id, NULL)) AS page_views_sessions
  , COUNT(DISTINCT IFF(event_type = 'add_to_cart', session_id, NULL)) AS add_to_cart_sessions
FROM combine_events_with_flag e
GROUP BY all
