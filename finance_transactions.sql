--- Show all data from the table. Verify everything loaded correctly.
SELECT * FROM finance_transactions;

--- Show total revenue per month, oldest to newest.
with monthly as (
select DATE_TRUNC('month', date) as month,
SUM(amount) as total_revenue
FROM finance_transactions
group by DATE_TRUNC ('month', date)
)

SELECT month, total_revenue,
      LAG (total_revenue) OVER (ORDER BY month) as old_month,
	  LEAD (total_revenue) OVER (ORDER BY month) as new_month
FROM monthly
ORDER BY month ASC;

---Show total revenue per year.
SELECT 
       EXTRACT( year FROM DATE_TRUNC('year', date )) as year,
	   SUM(amount) AS total_revenue
FROM finance_transactions
GROUP BY DATE_TRUNC('year', date )
ORDER BY year ASC;

---Show top 5 clients by total revenue.
SELECT client_name, SUM(amount) as total_revenue
FROM finance_transactions
GROUP BY client_name
ORDER BY SUM(amount) DESC
LIMIT 5;

--- Rank clients by total revenue, highest to lowest.
SELECT client_name, 
   SUM(amount) as total_revenue,
   RANK() OVER (ORDER BY SUM(amount) DESC)
FROM finance_transactions
GROUP BY client_name;


--- Show month-over-month revenue change.
WITH monthly AS (
SELECT 
    EXTRACT (year FROM DATE_TRUNC('year', date ) ) AS year,
    EXTRACT (month FROM DATE_TRUNC('month', date ) ) AS month,
	SUM(amount) AS total_revenue
FROM finance_transactions
GROUP BY DATE_TRUNC('month', date), DATE_TRUNC('year', date )
ORDER BY month 
),
monthly_lag AS (
SELECT month, total_revenue, year,
  LAG(total_revenue) OVER (ORDER BY month) AS per_month
FROM monthly
)

SELECT year, month, total_revenue, per_month,
    total_revenue - per_month AS MOM_change
FROM monthly_lag
ORDER BY year DESC, month;

--- Show running total of revenue ordered by date.
SELECT date,
  SUM(amount) OVER (ORDER BY date) AS running_total
FROM finance_transactions;











