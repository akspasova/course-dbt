WITH events_curated_data AS (
  SELECT *
  FROM {{ref('cl_events')}}
), session_add_product_bought_and_shipped_flags AS (
  SELECT session_id
    , product_id
    , CAST(MAX(IFF(event_type = 'add_to_cart' AND created_at_utc < last_checkout_at_utc , 1, 0)) AS BOOLEAN) AS product_bought_flag
    , CAST(MAX(IFF(event_type = 'add_to_cart' AND created_at_utc < last_package_shipped_at_utc , 1, 0)) AS BOOLEAN) AS product_shipped_flag
  FROM events_curated_data
  WHERE product_id IS NOT NULL
  GROUP BY all
), combine_events_with_flag AS (
  -- checkout and shipping events do not contain product ids
  SELECT e.*
    , f.product_bought_flag
    , f.product_shipped_flag
  FROM cl_events e
  -- used to filter out product unrelated events
  INNER JOIN session_add_product_bought_and_shipped_flags f ON e.session_id = f.session_id
  AND e.product_id = f.product_id
)

{% set event_types = [
  'page_view'
  , 'add_to_cart'
 ] %}

SELECT created_date_utc
  , country
  , state
  , user_id
  , session_duration_sec
  , session_id
  , product_id
  , product_name
  -- agg needed as data is on a daily not session level
  , MAX(product_bought_flag) AS product_bought_flag
  , MAX(product_shipped_flag) AS product_shipped_flag
  -- events
  {% for event_type in event_types%}
  , COUNT(DISTINCT IFF(event_type = '{{ event_type }}', event_id, NULL)) AS {{ event_type }}_events
  {% endfor %}
  -- , COUNT(DISTINCT IFF(event_type = 'page_view', event_id, NULL)) AS page_views_events
  -- , COUNT(DISTINCT IFF(event_type = 'add_to_cart', event_id, NULL)) AS add_to_cart_events
  -- sessions
  {% for event_type in event_types%}
  , COUNT(DISTINCT IFF(event_type = '{{ event_type }}', session_id, NULL)) AS {{ event_type }}_sessions
  {% endfor %}
  -- , COUNT(DISTINCT IFF(event_type = 'page_view', session_id, NULL)) AS page_views_sessions
  -- , COUNT(DISTINCT IFF(event_type = 'add_to_cart', session_id, NULL)) AS add_to_cart_sessions
FROM combine_events_with_flag e
GROUP BY all
