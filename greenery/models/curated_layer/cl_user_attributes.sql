WITH user_data AS (
  SELECT *
    , ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY updated_at_utc DESC) AS row_num
  FROM {{ref('stg_postgres__users')}}
), address_data AS (
  SELECT *
  FROM {{ref('stg_postgres__addresses')}}
) 
SELECT user_id
  , created_at_utc AS activated_at_utc
  , first_name
  , last_name
  , email
  , phone_number
  , address
  , zipcode
  , state
  , country
  , IFF(row_num = 1, TRUE, FALSE) AS is_latest
FROM user_data u
LEFT JOIN address_data a ON u.address_id = a.address_id
