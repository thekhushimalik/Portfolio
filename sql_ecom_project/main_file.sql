This Simple Query will answer three clear business questions:

What hour of the day generates the most revenue?
What time period (morning/afternoon/evening/night) is best for sales?
What day of the week brings in the most money?

---------------------------------------------------------------------------------------------------------------------
-- BUSINESS QUESTION: When do customers spend the most money?

USE olist_ecommerce;

-- STEP 1: Let's see what time customers make purchases
SELECT 
    HOUR(o.order_purchase_timestamp) as purchase_hour,
    COUNT(*) as number_of_orders,
    ROUND(AVG(p.payment_value), 2) as average_order_value,
    ROUND(SUM(p.payment_value), 2) as total_revenue_this_hour
FROM olist_orders_dataset o
JOIN olist_order_payments_dataset p ON o.order_id = p.order_id
WHERE o.order_purchase_timestamp IS NOT NULL
GROUP BY HOUR(o.order_purchase_timestamp)
ORDER BY total_revenue_this_hour DESC;

-- STEP 2: Group by time periods for easier understanding
SELECT 
    CASE 
        WHEN HOUR(o.order_purchase_timestamp) BETWEEN 6 AND 11 THEN '06:00-11:59 Morning'
        WHEN HOUR(o.order_purchase_timestamp) BETWEEN 12 AND 17 THEN '12:00-17:59 Afternoon'
        WHEN HOUR(o.order_purchase_timestamp) BETWEEN 18 AND 22 THEN '18:00-22:59 Evening'
        ELSE '23:00-05:59 Night'
    END as time_period,
    COUNT(*) as total_orders,
    ROUND(AVG(p.payment_value), 2) as avg_order_value,
    ROUND(SUM(p.payment_value), 2) as total_revenue,
    ROUND(SUM(p.payment_value) * 100.0 / (SELECT SUM(payment_value) FROM olist_order_payments_dataset), 2) as percent_of_total_revenue
FROM olist_orders_dataset o
JOIN olist_order_payments_dataset p ON o.order_id = p.order_id
WHERE o.order_purchase_timestamp IS NOT NULL
GROUP BY time_period
ORDER BY total_revenue DESC;

-- STEP 3: Day of week analysis
SELECT 
    CASE DAYOFWEEK(o.order_purchase_timestamp)
        WHEN 1 THEN 'Sunday'
        WHEN 2 THEN 'Monday'
        WHEN 3 THEN 'Tuesday'
        WHEN 4 THEN 'Wednesday'
        WHEN 5 THEN 'Thursday'
        WHEN 6 THEN 'Friday'
        WHEN 7 THEN 'Saturday'
    END as day_of_week,
    COUNT(*) as total_orders,
    ROUND(AVG(p.payment_value), 2) as avg_order_value,
    ROUND(SUM(p.payment_value), 2) as total_revenue
FROM olist_orders_dataset o
JOIN olist_order_payments_dataset p ON o.order_id = p.order_id
WHERE o.order_purchase_timestamp IS NOT NULL
GROUP BY DAYOFWEEK(o.order_purchase_timestamp)
ORDER BY total_revenue DESC;
