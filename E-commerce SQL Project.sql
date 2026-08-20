-- ============================================================
-- CAPSTONE PROJECT — E-Commerce Business Analytics
-- ============================================================


-- Creating table customers
Create table customers (
				customer_id INT primary Key not null,
                customer_name varchar(200),
                city varchar(200),
                country varchar(200),
                segment varchar(250),
                signup_date varchar(200) -- Describe below why i use varchar()
                );

-- Creating table order_items
Create table order_items (
						order_item_id INT,
                        order_id INT,
                        product_id INT,
                        quantity INT,
                        unit_price Decimal(10 ,3),
                        discount Decimal(10,3)
                        );

-- Creating table orders
Create table orders(
					order_id INT,
                    customer_id INT,
                    order_date varchar(200),
                    channel Varchar(200),
                    statuss varchar(200)
                    );
                    
-- Creating table products
Create table products (
					product_id INT,
                    product_name Varchar(250),
                    category Varchar(250),
                    cost_price Decimal(10,3),
                    list_price decimal(10,3)
                    );
                    
-- Adding data in orders_items Table
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/order_items.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS;

-- Adding data in Customers Table
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/customers.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS;


-- Adding data in order_items Table
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/orders.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS;

-- Adding data in products Table
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS;

-- We cannot add the Date directly in Mysql b/c format issues 
-- and there is to many errors that's why we change the \
-- fromat after adding the Date 
describe customers;
alter table customers 
modify column signup_date DATE;

describe orders;
alter table orders
modify column order_date DATE;


-- ============================================================
-- KEY METRICS — Headline KPIs
-- ============================================================
-- Total Sales KPI
Select 
	round(sum(quantity * unit_price)/1000000,3) AS Total_Sales_In_Million
FROM order_items;
-- Total Orders KPI
SELECT 
	count(order_id)/1000 AS Total_Orders_In_Thouand
FROM orders;

-- Avgerage Order Value KPI
SELECT 
	ROUND(SUM(quantity * unit_price) /(COUNT(DISTINCT o.order_id)),2) as AOV
FROM orders o 
LEFT JOIN order_items  oi
ON o.order_id =oi.order_id;

-- Total Qty Sold KPI
SELECT 
	SUM(quantity) AS total_qty_sold
FROM order_items;

--  Total Profit KPI
SELECT 
	SUM(oi.quantity * oi.unit_price) AS total_sales,
    SUM(oi.quantity * p.Cost_Price) AS Total_Cost,
    ROUND((SUM(oi.quantity * oi.unit_price)- SUM(oi.quantity * p.Cost_Price))/1000000,3) as Total_Profit_in_Million
FROM order_items oi 
LEFT JOIN products p 
ON oi.product_id = p.product_id;


-- Total Product Cost KPI
SELECT 
    round(SUM(oi.quantity * p.Cost_Price)/1000000,3) AS Total_Cost_in_million
FROM order_items oi 
LEFT JOIN products p 
ON oi.product_id = p.product_id;

-- Total Customers  KPI
SELECT
	COUNT(*) AS Total_Customers
FROM customers;
-- YTD Total Sales KPI
SELECT 
	year(o.order_date),
    round(sum(oi.quantity * oi.unit_price)/1000000,3) AS Total_Sales_In_Million
FROM orders o 
LEFT JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY  YEAR(order_date);
-- MTD Total_Sales 
SELECT 
	MONTH(o.order_date) AS MTD_Total_Sales,
    YEAR(order_date) AS YTD,
    round(sum(oi.quantity * oi.unit_price)/1000,2) AS Total_Sales_In_Million
FROM orders o 
LEFT JOIN order_items oi
ON o.order_id = oi.order_id
group by MTD_Total_Sales, ytd 
order by ytd asc , mtd_total_sales asc; 
-- Previous Year sales KPI
SELECT 
	year(o.order_date) Years,
    round(sum(quantity * unit_price)/1000000,3) as YTD,
    lag(sum(quantity * unit_price )/1000000,1) over(order by year(o.order_date)) as PYTD
from orders o 
left join order_items oi
on o.order_id = oi.order_id
group by year(order_date);


-- Charts Requrements --
-- TOP 5 Country YTD Total Sales  IN (2023)
SELECT 
	country,
	year(o.order_date) Year,
    round(sum(oi.quantity * oi.unit_price),1) AS Total_Sales
