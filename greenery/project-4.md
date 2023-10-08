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
Q4: Quick Product Funnel Visualisation: https://app.sigmacomputing.com/corise-dbt/workbook/Product-Funnel-73YrPL9ZlCDQQXLTiPvjAU
    & dbt doc: https://8080-akspasova-coursedbt-1xygc41a5ql.ws-eu105.gitpod.io/#!/exposure/exposure.greenery.fact_product_funnel

    Which steps in the funnel have largest drop off points? 
    
    As expectect, the biggest drop off is from "page views" to "add to cart" events and session. The good thing is that as many users have page views events and also have added product to cart, which never happens in real companies. Also, > 99% of the users had a check out event. So event if we see a drop off in events and sessions all of our users engaged with our website and almost everyone bought a product.
    We see more users with shipped events than any other event, which is not expected behaviour and indicates that either there's a problem with the data (wrong entries or we have missing events for some users) or I made a mistake somewhere (I don't want to bug fix in my free time if it brings no benefit).


3A&B. Reflecting on your learning in this class...
   I loved the course and I think the information is super useful. I really appreciate that the lectures are being recorded and there are walkthroughs for the projects. It would have been nice if it is possible to start the advanced course right after this course. I understand that this course is targetng people not only with engineering background and the information I got here is useful but not enough to do my daily job and unfortunately for the next one we have to wait at least till January.

   I would use dbt with Airflow as a scheduler as atm this is my only option. How often the pipeline runs depends on the size and stage of the company development and amount of data and how often the product is sending data to the raw layer.
