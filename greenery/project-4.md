Q2: Which products had their inventory change from week 3 to 4
    
    Result: Monstera, Bamboo, Philodendron, ZZ Plant, Pothos, String of pearls inventory changed twice since Monday (2023-10-02). We need to take into account that I finished my last project on Monday this week so the above mentioned product have inventory updates 2 this week as this is when the pipeline ran.

    SQL:
    ```
    SELECT DISTINCT name AS product_inventory_changed_name
    FROM products_snapshot
    WHERE dbt_valid_to IS NOT NULL
      AND DATE(dbt_valid_to) >= '2023-10-02'
    ```
Q3: Now that we have 3 weeks of snapshot data, can you use the inventory changes to determine which products had the most fluctuations in inventory? 

   Result: The products with the most fluctuations in inventory are Monstera, Philodendron, ZZ Plant, Pothos, and String of pearls. Their inventory changed 4 times during the course. 
           Bamboo and ZZ Plant are the other two products that had a change in inventory but the levels changed 3 times.

    SQL:
    ```
    SELECT name AS product_name
      , COUNT(1) AS invenotry_changes
    FROM products_snapshot
    GROUP BY 1
    ORDER BY 2 DESC
    ```
Q3.2: Did we have any items go out of stock in the last 3 weeks?
   
   Result: Pothos and String of pearls were out of stock from 2 - 8 October, but are currently back in stock. We have 20 Pothos plants and 10 String of Pearls
    
    SQL:
    ```
    SELECT name AS product_name
      , s.inventory AS period_inventory
      , dbt_valid_from
      , dbt_valid_to
      , p.inventory AS current_inventory
    FROM products_snapshot s
    LEFT JOIN stg_postgres__products p ON s.name = p.product_name
    WHERE s.inventory = 0
    ```