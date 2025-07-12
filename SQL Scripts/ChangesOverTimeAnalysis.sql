-- Changes Over Time Analysis
-- We get clear picture how sales are going year on year, month on month
select 
	year(order_date) AS OrderYear,
	sum(Sales_amount) AS TotalSales,
    count(distinct customer_key) AS TotalCustomer,
    sum(quantity) as TotalQuantity
    from fact_sales
where order_date is not null
group by year(order_date)
order by year(order_date)

-- In this used date_format but since months are not in integer they are not sorted properly
select 
	date_format(order_date,'%Y-%b') AS OrderYear,
	sum(Sales_amount) AS TotalSales,
    count(distinct customer_key) AS TotalCustomer,
    sum(quantity) as TotalQuantity
    from fact_sales
where order_date is not null
group by date_format(order_date,'%Y-%b')
order by date_format(order_date,'%Y-%b')
