SELECT 
    p.id AS plan_id,
    u.id AS owner_id,
    
-- Determine the type of plan: Savings or Investment
    CASE
        WHEN p.is_regular_savings THEN 'Savings'
        ELSE 'Investments'
    END AS type,

-- Get the most recent/ last transaction date formatted as '%Y-%m-%d'
    DATE_FORMAT(MAX(s.transaction_date), '%Y-%m-%d') AS last_transaction_date,

-- Calculate the number of days since the last transaction
-- CURDATE() - to get the current date
    DATEDIFF(CURDATE(), MAX(s.transaction_date)) AS inactivity_days
FROM
    plans_plan p
        INNER JOIN
    users_customuser u ON p.owner_id = u.id
        INNER JOIN
    savings_savingsaccount s ON p.id = s.plan_id
WHERE
-- Include only active users
    u.is_active = 1 
-- Include only Savings and Investment plans
        AND (p.is_regular_savings = 1
        OR p.is_a_fund = 1)
GROUP BY p.id , u.id , type

-- Include only plans that have been inactive for more than 365 days
HAVING inactivity_days > 365