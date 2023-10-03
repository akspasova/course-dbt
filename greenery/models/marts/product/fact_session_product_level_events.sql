WITH events_cl AS (
  SELECT *
  FROM {{ref('cl_events')}}
)
{% set event_types = dbt_utils.get_column_values(
    table = ref('cl_events')
    , column = 'event_type'
)
 %}

SELECT session_id  
  , IFF(product_id IS NULL, 'session level event', product_id) AS product_id
  , IFF(product_name IS NULL, 'session level event', product_name) AS product_name
  {% for event_type in event_types%}
  {{ count_of ('e.event_type', event_type)}}  AS {{ event_type }}_events
  {% endfor %}
FROM events_cl
GROUP BY 1,2,3