FROM orders o 
LEFT JOIN order_items oi
ON o.order_id = oi.order_id
LEFT JOIN Customers c 
on o.customer_id = c.customer_id
Where year(o.order_date)= 2023
GROUP BY  YEAR(order_date),country
ORDER BY Total_Sales DESC LIMIT 5;

-- TOP 5 Country YTD Total Sales  IN (2024)
SELECT 
	country,
	year(o.order_date) Year,
    round(sum(oi.quantity * oi.unit_price),1) AS Total_Sales
FROM orders o 
LEFT JOIN order_items oi
ON o.order_id = oi.order_id
LEFT JOIN Customers c 
on o.customer_id = c.customer_id
Where year(o.order_date)= 2024
GROUP BY  YEAR(order_date),country
ORDER BY Total_Sales DESC LIMIT 5;

-- TOP 5 Country YTD Total Sales  IN (2025)
SELECT 
	country,
	year(o.order_date) Year,
    round(sum(oi.quantity * oi.unit_price),1) AS Total_Sales
FROM orders o 
LEFT JOIN order_items oi
ON o.order_id = oi.order_id
LEFT JOIN Customers c 
on o.customer_id = c.customer_id
Where year(o.order_date)= 2025
GROUP BY  YEAR(order_date),country
ORDER BY Total_Sales DESC LIMIT 5;


-- TOP 5 City YTD Total Sales  IN (2023)
SELECT 
	city,
	year(o.order_date) Year,
    round(sum(oi.quantity * oi.unit_price),1) AS Total_Sales
FROM orders o 
LEFT JOIN order_items oi
ON o.order_id = oi.order_id
LEFT JOIN Customers c 
on o.customer_id = c.customer_id
Where year(o.order_date)= 2023
GROUP BY  YEAR(order_date), City
ORDER BY Total_Sales DESC LIMIT 5;

-- TOP 5 City YTD Total Sales  IN (2024)
SELECT 
	city,
	year(o.order_date) Year,
    round(sum(oi.quantity * oi.unit_price),1) AS Total_Sales
FROM orders o 
LEFT JOIN order_items oi
ON o.order_id = oi.order_id
LEFT JOIN Customers c 
on o.customer_id = c.customer_id
Where year(o.order_date)= 2024
GROUP BY  YEAR(order_date), City
ORDER BY Total_Sales DESC LIMIT 5;

-- TOP 5 City YTD Total Sales  IN (2025)
SELECT 
	city,
	year(o.order_date) Year,
    round(sum(oi.quantity * oi.unit_price),1) AS Total_Sales
FROM orders o 
LEFT JOIN order_items oi
ON o.order_id = oi.order_id
LEFT JOIN Customers c 
on o.customer_id = c.customer_id
Where year(o.order_date)= 2025
GROUP BY  YEAR(order_date), City
ORDER BY Total_Sales DESC LIMIT 5;


-- TOP 5 Country Total Sales (IN 2023)
SELECT 
	country,
    sum(oi.quantity * oi.unit_price) as YTD_Sales
From order_items oi
left join orders o 
on oi.order_id= o.order_id
left join customers c
on o.customer_id = c.customer_id
Where year(Order_date) = 2023
GROUP BY country
ORDER BY sum(oi.quantity * oi.unit_price) DESC LIMIT 5;

-- TOP 5 Country Total Sales (IN 2024)
SELECT 
	country,
    sum(oi.quantity * oi.unit_price) as YTD_Sales
From order_items oi
left join orders o 
on oi.order_id= o.order_id
left join customers c
on o.customer_id = c.customer_id
Where year(Order_date) = 2024
GROUP BY country
ORDER BY sum(oi.quantity * oi.unit_price) DESC LIMIT 5;

-- TOP 5 Country Total Sales (IN 2025)
SELECT 
	country,
    sum(quantity * unit_price) AS YTD_Sales
FROM 
	order_items oi
    LEFT JOIN orders o 
    on oi.order_id = o.order_id
    LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE YEAR(order_date) = 2025
GROUP BY Country
ORDER BY YTD_Sales DESC LIMIT 5;

-- YTD Total Sales BY Channel (IN 2023)
SELECT 
	channel,
     sum(quantity * unit_price) AS YTD_Sales
