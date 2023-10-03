Q1: What is our overall conversion rate?
    
    Result: Overall conversion rate is 62.46%

    SQL:
    ```
    WITH events_session  AS (
      SELECT *
      FROM fact_product_page_views
    )
    SELECT ROUND(COUNT(DISTINCT IFF(product_bought_flag=1, session_id, NULL))/COUNT(DISTINCT session_id)*100,2) AS conversion_rate_pct
    FROM events_session
    ```
Q2: What is our product conversion rate?

   Result: Product conversion rate ranges from 34% to 60%

    SQL:
    ```
    WITH events_session  AS (
      SELECT *
      FROM fact_product_page_views
    )
    SELECT product_id
      , product_name
      , ROUND(COUNT(DISTINCT IFF(product_bought_flag=1, session_id, NULL))/COUNT(DISTINCT session_id)*100,2) AS conversion_rate_pct
    FROM events_session
    GROUP BY all
    ORDER BY 3 DESC
    ```
Q6: Which products had their inventory change from week 2 to week 3? 
   Result: Monstera, Philodendron, Pothos, String of pearls, Bamboo, ZZ Plant
    SQL:
    ```
      SELECT *
      FROM DBT_ANELIASPASOVADELIVERYHEROCOM.PRODUCTS_SNAPSHOT
      WHERE dbt_valid_to IS NOT NULL
        AND DATE(dbt_valid_to) = '2023-10-03'
    ```