Q1: What is our user repeat rate?
    
    Result: 79.84%

    SQL:
    ```
    WITH user_orders_count AS (
        SELECT user_id
        , COUNT(order_id) AS orders
        FROM STG_POSTGRES__ORDERS
        GROUP BY 1
    ), identify_user_groups AS (
    SELECT COUNT(DISTINCT IFF(orders>=2,user_id, NULL)) AS users_repeated
        , COUNT(DISTINCT user_id) AS users_with_orders
    FROM user_orders_count
    )
    SELECT ROUND(DIV0(users_repeated,users_with_orders)*100,2) AS repeat_rate_pct
    , *
    FROM identify_user_groups
    ```
Q2: What are good indicators of a user who will likely purchase again?
  - Total number of orders; 
  - Low order return and/or cancellation rate;
  - High number of recent visits;
  - High number of interactions with the website - e.g. products clicked or added to cart;

Q3: What are indicators that a user who will not purchase again?
  - High order return and/or cancellation rate;
  - Low number of recent visits;

Q4: Tests - just added simple tests for uniqueness and missing values to the raw data as I didn't have enough time to work on the project this week.

Q5: Products with inventory change: 
    ```
    SELECT *
    FROM products_snapshot
    WHERE dbt_valid_to IS NOT NULL
    ```