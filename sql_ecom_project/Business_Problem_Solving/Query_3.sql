This uses standard SQL joins and aggregations that any intermediate analyst would write. No fancy window functions - just practical business analysis.
Tell me what competitive patterns you discover! For example:

Which cities have the most seller competition?
Do sellers in the same city have similar pricing?
Which sellers are winning the loyalty game?

-------------------------------------------------------------------------------------------------------------
 --COMPETITION ANALYSIS 


USE olist_ecommerce;

-- STEP 1: Basic seller overview
SELECT 
    COUNT(*) as total_sellers
FROM olist_sellers_dataset;

-- STEP 2: Top cities with most sellers
SELECT 
    seller_city,
    COUNT(*) as number_of_sellers
FROM olist_sellers_dataset
GROUP BY seller_city
ORDER BY number_of_sellers DESC
LIMIT 10;

-- STEP 3: Seller performance - who has the most orders?
SELECT 
    s.seller_id,
    s.seller_city,
    COUNT(oi.order_id) as total_orders,
    ROUND(AVG(oi.price), 2) as avg_price
FROM olist_sellers_dataset s
JOIN olist_order_items_dataset oi ON s.seller_id = oi.seller_id
GROUP BY s.seller_id, s.seller_city
ORDER BY total_orders DESC
LIMIT 15;

-- STEP 4: City competition - which cities have multiple competing sellers?
SELECT 
    s.seller_city,
    COUNT(DISTINCT s.seller_id) as competing_sellers,
    COUNT(oi.order_id) as total_city_orders,
    ROUND(AVG(oi.price), 2) as city_avg_price
FROM olist_sellers_dataset s
JOIN olist_order_items_dataset oi ON s.seller_id = oi.seller_id
GROUP BY s.seller_city
HAVING COUNT(DISTINCT s.seller_id) >= 2
ORDER BY competing_sellers DESC
LIMIT 15;

-- STEP 5: Price competition in same city
SELECT 
    s.seller_city,
    s.seller_id,
    COUNT(oi.order_id) as orders,
    ROUND(AVG(oi.price), 2) as avg_price
FROM olist_sellers_dataset s
JOIN olist_order_items_dataset oi ON s.seller_id = oi.seller_id
WHERE s.seller_city IN (
    SELECT seller_city 
    FROM olist_sellers_dataset 
    GROUP BY seller_city 
    HAVING COUNT(*) >= 3
)
GROUP BY s.seller_city, s.seller_id
HAVING COUNT(oi.order_id) >= 3
ORDER BY s.seller_city, avg_price
LIMIT 20;
