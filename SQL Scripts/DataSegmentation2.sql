/*Group customers into three segments based on their spending behavior:
- VIP: at least 12 months of history and spending more than 5,000.
- Regular: at least 12 months of history but spending 5,000 or less.
- New: lifespan less than 12 months. */
with customer_spending as (
select 
	c.customer_key,
	sum(f.sales_amount) as total_spending,
	min(order_date) firstorder,
	max(order_date) lastorder,
	TIMESTAMPDIFF(month,min(order_date),max(order_date)) as lifespan
from fact_sales f
left join dim_customers c
on f.customer_key = c.customer_key
group by customer_key
)
select
	customer_segment,
    count(customer_key) as TotalCustomer
from 
(
	select 
		customer_key,
		total_spending,
		lifespan,
		case
			when lifespan >= 12 and total_spending >5000 then 'VIP'
			when lifespan >= 12 and total_spending <=5000 then 'Regular'
			else 'New'
		end customer_segment
	from customer_spending
)t
group by customer_segment
