-- Inventory Management System: Step-by-Step Guide for MySQL Workbench
-- Setting up the database
create database if not  exists Inventory_DB;

-- Using the database
use Inventory_DB;

-- Creating 'Suppliers' Table
create table Suppliers
( 
Supplier_ID int primary key auto_increment,
Supplier_Name varchar(255) not null,
Contact_Name varchar(255),
Phone_No varchar(20),
Email varchar(255) unique
);

-- Creating 'Products' Table
create table Products
(
Product_ID int primary key auto_increment,
Product_Name varchar(255) not null,
`Description` text,
Price decimal(10, 2) not null,
Supplier_ID int not null,
foreign key(Supplier_ID) references Suppliers(Supplier_ID)
);

-- Creating 'Stock' Table
create table Stock
( Stock_ID int primary key auto_increment,
Product_ID int unique not null,             -- Each product has one stock entry
Qty_in_hand int default 0,
Reorder_Point int default 10,               -- Threshold to trigger reorder
Last_Updated timestamp default current_timestamp on update current_timestamp,
foreign key(Product_ID) references Products(Product_ID)
);

-- Inserting into 'Suppliers' Table
insert into Suppliers(Supplier_Name, Contact_Name, Phone_No, Email)
values ('Tech Gadgets Inc.', 'John Doe', '555-1001', 'john.doe@techgadgets.com'),
('Office Supplies Co.', 'Jane Smith', '555-1002', 'jane.smith@officesupplies.com'),
('Book Distributors Ltd.', 'Peter Jones', '555-1003', 'peter.jones@books.com');

-- Reading 'Suppliers' Table
select * from Suppliers;

select * from Suppliers
where Supplier_Name = 'Tech Gadgets Inc.';

-- Updating 'Suppliers' Table
update Suppliers 
set Phone_No = '555-2001'
where Supplier_ID = 1;

-- Delete a supplier (ensure no products are linked to this supplier first, or handle ON DELETE CASCADE)
delete from Suppliers 
where Supplier_ID = 3;

-- Inserting into 'Products' Table
insert into Products(Product_Name, `Description`, Price, Supplier_ID)
values ('Wireless Mouse', 'Ergonomic wireless mouse', 25.99, 1),
('Mechanical Keyboard', 'RGB mechanical keyboard with blue switches', 79.99, 1),
('Notebook (A4)', 'A4 size ruled notebook, 100 pages', 3.50, 2),
('Pens (Pack of 10)', 'Blue ink ballpoint pens', 5.00, 2);

-- Reading 'Products' Table
select * from Products;

select P.Product_Name , P.Price,
S.Supplier_Name, S.Phone_No
from Products as P
inner join Suppliers as S
on P.Supplier_ID = S.Supplier_ID;

-- Updating 'Products' Table
update Products 
set Price = 22.99
where Product_ID = 1;

update Products 
set `Description` = 'High-Quality A4 notebook'	
where Product_ID = 3;

-- Delete a product (ensure no stock entries are linked to this product first)
DELETE FROM Products 
WHERE product_id = 4;

-- Inserting into 'Stock' Table
-- Initial stock for Wireless Mouse (product_id 1)
insert into Stock(Product_ID, Qty_in_hand, Reorder_Point)
values (1, 50, 15);

-- Initial stock for Mechanical Keyboard (product_id 2)
insert into Stock(Product_ID, Qty_in_hand, Reorder_Point)
values (2, 20, 10);

-- Initial stock for Notebook (A4) (product_id 3)
insert into Stock(Product_ID, Qty_in_hand, Reorder_Point)
values(3, 100, 20);

-- Reading 'Stock' Table
select * from Stock;

select P.Product_Name, S.Qty_in_hand, S.Reorder_Point, S.Last_Updated
from Stock as S
inner join Products as P
on S.Product_Id = P.Product_ID; 

-- Update quantity on hand for a product (e.g., after a sale)
UPDATE Stock 
SET Qty_in_hand = 45 
WHERE product_id = 1;

-- Update reorder point for a product
UPDATE Stock 
SET reorder_point = 5 
WHERE product_id = 2;

-- Delete a specific stock entry
DELETE FROM Stock WHERE stock_id = 3;

-- ---------------------
## Queries

-- Query 1: Query to identify low-stock items (quantity on hand below reorder point)
select P.Product_Name, S.Qty_in_hand, S.Reorder_Point, Sup.Supplier_Name
from Stock as S
inner join Products as P 
on P.Product_ID = S.Product_ID
inner join Suppliers as Sup
on Sup.Supplier_ID = P.Supplier_ID
where S.Qty_in_hand < S.Reorder_Point;

-- Query 2: Query to find products from a specific supplier
select P.Product_name, P.`Description`, P.Price,
S.Qty_in_hand
from Products as P
inner join Suppliers as Sup
on P.Supplier_ID = Sup.supplier_id
LEFT JOIN Stock AS S 
ON P.product_id = S.product_id
WHERE Sup.supplier_name = 'Tech Gadgets Inc.';                 -- Replace with the supplier name you want to search for

-- Query 3: Query to view total quantity and value of all products
select sum(S.Qty_in_hand) as Total_Items_in_Stock,
sum(S.Qty_in_hand * P.Price) as Total_Inventory_Value
from Stock as S
inner join Products as P
on S.Product_ID = P.Product_ID;

-- Dropping the database
drop database Inventory_DB;

-- ------------------------X----------------------


