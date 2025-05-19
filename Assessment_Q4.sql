SELECT
    u.id AS customer_id,
    
-- Concatenate the First Name and Last Name of the Customer
    CONCAT(u.first_name, ' ', u.last_name) AS name,

-- Extract the difference between sign up date and current date in Months
-- TIMESTAMPDIFF(MONTH, start_date, end_date) calculates the difference in Months
    TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,
    
-- Sum the confirmed_amount for each customer rounded to whole number
    ROUND(SUM(s.confirmed_amount),0) AS total_transaction,

-- Calcualate the estimated_clv for each customer rounded to 2 decimal places
    ROUND((SUM(s.confirmed_amount) * 1.0 / TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE())) * 12 * 0.001,2) AS estimated_clv
FROM
    users_customuser u
        INNER JOIN
    savings_savingsaccount s ON u.id = s.owner_id -- Join users_customuser and savings_savingsaccount table on the customer ID
GROUP BY u.id , name , tenure_months
ORDER BY estimated_clv DESC