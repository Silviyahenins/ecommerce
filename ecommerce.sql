create database ecommerce;
use ecommerce;

create table customers(
customer_id int primary key ,
first_name varchar(200),
last_name varchar(200),
email varchar(200),
address varchar(200)
);

create table products(
product_id int primary key,
name varchar(200),
description varchar(200),
price decimal(10,2),
stock_quantity int
);

create table cart(
cart_id int primary key,
customer_id int,
foreign key (customer_id) references customers(customer_id),
product_id int,
foreign key (product_id) references products(product_id),
quantity int
);

create table orders(
order_id int primary key,
customer_id int,
foreign key (customer_id) references customers(customer_id),
order_date date,
total_price decimal(10,2),
shipping_address varchar(200)
);

create table order_items(
order_item_id int primary key,
order_id int,
foreign key (order_id) references orders(order_id),
product_id int,
foreign key(product_id) references products(product_id),
quantity int,
item_amount decimal(10,2)
);

insert into customers (customer_id,first_name,last_name,email,address)values
(1,"john","doe","johndoe@example.com","123 main st,city"),
(2,"jane","smith","janesmith@example.com","456 Elm St, Town"),
(3,"robert","johnson","robertjohnson@example.com","789 Oak St, Village"),
(4,"sarah","brown","sarahbrown@example.com","101 pine st, suburb"),
(5,"david","lee","davidlee@example.com","234 cedar st, district "),
(6,"laura","hall","laurahall@example.com","567 bitch st, county"),
(7,"michael","davis","michaeldavis@example.com","890 maple st,state"),
(8,"emma","wilson","emmawilson@example.com","321 redwood st, country"),
(9,"william","tayor","williamtayor@example.com","432 spruce st,province"),
(10,"olivia","adams","oliviaadams@example.com","765 fir st, territory");

insert into products(product_id,name,description,price,stock_quantity) values
(1,"laptop","high-performance laptop",800.00,10),
(2,"smartphone","lastest smartphone",600.00,15),
(3,"tablet","portable tablet",300.00,20),
(4,"headphones","noise-cancelling",150.00,30),
(5,"TV","4K smart TV",900.00,5),
(6,"coffee maker","automatic coffee maker",50.00,25),
(7,"refrigerator","energy efficient",700.00,10),
(8,"microwave oven","countertop microwave oven",80.00,15),
(9,"blender","high speed blender",70.00,20),
(10,"vaccum cleaner","bagless vaccum cleaner",120.00,10);

insert into cart (cart_id,customer_id,product_id,quantity) values
(1,1,1,2),
(2,1,3,1),
(3,2,2,3),
(4,3,4,4),
(5,3,5,2),
(6,4,6,1),
(7,5,1,1),
(8,6,10,2),
(9,6,9,3),
(10,7,7,2);

insert into orders (order_id,customer_id,order_date,total_price,shipping_address) values
(1,1,'2023-01-05',1200.00,'123 main st,city'),
(2,2,'2023-01-15',900.00,'456 Elm St, Town'),
(3,3,'2023-03-15',300.00,'789 Oak St, Village'),
(4,4,'2023-04-20',150.00,'101 pine st, suburb'),
(5,5,'2023-05-25',1800.00,'234 cedar st, district'),
(6,6,'2023-06-30',400.00,'567 bitch st, county'),
(7,7,'2023-07-05',700.00,'890 maple st,state'),
(8,8,'2023-08-10',160.00,'321 redwood st, country'),
(9,9,'2023-09-15',140.00,'432 spruce st,province'),
(10,10,'2023-10-20',1400.00,'765 fir st, territory');

insert into order_items (order_item_id, order_id, product_id, quantity,item_amount) values
(1, 1, 1, 2, 1600.00),
(2, 1, 3, 1, 300.00),
(3, 2, 2, 3, 1800.00),
(4, 3, 5, 2, 1800.00),
(5, 4, 4, 4, 600.00),
(6, 4, 6, 1, 50.00),
(7, 5, 1, 1, 800.00),
(8, 5, 2, 2, 1200.00),
(9, 6, 10, 2, 240.00),
(10, 6, 9, 3, 210.00);

-- 1. update refrigerator product price  to 800

update products set price=800 
where name="refrigerator";

-- 2.remove all cart items for a specific customer

delete from cart 
where customer_id=3;

-- 3. retrieve products priced below 100

select* from products 
where price < 100;

-- 4.Find Products with Stock Quantity Greater Than 5.
SELECT * FROM products
WHERE stockQuantity > 5;
 
-- 5.Retrieve Orders with Total Amount Between $500 and $1000
select * from orders
where total_amount between 500 and 1000;

-- 6.Find Products which name end with letter ‘r

select * from products
where right(name, 1) = 'r';

-- 7.Retrieve Cart Items for Customer 5.
select * from cart
where customer_id = 5;

-- 8.Find Customers Who Placed Orders in 2023
select distinct c.*
from customers c
join orders o on c.customer_id = o.customer_id
where year (orderDate) = 2023;

-- 9.Determine the Minimum Stock Quantity for Each Product Category
select name, MIN(stockQuantity) AS min_stock
from products
group by name;

-- 10.Calculate the Total Amount Spent by Each Customer
select customer_id, SUM(total_price) as total_spent
from orders
group by customer_id;

-- 11.Find the Average Order Amount for Each Customer

SELECT customer_id, AVG(total_price) as avg_order
from orders
GROUP BY customer_id;

-- 12.Count the Number of Orders Placed by Each Customer.

select customer_id, COUNT(*) asorder_count
from orders
GROUP BY customer_id;

-- 13.get Customers Who Placed Orders Totaling Over $1000

select customer_id, MAX(total_price) as max_order
from orders
GROUP BY customer_id;

-- 14.Find the Maximum Order Amount for Each Customer

select customer_id
from orders
GROUP BY customer_id
HAVING SUM(total_price) > 1000;

-- 15.Subquery to Find Products Not in the Cart

select * from products
WHERE product_id NOT IN (select product_id from cart);

-- subquery to Find Customers Who Haven't Placed Orders.

select * from customers
WHERE customer_id NOT IN (select customer_id from orders);

-- Subquery to Calculate the Percentage of Total Revenue for a Product

select p.product_id, p.name,
       ROUND(SUM(oi.quantity * p.price) * 100.0 / 
            (select SUM(oi2.quantity * p2.price)
             From order_items oi2
             JOIN products p2 on oi2.product_id = p2.product_id), 2) AS revenue_percentage
from order_items oi
JOIN products p on oi.product_id = p.product_id
GROUP BY p.product_id, p.name;

-- Subquery to Find Products with Low Stock

select * from products
WHERE stock_Quantity < 5;


-- Subquery to Find Customers Who Placed High-Value Orders.

select DISTINCT c.*
from customers c
JOIN orders o on c.customer_id = o.customer_id
WHERE o.total_price > 1000;
