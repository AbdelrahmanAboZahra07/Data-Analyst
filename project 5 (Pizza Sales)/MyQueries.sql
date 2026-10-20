--select 
--	COLUMN_NAME				 as [column name],
--	DATA_TYPE				 as [the type],
--	character_maximum_length as [length]
--from 
--	information_schema.columns	
--where 
--	table_name = 'pizza_sales'

----------------------------------------------------------------------------

--alter table pizza_sales
--alter column pizza_id int;

--alter table pizza_sales
--alter column order_id int;

--alter table pizza_sales
--alter column pizza_name_id varchar(255);

--alter table pizza_sales
--alter column quantity int;

--alter table pizza_sales
--alter column order_time time;

--alter table pizza_sales
--alter column pizza_size varchar(255);

--alter table pizza_sales
--alter column pizza_category varchar(255);

--alter table pizza_sales
--alter column pizza_ingredients varchar(255);

--alter table pizza_sales
--alter column pizza_name varchar(255);

--> KPI's
----------------------------------------------------------------------------
-- Total Table 

select * from pizza_sales

----------------------------------------------------------------------------
-->1 Total Revenue

select sum(total_price) as 'Total Revenue' from pizza_sales

----------------------------------------------------------------------------
-->2 Average Order Value

select sum(total_price) / count(distinct(order_id)) as 'Average Order Value'
from pizza_sales

----------------------------------------------------------------------------
-->3 Total Pizza Sold

select sum(quantity) as 'Total Pizza Sold' from pizza_sales

----------------------------------------------------------------------------
-->4 Total Orders

select count(distinct(order_id)) as 'Total Orders' from pizza_sales

----------------------------------------------------------------------------
-->5 Average Pizzas Per Orders

select cast(cast(sum(quantity) as decimal(10,2)) / cast(count(distinct(order_id)) as decimal(10,2)) as decimal(10,2)) as 'Average Pizzas Per Orders' 
from pizza_sales

----------------------------------------------------------------------------

--> Charts
----------------------------------------------------------------------------
--> Trend by Date For Total Orders

select count(distinct(order_id)) as 'Total Orders' , order_date
from pizza_sales
group by order_date
order by order_date

----------------------------------------------------------------------------
--> Orders by Day Of Week

select datename(DW, order_date) as 'Day Of Week', count(distinct(order_id)) as 'Total Number Of Orders'
from pizza_sales
group by datename(DW, order_date)

----------------------------------------------------------------------------
--> Orders by Month

select datename(MONTH, order_date) as 'Months', count(distinct(order_id)) as 'Total Number Of Orders'
from pizza_sales
group by datename(MONTH, order_date)

----------------------------------------------------------------------------
--> Percentage Of Sales By Pizza Category 

select distinct(pizza_category), 
cast(sum(total_price) as decimal(10,2)) as 'Total Revenue',
cast(cast(sum(total_price) as decimal(10,2)) * 100 / (select sum(total_price) from pizza_sales)as decimal(10,2)) as 'Percentage Of Sales By Pizza Category'
from pizza_sales
group by pizza_category

----------------------------------------------------------------------------
--> Percentage Of Sales By Pizza Size

select distinct(pizza_size), 
cast(sum(total_price) as decimal(10,2)) as 'Total Revenue',
cast(cast(sum(total_price) as decimal(10,2)) * 100 / (select sum(total_price) from pizza_sales)as decimal(10,2)) as 'Percentage Of Sales By Pizza Size'
from pizza_sales
group by pizza_size

----------------------------------------------------------------------------
--> Total Pizzas Sold by Pizza Category

select distinct(pizza_category),
sum(quantity) as 'Total Pizzas Sold by Pizza Category'
from pizza_sales
group by pizza_category

----------------------------------------------------------------------------
--> Top 5 Best Sellers By Revenue

select Top 5 pizza_name, sum(total_price) as 'Total Revenue'
from pizza_sales
group by pizza_name
order by 'Total Revenue' desc

----------------------------------------------------------------------------
--> Bottom 5 Sellers By Revenue

select Top 5 pizza_name, sum(total_price) as 'Total Revenue'
from pizza_sales
group by pizza_name
order by 'Total Revenue' asc

----------------------------------------------------------------------------
--> Top 5 Best Sellers By Total Quantity

select Top 5 pizza_name, 
sum(quantity) as 'Total Quantity'
from pizza_sales
group by pizza_name
order by 'Total Quantity' desc

----------------------------------------------------------------------------
--> Bottom 5 Sellers By Total Quantity

select Top 5 pizza_name, 
sum(quantity) as 'Total Quantity'
from pizza_sales
group by pizza_name
order by 'Total Quantity' asc

----------------------------------------------------------------------------
--> Top 5 Best Sellers By Total Orders

select Top 5 pizza_name, 
count(distinct order_id) as 'Total Orders'
from pizza_sales
group by pizza_name
order by 'Total Orders' desc

----------------------------------------------------------------------------
--> Bottom 5 Sellers By Total Orders

select Top 5 pizza_name, 
count(distinct order_id) as 'Total Orders'
from pizza_sales
group by pizza_name
order by 'Total Orders' asc

----------------------------------------------------------------------------