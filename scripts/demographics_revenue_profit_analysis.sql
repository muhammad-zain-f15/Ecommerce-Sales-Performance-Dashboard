-- Demographics Revenue and Profit Analysis (Insights + Recommendations)

-- 1. revenue contribution by country, gender and marital status
with revenue_contribution as
(
select
country,
gender,
marital_status,
round(cast(sum(cr.total_sales) as float)/(select sum(total_sales) from gold.customers_report) *100,2) as sales_per,
round(cast(sum(cr.total_profit) as float)/(select sum(total_profit) from gold.customers_report) *100,2) as profit_per
FROM gold.dim_customers c
join gold.customers_report cr
on c.customer_key = cr.customer_key
GROUP BY country,gender,marital_status
)
SELECT
*,
SUM(sales_per) over	(partition by country) as country_sales_contribution,
SUM(profit_per) over	(partition by country) country_profit_contribution
FROM revenue_contribution
order by country,sales_per desc,profit_per desc
/*
-- United States (31.22% Sales and 31.8% Profit Contribution)
	Highest Sales and profit contributor:
	1. Married Male (8.51% and 8.72%)
	2. Single Female (8.1% and 8.2%)

--Austrailia (30.87 %  Sales Contribution and 30.31% Profit Contribution)
	Highest sales and profit contributor: 
	1. Single Female (9.13% and 8.99%)
	2. Married Male(7.72% and 7.61%)

-- United Kingdom(11.55% and 11.47%)
	Highest Sales and Profit Contributor:
	1. Married Male (3.6% and 3.58%)
	2. Married Female(3.3% and 3.28%)

-- Germany (9.85 % Sales and 9.84% Profit Contribution)
	Highest sales and profit contributor:
	1. Married Female (2.96% and 2.97%)
	2. Married male (2.43% and 2.42%)

-- Canada (6.73 % Sales and 6.95 % Profit Contribution)
	Highest sales and profit contributor: 
	1. Married Male (1.95% and 2.02 %)
	2. Single Female (1.72% and 1.77%)

-- France (9 % Sales and 8.9% Profit Contribution)
	Highest sales and profit contributor:
	1. Married Female(2.24% and 2.25%)
	2. Single Male (2.12% and 2.07%)

*/

/*

Recommendation
Targeted and more Personalized Marketing to highest sales and profit contributor can
increase revenue

*/
-- Distribution of customers by country, gender and marital status
with customer_distribution_cte as
(
	select
	country,
	gender,
	marital_status,
	round(cast(count(customer_key) as float)/ (select count(customer_key) from gold.dim_customers)*100,2) customer_distribution_per
	FROM gold.dim_customers
	group by country,gender,marital_status
	
)
-- male and female distributions are fairly balanced across countries
select 
*,
sum(customer_distribution_per)over (partition by country) as country_customer_distribution_per

FROM customer_distribution_cte
order by country



