THE REAL BUSINESS PROBLEM WE ARE SOLVING-
We want to understand how customers influence each other's purchasing decisions.
If we target one customer, can they influence others in their network? Which customers are the most influential? 


USE olist_ecommerce;

-- Test 1: How many customers do we have?
SELECT COUNT(*) as total_customers FROM olist_customers_dataset;

-- Test 2: Show me some actual customer data
SELECT 
    customer_unique_id,
    customer_city,
    customer_state
FROM olist_customers_dataset
LIMIT 10;

-- Test 3: Do we have orders for these customers?
SELECT 
    COUNT(*) as total_orders
FROM olist_orders_dataset;

-- Test 4: Simple join test
SELECT 
    c.customer_city,
    COUNT(*) as customers_in_city
FROM olist_customers_dataset c
GROUP BY c.customer_city
ORDER BY customers_in_city DESC
LIMIT 5;