FROM orders o
LEFT JOIN order_items oi
ON o.order_id = oi.order_id
WHERE YEAR(order_date)=2023
GROUP BY channel;

-- YTD Total Sales BY Channel (IN 2024)
SELECT 
	channel,
     sum(quantity * unit_price) AS YTD_Sales
FROM orders o
LEFT JOIN order_items oi
ON o.order_id = oi.order_id
WHERE YEAR(order_date)=2024
GROUP BY channel;

-- YTD Total Sales BY Channel (IN 2025)
SELECT 
	channel,
     sum(quantity * unit_price) AS YTD_Sales
FROM orders o
LEFT JOIN order_items oi
ON o.order_id = oi.order_id
WHERE YEAR(order_date)=2025
GROUP BY channel;

-- Total Sales by WeekNO
SELECT 
	yearweek(o.order_date,1) as yearweek,
    sum(oi.quantity * oi.unit_price) as total_sales
from orders o 
left join order_items oi 
on o.order_id = oi.order_id
left join products p
on oi.product_id = p.product_id
group by yearweek(o.order_date,1)
order by yearweek(o.order_date,1) asc;
-- TOP 5 Country BY Total Sales
SELECT
	c.country,
	round(SUM(oi.quantity * oi.unit_price)/1000000,3) as Total_Sales_In_Million
FROM customers c
LEFT JOIN orders o
on c.customer_id = o.customer_id
LEFT JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY c.country 
ORDER BY SUM(oi.quantity * oi.unit_price) DESC limit 5;


-- TOP 5 City BY Customers City
SELECT
	c.city,
	round(SUM(oi.quantity * oi.unit_price)/1000,3) as Total_Sales_In_Thousand
FROM customers c
LEFT JOIN orders o
on c.customer_id = o.customer_id
LEFT JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY c.city 
ORDER BY SUM(oi.quantity * oi.unit_price) DESC limit 5;

-- TOP 5 Proudct BY Total_Sales
SELECT
	p.product_name,
	round(SUM(oi.quantity * oi.unit_price)/1000,3) as Total_Sales_In_Thousand
FROM products p
LEFT JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY SUM(quantity * unit_price) DESC limit 5;

-- TOP 5 Category BY Total_Sales
SELECT
	p.category,
	round(SUM(oi.quantity * oi.unit_price)/1000,3) as Total_Sales_In_Thousand
FROM products p
LEFT JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY SUM(quantity * unit_price) DESC limit 5;

-- TOP 5 Country BY Profit 
SELECT 
	country,
    SUM(quantity * unit_price)- SUM(quantity *Cost_Price) as Total_Profit
FROM order_items oi 
LEFT JOIN products p 
on oi.product_id = p.product_id
LEFT JOIN orders  o
ON oi.order_id = o.order_id
LEFT JOIN customers c
ON c.customer_id = o.customer_id
GROUP BY Country 
ORDER BY Total_Profit DESC LIMIT 5;


-- Total_Profit BY Channel
SELECT 
	channel,
    SUM(quantity * unit_price)- SUM(quantity *Cost_Price) as Total_Profit
FROM order_items oi 
LEFT JOIN products p 
on oi.product_id = p.product_id
LEFT JOIN orders  o
ON oi.order_id = o.order_id
GROUP BY channel
ORDER BY Total_Profit DESC LIMIT 5;


-- TOP 5 CITY BY Profit 
SELECT 
	c.city,
    SUM(oi.quantity * oi.unit_price)- SUM(oi.quantity *p.Cost_Price) as Total_Profit
FROM order_items oi 
LEFT JOIN products p 
on oi.product_id = p.product_id
LEFT JOIN orders  o
ON oi.order_id = o.order_id
LEFT JOIN customers c
ON c.customer_id = o.customer_id
GROUP BY c.city 
ORDER BY Total_Profit DESC LIMIT 5;

-- TOP 5 Product BY Profit 
SELECT 
	p.product_name,
    SUM(oi.quantity * oi.unit_price)- SUM(oi.quantity *p.Cost_Price) as Total_Profit
FROM order_items oi 
LEFT JOIN products p 
on oi.product_id = p.product_id
LEFT JOIN orders  o
ON oi.order_id = o.order_id
LEFT JOIN customers c
ON c.customer_id = o.customer_id
GROUP BY p.product_name 
ORDER BY Total_Profit DESC LIMIT 5;





