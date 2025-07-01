THE REAL BUSINESS PROBLEM WE ARE SOLVING-
Our customer reviews contain valuable insights, but we have thousands of them. 
How can we analyze the review text to identify which products have sentiment issues, which reviews might be fake, and what specific problems customers are mentioning?

---------------------------------------------------------------------------------------------------------------
-- SIMPLE NLP ANALYSIS 


USE olist_ecommerce;

-- STEP 1: First, let's see what review data we actually have
SELECT 
    COUNT(*) as total_reviews,
    COUNT(review_comment_message) as reviews_with_text
FROM olist_order_reviews_dataset;

-- STEP 2: Look at actual review text samples
SELECT 
    review_score,
    LENGTH(review_comment_message) as text_length,
    review_comment_message
FROM olist_order_reviews_dataset 
WHERE review_comment_message IS NOT NULL
AND LENGTH(review_comment_message) > 20
LIMIT 10;

-- STEP 3: Basic text analysis - count by review length
SELECT 
    CASE 
        WHEN LENGTH(review_comment_message) < 20 THEN 'Very Short (under 20 chars)'
        WHEN LENGTH(review_comment_message) < 100 THEN 'Short (20-100 chars)'
        WHEN LENGTH(review_comment_message) < 300 THEN 'Medium (100-300 chars)'
        ELSE 'Long (300+ chars)'
    END as review_length_category,
    COUNT(*) as number_of_reviews,
    ROUND(AVG(review_score), 2) as average_rating
FROM olist_order_reviews_dataset 
WHERE review_comment_message IS NOT NULL
GROUP BY 
    CASE 
        WHEN LENGTH(review_comment_message) < 20 THEN 'Very Short (under 20 chars)'
        WHEN LENGTH(review_comment_message) < 100 THEN 'Short (20-100 chars)'
        WHEN LENGTH(review_comment_message) < 300 THEN 'Medium (100-300 chars)'
        ELSE 'Long (300+ chars)'
    END
ORDER BY number_of_reviews DESC;

-- STEP 4: Simple sentiment analysis - look for basic positive/negative words
SELECT 
    review_score,
    review_comment_message,
    CASE 
        WHEN LOWER(review_comment_message) LIKE '%bom%' 
          OR LOWER(review_comment_message) LIKE '%otimo%' 
          OR LOWER(review_comment_message) LIKE '%excelente%' THEN 'Contains Positive Words'
        WHEN LOWER(review_comment_message) LIKE '%ruim%' 
          OR LOWER(review_comment_message) LIKE '%pessimo%' 
          OR LOWER(review_comment_message) LIKE '%defeito%' THEN 'Contains Negative Words'
        ELSE 'Neutral/No Keywords'
    END as sentiment_category
FROM olist_order_reviews_dataset 
WHERE review_comment_message IS NOT NULL
AND LENGTH(review_comment_message) > 10
LIMIT 20;

-- STEP 5: Summary of sentiment vs ratings
SELECT 
    review_score,
    CASE 
        WHEN LOWER(review_comment_message) LIKE '%bom%' 
          OR LOWER(review_comment_message) LIKE '%otimo%' 
          OR LOWER(review_comment_message) LIKE '%excelente%' THEN 'Positive Words'
        WHEN LOWER(review_comment_message) LIKE '%ruim%' 
          OR LOWER(review_comment_message) LIKE '%pessimo%' 
          OR LOWER(review_comment_message) LIKE '%defeito%' THEN 'Negative Words'
        ELSE 'Neutral'
    END as sentiment_category,
    COUNT(*) as review_count
FROM olist_order_reviews_dataset 
WHERE review_comment_message IS NOT NULL
GROUP BY 
    review_score,
    CASE 
        WHEN LOWER(review_comment_message) LIKE '%bom%' 
          OR LOWER(review_comment_message) LIKE '%otimo%' 
          OR LOWER(review_comment_message) LIKE '%excelente%' THEN 'Positive Words'
        WHEN LOWER(review_comment_message) LIKE '%ruim%' 
          OR LOWER(review_comment_message) LIKE '%pessimo%' 
          OR LOWER(review_comment_message) LIKE '%defeito%' THEN 'Negative Words'
        ELSE 'Neutral'
    END
ORDER BY review_score, sentiment_category;
