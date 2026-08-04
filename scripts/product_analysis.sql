-- Porducts with no sales 
SELECT
c.country,
p.category,
p.product_name,
coalesce(sum(f.sales_amount),0) as sales
from gold.dim_products p
full join gold.fact_sales f
on p.product_key = f.product_key
full join gold.dim_customers c
on f.customer_key = c.customer_key
group by c.country,p.category, p.product_name
having  coalesce(sum(f.sales_amount),0)!= 0 and category = 'Accessories'
order by sales



-- top and bottom products
SELECT
p.category,
p.product_name,
sum(f.quantity) as quantity_sold,
count(distinct f.order_number) as order_count,
coalesce(sum(f.sales_amount),0) as total_sales,
sum(f.sales_amount)-sum(p.cost*quantity)	as total_profit
from gold.dim_products p
 left join gold.fact_sales f
on p.product_key = f.product_key
left join gold.dim_customers c
on f.customer_key = c.customer_key
group by p.category, p.product_name
having  coalesce(sum(f.sales_amount),0)!= 0 and category = 'Accessories' 
order by total_sales


-- no of items per order
with items_count_cte as
(
select
order_number,
sum(quantity) as no_of_items_sold
from gold.fact_sales
group by order_number
)
select
count(order_number) as orders_occurrences,
no_of_items_sold
from items_count_cte
group by no_of_items_sold
order by no_of_items_sold asc


select
c.customer_number,
c.first_name,c.last_name,
count(distinct order_number) as no_of_orders,
sum(sales_amount) as total_sales
FROM gold.fact_sales f
left join gold.dim_customers c
on f.customer_key = c.customer_key 
group by c.customer_number,c.first_name,c.last_name 
order by no_of_orders desc;

select
order_number,
count(*)
from gold.fact_sales
group by order_number 
having count(*) >1

-- check if there is any products having price less than the cost
select
*
from gold.fact_sales f
left join gold.dim_products p 
on f.product_key = p.product_key
where f.price < p.cost

-- which country has highest sales of accessories
select
country, 
 gender,
sum(sales_amount) bikes_sales
from gold.fact_sales f 
inner join gold.dim_products p 
on f.product_key = p.product_key 
and p.category = 'Bikes'
inner join gold.dim_customers c 
on f.customer_key = c.customer_key 
group by country,gender
order by bikes_sales desc


select
category,
sum(sales_amount) total_sales,
sum(f.quantity) total_quantity
from gold.fact_sales f 
inner join gold.dim_products p 
on f.product_key = p.product_key 
and year(f.order_date) = 2013
inner join gold.dim_customers c 
on f.customer_key = c.customer_key
and year(f.order_date) = 2013
group by category 
order by total_sales desc


-- min price of accessory
select 
	category,
	max(cost) max_cost,
	max(price) max_price
FROM gold.fact_sales f
left join gold.dim_products p
on f.product_key = p.product_key 
group by category

select * from gold.dim_products;

select distinct
category,
count(distinct product_name) no_of_products
FROM gold.fact_sales f
left join gold.dim_products p
on f.product_key = p.product_key 
where year(order_date) < year(start_date)
group by category

