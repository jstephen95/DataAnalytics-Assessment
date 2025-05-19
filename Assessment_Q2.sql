SELECT 
-- Categorize the avg_monthly_transaction into 3 categories
    CASE
        WHEN avg_monthly_transaction >= 10 THEN 'High Frequnecy'
        WHEN avg_monthly_transaction >= 3 THEN 'Medium Frequnecy'
        ELSE 'Low Frequency'
    END AS frequency_category,
    
-- Count the customers under each category
    COUNT(*) AS customer_count,
    
-- Calculate the avg_monthly_transaction for each category rounded to 1 decimal place
    ROUND(AVG(avg_monthly_transaction),1) AS avg_transactions_per_month
FROM
-- Subquery to extract the each customer's average monthly transaction
    (SELECT 
        owner_id,
        -- Calculate the average monthly transaction for each customer
            COUNT(savings_id) * 1.0 / COUNT(DISTINCT DATE_FORMAT(transaction_date, '%Y-%m')) AS avg_monthly_transaction
    FROM
        savings_savingsaccount
    GROUP BY owner_id) AS sub

GROUP BY frequency_category
ORDER BY avg_transactions_per_month DESC;