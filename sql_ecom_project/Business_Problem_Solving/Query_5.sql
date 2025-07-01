THE REAL BUSINESS PROBLEM WE ARE SOLVING-
We're losing money to fraudulent orders.
How can you help us identify suspicious purchasing patterns and flag potentially fraudulent customers before they complete transactions?
  
-- STEP 1: Run this EXACT query that worked before
SELECT 
    MIN(payment_value) AS min_payment,
    MAX(payment_value) AS max_payment,
    AVG(payment_value) AS avg_payment
FROM olist_order_payments_dataset
WHERE payment_value IS NOT NULL;

-- STEP 2: If above works, try this simple one
SELECT payment_value, payment_type
FROM olist_order_payments_dataset
LIMIT 5;

-- STEP 3: If above works, try this
SELECT 
    payment_type,
    COUNT(*) as total_count
FROM olist_order_payments_dataset
GROUP BY payment_type;
