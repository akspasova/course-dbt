{%- macro count_of(col_name , col_value ) -%}
  , COUNT(DISTINCT IFF({{ col_name }} = '{{ col_value }}', event_id, NULL))
{%- endmacro -%}