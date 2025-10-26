-- Objective 1 : 
-- Customer Insights look at the Customers and Orders data.
-- Purpose: Helps marketing target the right people.

-- Questions:
-- <1> Who are our top customers?
Select c.customer_id, c.name, count(o.order_id) as Total_orders, sum(o.total_amount) as total_spend
from customers c
join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.name
order by total_spend desc, Total_orders desc 
limit 10;

-- <2> Who buys repeatedly?
Select c.customer_id, c.name, count(o.order_id) as Repeated_count
from customers c
join orders o on c.customer_id = o.customer_id 
group by c.customer_id , c.name 
order by Repeat_count desc 
limit 5;

-- <3> Which location has the most sales?
Select c.location , count(o.order_id) as Total_orders, sum(o.total_amount) as Total_amount 
from customers c 
join orders o on c.customer_id = o.customer_id 
group by c.location 
order by Total_amount desc,Total_orders  desc 
limit 5;



-- Objective 2 : 
-- Product Analysis look at Products and OrderDetails.
-- Purpose: Helps decide which products to stock, promote, or remove.

-- Questions :
-- <1> Which products sell the most?
Select p.name, sum(od.quantity) as Total_Quantity
from products p
join orderdetails od on od.product_id = p.product_id
group by p.name 
order by Total_Quantity desc;

-- <2> Which products make the most money?
Select p.name, sum(od.quantity * p.price) as Total_revenue 
from products p
join orderdetails od on od.product_id = p.product_id
group by p.name
order by Total_revenue desc;

-- <3> Are there products that rarely sell?
Select p.name, sum(od.quantity) as Total_Quantity
from products p
join orderdetails od on od.product_id = p.product_id
group by p.name 
order by Total_Quantity asc;



-- Objective 3
-- Sales Optimization look at Orders and OrderDetails.
-- Purpose: Helps boost sales and improve strategy.

-- Questions :
-- <1> Which months have the highest sales?

-- Here first i changed date format string to proper date format yyyy-mm-dd
update  orders 
set order_date = STR_TO_DATE(order_date, '%Y/%m/%d');

select month(o.order_date) as Months, sum(od.quantity * od.price_per_unit) as total_sale_amount
from orders o
join orderdetails od on o.order_id = od.order_id
group by Months
order by total_sale_amount desc;



-- <2> Are there trends in customer buying habits?

-- 1. Which months have the most orders (Seasonal trend)
SELECT 
    DATE_FORMAT(o.order_date, '%M') AS Month_Name,
    COUNT(o.order_id) AS total_orders,
    SUM(quantity * price_per_unit) AS total_sales
FROM orders o
JOIN orderdetails od ON o.order_id = od.order_id
GROUP BY Month_Name
order by total_sales desc;

-- 2. Which products or categories are most popular (Product preference)
SELECT p.name, SUM(od.quantity) AS total_quantity_sold
FROM orderdetails od
JOIN products p ON od.product_id = p.product_id
GROUP BY p.name
ORDER BY total_quantity_sold DESC;

-- 3. Which customers buy most often or spend more (Spending habits)
SELECT c.customer_id, c.name, SUM(od.quantity * od.price_per_unit) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN orderdetails od ON o.order_id = od.order_id
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC;



-- <3> How can we increase revenue?

-- 1. High revenue products focus on promoting high-performing products
SELECT p.name, SUM(od.quantity * od.price_per_unit) AS total_revenue
FROM orderdetails od
JOIN products p ON od.product_id = p.product_id
GROUP BY p.name
ORDER BY total_revenue DESC;

-- 2. Loyal Customers : targeting loyal customers with exclusive offers, 
                             
SELECT c.customer_id, c.name, SUM(od.quantity * od.price_per_unit) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN orderdetails od ON o.order_id = od.order_id
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC;

-- 3. By improving sales during low-performing months through seasonal discounts or marketing campaigns.
select month(o.order_date) as Months, sum(od.quantity * od.price_per_unit) as total_sale_amount
from orders o
join orderdetails od on o.order_id = od.order_id
group by Months
order by total_sale_amount;



-- Objective 4 :
-- Inventory Management look at Products and OrderDetails.
-- Purpose: Helps avoid running out of popular items or wasting money on slow items.

-- Questions :
-- <1> Which products are running low in stock?
SELECT p.product_id, p.name, SUM(od.quantity) AS total_sold
FROM products p
JOIN orderdetails od ON p.product_id = od.product_id
GROUP BY p.product_id, p.name
ORDER BY total_sold DESC
LIMIT 10;  -- top 10 fast-selling products
-- Shows products that are selling the most, these are most likely to run low soon.


-- <2> Which products are overstocked?
SELECT p.product_id, p.name, SUM(od.quantity) AS total_sold
FROM products p
LEFT JOIN orderdetails od ON p.product_id = od.product_id
GROUP BY p.product_id, p.name
ORDER BY total_sold ASC
LIMIT 10;  -- bottom 10 slow-selling products
-- Shows products that sell very less, these are least likely to run low and may indicate overstock.






