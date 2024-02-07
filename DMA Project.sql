#1.Identifying the district with the highest average balance 
SELECT a.district_id, d.A2 AS district_name, AVG(t.balance) AS average_balance 
FROM trans t 
JOIN account a ON t.account_id = a.account_id 
JOIN district d ON a.district_id = d.district_id 
GROUP BY a.district_id, d.A2 
ORDER BY average_balance DESC 
LIMIT 1; 

#2.Determine the most common operation type in transactions 
SELECT operation, COUNT(*) AS operation_count 
FROM trans 
WHERE operation IS NOT NULL 
GROUP BY operation 
ORDER BY operation_count DESC 
LIMIT 1; 

#3. List the top 10 districts with the highest total population 
SELECT A2 AS district_name, SUM(A4) AS total_population 
FROM district 
GROUP BY district_name 
ORDER BY total_population DESC 
LIMIT 10; 

#4.Calculate the total amount of payments for each loan status 
SELECT status, SUM(amount) AS total_payments 
FROM loan 
WHERE status IS NOT NULL 
GROUP BY status; 

#5.Identify the most common card type among clients 
SELECT type, COUNT(*) AS card_count 
FROM card 
WHERE type IS NOT NULL 
GROUP BY type 
ORDER BY card_count DESC 
LIMIT 1; 

#6.Retrieve Loan information, client demographics and transaction amounts
SELECT c.client_id, c.gender, c.birth_date, l.loan_id, l.amount AS loan_amount, l.duration AS loan_duration, l.payments AS loan_payments, 
AVG(t.amount) AS avg_transaction_amount 
FROM client c 
JOIN disp d ON c.client_id = d.client_id 
JOIN account a ON d.account_id = a.account_id 
LEFT JOIN loan l ON a.account_id = l.account_id 
LEFT JOIN trans t ON a.account_id = t.account_id 
GROUP BY c.client_id, l.loan_id 
LIMIT 10; 

#7.Credit Card Usage Patterns: Can we identify segments based on card usage behaviors or transaction frequencies? 
SELECT c.client_id, c.gender, 
COUNT(t.trans_id) AS transaction_count, 
CASE 
        WHEN COUNT(t.trans_id) >= 50 THEN 'High Frequency' 
        WHEN COUNT(t.trans_id) >= 20 AND COUNT(t.trans_id) < 50 THEN 'Medium Frequency' 
        WHEN COUNT(t.trans_id) < 20 THEN 'Low Frequency' 
        ELSE 'No Transactions' -- Handle cases where there are no transactions 
    END AS usage_segment 
FROM client c 
JOIN disp d ON c.client_id = d.client_id 
JOIN account a ON d.account_id = a.account_id 
LEFT JOIN trans t ON a.account_id = t.account_id 
GROUP BY c.client_id, c.gender 
LIMIT 10;

#8. Loan Performance by Demographics: Are there patterns in loan repayment based on client demographics? 
SELECT c.gender, 
AVG(CASE WHEN l.status = 'A' THEN 1 ELSE 0 END) AS average_repayment 
FROM client c 
JOIN disp d ON c.client_id = d.client_id 
JOIN account a ON d.account_id = a.account_id 
JOIN loan l ON a.account_id = l.account_id 
GROUP BY c.gender; 

#9. Loan Portfolio Analysis: What is the distribution of loan amounts, interest rates, and terms across different districts or customer segments? 
SELECT d.district_id,d.A2 AS district_name, 
AVG(l.amount) AS average_loan_amount, 
AVG(l.duration) AS average_loan_term 
FROM district d 
JOIN account a ON d.district_id = a.district_id 
JOIN loan l ON a.account_id = l.account_id 
GROUP BY d.district_id, d.A2 
ORDER BY district_id 
LIMIT 10; 

#10. Client Age Distribution: Analyzing the distribution of client ages 
SELECT FLOOR(DATEDIFF(CURDATE(), c.birth_date) / 365) AS age, 
COUNT(client_id) AS client_count 
FROM client c 
GROUP BY age 
ORDER BY age
LIMIT 10; 