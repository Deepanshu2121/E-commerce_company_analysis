# E-commerce Company analysis

## Project Overview 

**Project Title**: E-commerce Company analysis                                                                 
**Level**: Intermediate                                                                                 
**DataBase**: `e-commerce_analysis`

This project showcases SQL skills commonly used by data analysts to explore, clean, and analyze E-commerce data. It involves creating an e-commerce_analysis database, performing exploratory data analysis (EDA), and answering key business questions using SQL queries. This project is perfect for Intermediate who want to build a strong foundation in SQL and data analysis.

## Objectives
1. Customer Insights look at the Customers and Orders data.
Questions:
Who are our top customers?
Who buys repeatedly?
Which location has the most sales?
Purpose: Helps marketing target the right people.

2. Product Analysis look at Products and OrderDetails.
Questions:
Which products sell the most?
Which products make the most money?
Are there products that rarely sell?
Purpose: Helps decide what to stock, promote, or remove.

3. Sales Optimization look at Orders and OrderDetails.
Questions:
Which months have the highest sales?
Are there trends in customer buying habits?
How can we increase revenue?
Purpose: Helps boost sales and improve strategy.

4. Inventory Management look at Products and OrderDetails.
Questions:
Which products are running low in stock?
Which products are overstocked?
Purpose: Helps avoid running out of popular items or wasting money on slow items.

## Project Structure

### 1. Database Setup

- ** Database Creation **: The project starts by creating a database named `e-commerce_analysis`
- ** Table Importing **: The table names `customers`, `orderdetails`, `orders`, and `products`.

## What you actually do with SQL
- Extract data from the tables (Customers, Products, Orders, OrderDetails).
- Clean and organize the data (remove duplicates, fix mistakes).
- Analyze using queries like SUM, COUNT, AVG, GROUP BY, JOINs.
- Generate reports or insights that departments can use to make decisions.

```sql
-- Objective 1 : 
-- Customer Insights look at the Customers and Orders data.
-- Purpose: Helps marketing target the right people.

-- Questions:
-- Q<1> Who are our top customers?
Select c.customer_id, c.name, count(o.order_id) as Total_orders, sum(o.total_amount) as total_spend
from customers c
join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.name
order by total_spend desc, Total_orders desc 
limit 10;

-- Q<2> Who buys repeatedly?
Select c.customer_id, c.name, count(o.order_id) as Repeated_count
from customers c
join orders o on c.customer_id = o.customer_id 
group by c.customer_id , c.name 
order by Repeat_count desc 
limit 5;

-- Q<3> Which location has the most sales?
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
-- Q<1> Which products sell the most?
Select p.name, sum(od.quantity) as Total_Quantity
from products p
join orderdetails od on od.product_id = p.product_id
group by p.name 
order by Total_Quantity desc;

-- Q<2> Which products make the most money?
Select p.name, sum(od.quantity * p.price) as Total_revenue 
from products p
join orderdetails od on od.product_id = p.product_id
group by p.name
order by Total_revenue desc;

-- Q<3> Are there products that rarely sell?
Select p.name, sum(od.quantity) as Total_Quantity
from products p
join orderdetails od on od.product_id = p.product_id
group by p.name 
order by Total_Quantity asc;



-- Objective 3
-- Sales Optimization look at Orders and OrderDetails.
-- Purpose: Helps boost sales and improve strategy.

-- Questions :
-- Q<1> Which months have the highest sales?

-- Here first i changed date format string to proper date format yyyy-mm-dd
update  orders 
set order_date = STR_TO_DATE(order_date, '%Y/%m/%d');

select month(o.order_date) as Months, sum(od.quantity * od.price_per_unit) as total_sale_amount
from orders o
join orderdetails od on o.order_id = od.order_id
group by Months
order by total_sale_amount desc;



-- Q<2> Are there trends in customer buying habits?

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



-- Q<3> How can we increase revenue?

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
-- Q<1> Which products are running low in stock?
SELECT p.product_id, p.name, SUM(od.quantity) AS total_sold
FROM products p
JOIN orderdetails od ON p.product_id = od.product_id
GROUP BY p.product_id, p.name
ORDER BY total_sold DESC
LIMIT 10;  -- top 10 fast-selling products
-- Shows products that are selling the most, these are most likely to run low soon.


-- Q<2> Which products are overstocked?
SELECT p.product_id, p.name, SUM(od.quantity) AS total_sold
FROM products p
LEFT JOIN orderdetails od ON p.product_id = od.product_id
GROUP BY p.product_id, p.name
ORDER BY total_sold ASC
LIMIT 10;  -- bottom 10 slow-selling products
-- Shows products that sell very less, these are least likely to run low and may indicate overstock.
```

## Findings

**Customer Analysis**

- Top customers and repeat buyers drive most revenue.
- Certain locations generate higher sales.

**Product Analysis**

- Some products sell the most and generate highest revenue.
- Some products rarely sell and may need promotion or removal.

**Sales Optimization**

- Sales peak in certain months (seasonal trends).
- Customers prefer specific products and categories.
- Revenue can grow by promoting best products, targeting loyal customers, and improving slow months.

**Inventory Management**

- Fast-selling products may run out soon.
- Slow-selling products may be overstocked.

## Conclusion

- This analysis highlights key customers, popular products, and sales trends. By focusing on top customers, high-revenue products, seasonal opportunities, and proper inventory management, the company can optimize sales, improve marketing strategies, and reduce inventory costs.

## How to Use

**Set up the database:**
Create e-commerce_analysis and import tables: customers, orders, products, orderdetails.

**Run analysis queries:**
Find top customers, repeat buyers, and best locations.
Check best-selling and slow-selling products.
Analyze monthly sales and customer trends.
Identify fast-selling and overstocked products.

**Generate insights:**
Target loyal customers for promotions.
Focus on high-revenue products.
Plan campaigns for seasonal trends.
Manage inventory to avoid stockouts or excess.

**Make business decisions:**
Boost revenue by promoting top products and rewarding loyal customers.
Optimize inventory and marketing strategy.

## Author – Deepanshu Dahiya


This project is part of my portfolio, shows SQL skills for analyzing E-commerce data. It includes queries to identify top customers, repeat buyers, best-selling and slow-selling products, sales trends, and inventory status. These analyses showcase practical techniques used by data analysts to drive business insights and decisions.
