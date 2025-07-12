/*
ニニニニニニニニニニニニニニニニニニニニニニニニニニニニニニ
Customer Report
Purpose:
- This report consolidates key customer metrics and behaviors
Highlights:
1. Gathers essential fields such as names, ages, and transaction details.
2. Segments customers into categories (VIP, Regular, New) and age groups.
3. Aggregates customer-level metrics:
- total orders
- total sales
- total quantity purchased
- total products
- lifespan (in months)
4. Calculates valuable KPIs:
- recency (months since last order)
- average order value
- average monthly spend
ニニニニニニニニニニニニニニニニニニニニニニニニニニニニニニ */

with base_query as (
-- Base Query : Retreives core coulmns
	select 
		f.order_number,
		f.product_key,
		f.order_date,
		f.sales_amount,
		f.quantity,
		c.customer_key,
        c.customer_number,
		concat(c.first_name,' ',c.last_name) Customer_Name,
		timestampdiff(year,c.birthdate,now()) Age
	from fact_sales f
	left join dim_customers c
	on f.customer_key = c.customer_key
	where order_date is not null
)
, customer_aggregation as(
-- 2) Customer aggregation : Summarizes key metrics at the customer level
select
	customer_key,
	customer_number,
	customer_name,
	age,
	count(distinct order_number) AS total_orders,
	sum(sales_amount) total_sales,
	sum(quantity) total_quantity,
	count(distinct product_key) total_products,
	max(order_date) last_order_date,
	timestampdiff(month,min(order_date),max(order_date)) LifeSpan
from base_query
group by
	customer_key,
    customer_number,
    customer_name,
    age
    
)

select
	customer_key,
    customer_number,
    customer_name,
    age,
    case
		when age< 20 then 'Under 20'
        when age between 20 and 29 then '20-29'
        when age between 30 and 39 then '30-39'
        when age between 40 and 49 then '40-49'
		else '50 and above'
	end Age_group,
    case
			when lifespan >= 12 and total_sales >5000 then 'VIP'
			when lifespan >= 12 and total_sales <=5000 then 'Regular'
			else 'New'
	end customer_segment,
    last_order_date,
    timestampdiff(month,last_order_date,now()) recency,
	total_orders,
	total_sales,
	total_quantity,
	total_products,
	LifeSpan,
    -- compute average order value
    case 
		when total_orders = 0 then 0
		else total_sales/total_orders 
	end as avg_order_value,
	-- compute average monthly spend
    case 
		when lifespan = 0 then total_sales
		else total_sales/lifespan
	end AS avg_monthly_spend

from customer_aggregation

    