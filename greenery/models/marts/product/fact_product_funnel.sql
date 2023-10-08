WITH events_curated_data AS (
  SELECT *
  FROM {{ref('cl_events')}}
) 
SELECT created_date_utc
  , country
  , state
  , event_type
  , COUNT(DISTINCT session_id) AS sessions_cnt
  , COUNT(DISTINCT user_id) AS users_cnt
  , COUNT(DISTINCT event_id) AS events_cnt
FROM events_curated_data
GROUP BY all
