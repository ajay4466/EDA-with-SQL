-- Cumulative Analysis
-- Total Sales and running total sales over time
select
	OrderDate,
    TotalSales,
    sum(TotalSales) over(partition by year(OrderDate) order by OrderDate) As RunningTotalSales,
	round(avg(AvgPrice) over(partition by year(OrderDate) order by OrderDate),0) As MovingAvgPrice

from
(
	select 
		date_format(order_date,'%Y-%m-01') OrderDate,
		sum(sales_amount) TotalSales,
        avg(price) AS AvgPrice
	from fact_sales
	where Order_Date is not null
	group by date_format(order_date,'%Y-%m-01')
	order by date_format(order_date,'%Y-%m-01')
)t    