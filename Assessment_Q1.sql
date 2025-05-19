SELECT 
    p.owner_id,
    
-- Concatenate the First Name and Last Name of the Customer
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    
-- Count Unique funded Savings plan_id
    COUNT(DISTINCT CASE
            WHEN is_regular_savings = 1 THEN p.id
        END) AS savings_count,
        
-- Count Unique funded Investment plan_id
    COUNT(DISTINCT CASE
            WHEN is_a_fund = 1 THEN p.id
        END) AS investment_count,

-- Sum confirmed_amount for all funded savings and investment accounts
    ROUND(SUM(confirmed_amount),2) AS total_deposits
FROM
    plans_plan AS p
        INNER JOIN
    users_customuser AS u ON p.owner_id = u.id -- Join plans_plan with users_customuser on owner_id
        INNER JOIN
    savings_savingsaccount AS s ON p.id = s.plan_id -- Join savings_savingsaccount on plan_id
    
-- Filter only rows that are either a Savings plan or an Investment plan
WHERE is_regular_savings = 1 OR is_a_fund = 1 
GROUP BY p.owner_id , name

-- Extract only customers that have at least one funded Savings account AND at least one funded Investment account
HAVING savings_count >= 1 AND investment_count >= 1 
ORDER BY total_deposits DESC;