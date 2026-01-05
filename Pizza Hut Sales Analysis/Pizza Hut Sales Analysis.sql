-- Standard Creation Queries 
create database if not exists Pizza_Hut;
use Pizza_Hut;
drop database Pizza_Hut;

select * from Pizzas;
select * from Pizza_Types;

create table Orders
(
Order_ID int not null, 
Order_Date date not null, 
Order_Time time not null, 
primary key (Order_ID)
);
select * from Orders;

create table Order_Details
(
Order_Details_ID int not null,
Order_ID int not null,
Pizza_ID text not null, 
Quantity int not null,
primary key (Order_Details_ID)
);
drop table Order_Details;
select * from Order_Details;

-- Basic Queries:
-- Q1: Retrieve the total number of orders placed. 
select count(Order_ID) as Total_Orders from Orders;

-- Q2: Calculate the total revenue generated from pizza sales.
select round(sum(Order_Details.Quantity * Pizzas.Price), 2) as Total_Sales
from Order_Details 
join Pizzas 
on Pizzas.Pizza_ID = Order_Details.Pizza_ID;

-- Q3:  Identify the highest-priced pizza.
select Pizza_Types.`Name`, Pizzas.Price
from Pizza_Types
join Pizzas
on Pizza_Types.Pizza_Type_ID = Pizzas.Pizza_Type_ID
order by Pizza.Price desc
limit 1;

-- Q4: Identify the most common pizza size ordered.
select Pizzas.Size, count(Order_Details.Order_Details_ID) as Order_Count
from Pizzas
join Order_Details
on Pizzas.Pizza_ID = Order_Details.Pizza_ID
group by Pizzas.Size
order by Order_Count desc;

-- Q5: List the top 5 most ordered pizza types along with their quantities.
select Pizza_Types.Name, sum(Order_Details.Quantity) as Quantity
from Pizza_Types
join Pizzas
on Pizzas.Pizza_Type_ID = Pizzas_Types.Pizza_Type_ID
join Order_Details
on Order_Details.Pizza_ID = Pizzas.Pizza_ID
group by Pizza_Types.Name
order by Quantity desc
limit 5;

-- Intermediate Queries:
-- Q1: Join the necessary tables to find the total quantity of each pizza category ordered.
select Pizza_Types.Category, sum(Order_Details.Quantity) as Quantity
from Pizza_Types
join Pizzas
on Pizza.Pizza_Type_ID = Pizza_Types.Pizza_Type_ID
join Order_Details
on Order_Details.Pizza_ID = Pizzas.Pizza_ID
group by Pizza_Types.Category
order by Quantity desc;

-- Q2: Determine the distribution of orders by hour of the day.
select hour(Order_Time) as Hours, count(Order_ID) as Order_Count
from Orders
group by hour(Order_Time);

-- Q3: Join relevant tables to find the category-wise distribution of pizzas.
select Category, count(Name) as Total_Names
from Pizza_Types
group by Category;

-- Q4: Group the orders by date and calculate the average number of pizzas ordered per day.
select round(avg(Quantity), 0) as Avg_Pizza_Ordered_Per_Day
from (select Orders.Order_Date, sum(Order_Details.Quantity) as Quantity
	  from Orders
	  join Order_Details
      on Orders.Order_ID = Order_Details.Order_ID
      group by Orders.Order_Date) as Order_Quantity;
      
-- Q5: Determine the top 3 most ordered pizza types based on revenue.
select Pizza_Types.Name, sum(Order_Details.Quantity * Pizzas) as Revenue
from Pizza_Types
join Pizzas
on Pizzas.Pizza_Type_ID = Pizzas_Types.Pizza_Type_ID
join Order_Details
on Order_Details.Pizza_ID = Pizzas.Pizza_ID
group by Pizza_Types.Name
order by Revenue desc
limit 3;

-- Advanced Queries:
-- Q1: Calculate the percentage contribution of each pizza type to total revenue.
select Pizza_Types.Category, round(sum(Order_Details.Quantity * Pizzas.Price) / (select round(sum(Order_Details.Quantity * Pizzas.Price), 2) as Total_Sales
																				 from Order_Details
                                                                                 join Pizzas
                                                                                 on Pizzas.Pizza_ID = Order_Details.Pizza_ID) * 100, 2) as Revenue
from Pizza_Types
join Pizzas
on Pizzas.Pizza_Type_ID = Pizza_Types.Pizza_Type_ID
join Order_Details
on Order_Details.Pizza_ID = Pizzas.Pizza_ID
group by Pizza_Types.Category
order by revenue desc;

-- Q2: Analyze the cumulative revenue generated over time.
select Order_Date, sum(revenue) over(order by Order_Date) as Cum_Revenue
from
(select Orders.Order_Date, sum(Order_Details.Quantity * Pizzas.Price) as Revenue
from Order_Details
join Pizzas
on Order_Details.Pizza_ID = Pizzas.Pizza_ID
join Orders
on Orders.Order_ID = Order_Details.Order_ID
group by Orders.Order_Date) as Sales;

-- Q3: Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select Name, Revenue from 
(select Category, Name, Revenue, rank() over(partition by Category order by Revenue desc) as rn
from 
(select Pizza_Types.Category, Pizza_Types.Name, sum((Order_Details.Quantity) * Pizzas.Price) as Revenue
from Pizza_Types
join Pizzas
on Pizzas.Pizza_Type_ID = Pizza_Types.Pizza_Type_ID
group by Pizza_Types.Category, Pizza_Types.Name) as a) as b
where rn <= 3;