# DataAnalytics-Assessment


##  Assessment_Q1: High-Value Customers with Multiple Products
To get high value customers with multiple products, the **`plans_plan`** table is joined to the **`users_customuser`** table on **`owner_id`**,
and the **`savings_savingsaccount`** table on **`plan_id`**.
Only rows with funded Savings plan (**`is_regular_savings`** = 1) or funded Investment plan (**`is_a_fund`** = 1) are selected.
Then, the **`owner_id`** and **name** of the customers (**`first_name`** and **`last_name`**) concatenated using the **`CONCAT()`** function,
the unique **`plan_id`** for both the saving and investment plan is counted to get the number of savings and invstment plans each customers operate with
the sum of the **`confirmed_amount`** for each customer on their Savings and Investment plan.
Lastly, only each customers that have at least one savings and at least one investment plan is filtered then sorted by the **`total_deposits`** in **`DESC`** order.

#### Sample Output:
|         owner_id                |     name        | savings_count | investment_count | total_deposits |
|---------------------------------|-----------------|---------------|------------------|----------------|
| 1909df3eba2548cfa3b9c270112bd262| Chima Ataman    |        3      |      8           |33631711883.37  |
| 5572810f38b543429ffb218ef15243fc| Obi David       |        86     |      47          |29558416805.62  |
| 0257625a02344b239b41e1cbe60ef080| Opeoluwa Popoola|       211     |      18          |15809881887     |
| 75cb72d217324ace976cb9104d1d2d9c| David dashme    |        27     |      22          |14497408908.37  |
| fdb4471e9f364439b43c3c6b9f05d124| Dollar Po Amusan|        4      |       8          |8758661750      |



##  Assessment_Q2: Account Inactivity Alert
The **average monthly transaction** for each customer is calculated by getting the the total transaction done by the customers using **`COOUNT(savings_id)`** divided by the
total months for all transactions **`COUNT(DISTINCT DATE_FORMAT(transaction_date, '%Y-%m'))`**.
The **average monthly transaction** is then categorized in 3 categories with the total number of customers under each category with the average monthly transaction for each category:
- "High Frequency" (>=10 transactions/month)
- "Medium Frequency" (3-9 transactions/month)
- "Low Frequency" (<=2 transactions/month)

#### Challenge:
The question only indicates the **`users_customuser`** and **`savings_savingsaccount`** tables to be used, so transactions from the **`withdrawals_withdrawal`** table were not included.

#### Output:
|frquency_category|customer_category|avg_transactions_per_month|
|-----------------|-----------------|--------------------------|
| High Frequnecy  |     141         |       44.5               |
| Medium Frequnecy|     181         |        4.7               |
| Low Frequency   |     211         |       1.3                |



##  Assessment_Q3: Account Inactivity Alert
To get accounts with inactivity for more than a year, first the **`plans_plan`**, **`users_customuser`** and **`savings_savingsaccount`** are joined on **`owner_id`** and **`plan_id`**.
Only active users (**`is_active`** = 1) with either Savings plan (**`is_regular_savings`** = 1) or Investment plan (**`is_a_fund`** = 1) are selected.
The type of plan (**Savings** or **Investment**) is determined by checking if the the plan is either **`is_regular_savings`** or **`is_a_fund`**.
Then the **last_transaction_date** is extracted using **`DATE_FORMAT(MAX(transaction_date), '%Y-%m-%d')`** formatted in "%Y-%m-%d" while the **inactivity_days** is calculated using
**`DATEDIFF()`** between the **`CURDATE()`** current date and the **last_transaction_date**. Lastly, only active customers and plans with inactivity for over **365** days are selected.

#### Sample Output:
|          plan_id                |         owner_id                |     type  |last_transaction_date| inactivity_days|
|---------------------------------|---------------------------------|-----------|---------------------|----------------|
| 561ba3f9f8ce43078a5e0add8ca167de| 0081f354fdc54a83abf66579629eba34|Investments|    2022-04-19       |        1126    |
| 340c0e13b0a44d83a091eb4d516c81bf| 014e34f74f004e7aa0be573ade637f28|Investments|    2023-08-09       |         649    |
| 9039f6de8ddf4670921ff8f848cdccce| 014e34f74f004e7aa0be573ade637f28|Savings    |    2023-02-04       |         835    |
| fd8881cdfff74ea4a128829949c1e3fe| 01cec4f5e94d4991b5c79d4142b6313f|Savings    |    2023-08-21       |         637    |
| 037a7722b4ec40eda75f53c30e6eabd6| 0257625a02344b239b41e1cbe60ef080|Savings    |    2018-04-24       |        2582    |



##  Assessment_Q4: Customer Lifetime Value (CLV) Estimation
**Customer Lifetime Value (CLV) Estimation** refers to the process of predicting the total revenue a business can reasonably expect from a single customer account throughout the business relationship.
To  calculate the CLV Estimate for each customers, the **`users_customuser`** and **`savings_savingsaccount`** are joined on **`owner_id`**, the **tenure** in months since sign up by the customer is gotten using **`TIMESTAMPDIFF(MONTH, start_date, end_date)`** which get's the difference between the date the customer joined (**`date_joined`**) and the current date (**`CURDATE()`**) in **MONTHS**.
Then **total_transcation** is calculated as the sum of each customer's **`confirmed_amount`** while the **Estimated CLV** is calculated using the formula: **`(total_transactions / tenure) * 12 * 
avg_profit_per_transaction`**, where **avg_profit_per_transaction** is assumed to be **0.1%**.

#### Challenge:
To calculate **Customer Lifetime Value (CLV)**, the revenue generating transactions are needed. Since it was not explicitly stated and the **`transaction_type_id`** had no mapping to indicate the type of transaction attached to each, I assumed all **`savings_savingsaccount`** transactions generated revenue while **`withdrawals_withdrawal`** transactions didn't generate any revenue.


#### Sample Output:
|         owner_id                |     name        | tenure_months | total_transaction | estimated_clv |
|---------------------------------|-----------------|---------------|-------------------|---------------|
| 1909df3eba2548cfa3b9c270112bd262| Chima Ataman    |        33     |    89031221548    |  32374989.65  |
| 3097d111f15b4c44ac1bf1f4cd5a12ad| Obi Obi         |        25     |    21620376550    |  10377780.74  |
| 5572810f38b543429ffb218ef15243fc| Obi David       |        72     |    38962464411    |  6493744.07   |
| 2b5a91e5b1564426b78c47cd2a8a22f4| First name Last name|       10      |    5000000000    |  6000000     |
| 81294b17ab9b4fe98f76cf438cfe4cc6| Ahmed Dodo      |        20     |    8066000000     |  4839600      |




