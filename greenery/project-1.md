Q1: How many users do we have?
    Result: 130 users in total

    SQL:
    ```
    SELECT COUNT(DISTINCT user_id) AS total_users
    FROM dev_db.dbt_aneliaspasovadeliveryherocom.stg_postgres__users
    ;
    ```

Q2: On average, how many orders do we receive per hour?
    Result: We receive 7.5 orders per hour on average

    SQL:
    ```
    WITH orders_per_hour AS (
    SELECT DATE_TRUNC('HOUR', created_at_utc) AS ordered_at_hour
        , COUNT(DISTINCT order_id) AS total_orders
    FROM dev_db.dbt_aneliaspasovadeliveryherocom.stg_postgres__orders
    GROUP BY 1
    )
    SELECT AVG(total_orders) AS average_order_volume_hour
    FROM orders_per_hour
    ;
    ```

Q3: On average, how long does an order take from being placed to being delivered?
    Result: ~ 336 252 seconds average completion time (93.4 hours, i.e 3.9 days)

    SQL:
    ```
    WITH orders_completion_duration AS (
    SELECT order_id
        , TIMESTAMPDIFF(second, created_at_utc, delivered_at_utc) AS order_completion_duration_seconds
    FROM dev_db.dbt_aneliaspasovadeliveryherocom.stg_postgres__orders
    )
    SELECT AVG(order_completion_duration_seconds) AS average_order_completion_duration_seconds
    FROM orders_completion_duration
    ;
    ```

Q4: How many users have only made one purchase? Two purchases? Three+ purchases?
    Note: you should consider a purchase to be a single order. In other words, if a user places one order for 3 products, they are considered to have made 1 purchase.
    Result: 25 user placed a single order
            28 users placed two orders
            71 users placed three+ orders

    SQL:
    ```
    WITH user_orders AS (
    SELECT user_id
        , COUNT(DISTINCT order_id) AS orders
    FROM dev_db.dbt_aneliaspasovadeliveryherocom.stg_postgres__orders
    GROUP BY 1
    )
    SELECT
    CASE
        WHEN orders = 1
        THEN '1'
        WHEN orders = 2
        THEN '2'
        WHEN orders >= 3
        THEN '3+'
        END AS orders
    , COUNT(DISTINCT user_id) AS users
    FROM user_orders
    GROUP BY 1
    ORDER BY 1
    ;
    ```
Q5: On average, how many unique sessions do we have per hour?
    Result: There are 16.3 session per hour on average

    SQL:
    ```
        WITH sessions_per_hour AS (
        SELECT DATE_TRUNC('HOUR', created_at_utc) AS created_at_hour
            , COUNT(DISTINCT session_id) AS total_sessions
        FROM dev_db.dbt_aneliaspasovadeliveryherocom.stg_postgres__events
        GROUP BY 1
        )
        SELECT AVG(total_sessions) AS average_sessions_hour
        FROM sessions_per_hour
        ;
    ```