-- create database
CREATE DATABASE walmartsales;

-- create table  -------------------------------------------------------------------------------------
CREATE TABLE sales(
invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
branch VARCHAR(30) NOT NULL,
city VARCHAR(30) NOT NULL,
customer_type VARCHAR(30) NOT NULL,
gender VARCHAR (30) NOT NULL,
product_line VARCHAR(100) NOT NULL,
unit_price DECIMAL(10,2) NOT NULL,
quantity INT NOT NULL,
tax_pct FLOAT(6,4) NOT NULL,
total DECIMAL(12,4) NOT NULL,
date DATETIME NOT NULL,
time TIME NOT NULL, 
payment VARCHAR(15) NOT NULL,
cogs DECIMAL (10,2) NOT NULL,
gross_margin_pct FLOAT(11,9),
gross_income DECIMAL(12,4),
rating FLOAT(2,1) 
);


-- data cleaning
SELECT * FROM sales;


-- ----------------------------------------------------------------------------------------------------
-- ------------------------ FEATURE ENGINEERING -------------------------------------------------------

-- add a new column- time_of_day

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day =(
       CASE 
          WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
		  WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
          ELSE "Evening"
	   END
);

-- add a new column- day_name

ALTER TABLE sales ADD COLUMN day_name varchar(20);

UPDATE sales
SET day_name=DAYNAME(date);

-- add a new column- month_name

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(DATE);

-- ---------------------------------------------------------------------------------------------
-- -----------------------------------------Revenue---------------------------------------------

SELECT SUM(total) AS Total_Revenue FROM sales;

-- PROFIT AMOUNT

SELECT SUM(gross_income) AS profit FROM sales;

-- PROFIT PERCENTAGE

SELECT SUM(gross_income)/SUM(total)*100 AS profit_pct FROM sales;


-- --------------------------------------------------------------------------------------------
-- ------------------------------------GENERIC QUESTION----------------------------------------

-- 1) How many unique cities does the data have?

SELECT DISTINCT(city) 
FROM sales;

-- 2) In which city is each branch?

SELECT DISTINCT(city), branch
FROM sales;
 
 
 -- ----------------------------------------------------------------------------------------------
 -- -------------------------------PRODUCT ANALYSIS-----------------------------------------------
 
 -- 1) How many unique product lines does the data have?
 
 SELECT DISTINCT(product_line) 
 FROM sales;
 
 SELECT COUNT(DISTINCT(product_line)) 
 FROM sales;

-- 2) What is the most common payment method?

 SELECT payment ,COUNT(payment) count
 FROM sales
 GROUP BY payment
 ORDER BY count DESC;
 
 -- 3) What is the most selling product line?
 
 SELECT product_line,count(quantity) AS count
 FROM sales
 GROUP BY product_line
 ORDER BY count DESC;
 
 -- 4) What is the total revenue by month?
 
 SELECT month_name AS Month, SUM(total) AS Total_Revenue
 FROM sales
 GROUP BY Month
 ORDER BY Total_Revenue DESC;

-- 5) Which month had the largest COGS?

SELECT month_name AS Month, SUM(cogs) AS Total_cogs
FROM sales
GROUP BY month_name
ORDER BY Total_cogs DESC;

-- 6) What product line had the largest revenue?

SELECT product_line, ROUND(SUM(total))  AS Total_Revenue
FROM sales
GROUP BY product_line
ORDER BY Total_Revenue DESC
LIMIT 1;

-- 7) What is the city with the largest revenue?

SELECT city, branch, ROUND(SUM(total))  AS Total_Revenue
FROM sales
GROUP BY city,branch
ORDER BY Total_Revenue DESC
LIMIT 1;

-- 8) What product line had the largest VAT (**Value Added Tax**)?

SELECT product_line, AVG(tax_pct) AS VAT
FROM sales 
GROUP BY product_line
ORDER BY VAT DESC;

-- 9) write a query for find city and branch wise total sold products?

SELECT city,branch,SUM(quantity) AS total_qty
FROM sales
GROUP BY city, branch;

-- 10) What is the most common product line by gender?

SELECT product_line,gender, COUNT(invoice_id) AS total_cnt 
FROM sales
GROUP BY gender,product_line
ORDER BY total_cnt DESC;

-- 11) What is the average rating of each product line?

SELECT product_line, ROUND(AVG(rating),2) AS Avg_rating
FROM sales
GROUP BY product_line
ORDER BY Avg_rating DESC;


-- ------------------------------------------------------------------------------------
-- ---------------------------SALES ANALYSIS-------------------------------------------

-- 1) Number of sales made in each time of the day per weekday?

SELECT day_name, time_of_day, COUNT(invoice_id) AS no_of_sales
FROM sales
GROUP BY day_name, time_of_day
ORDER BY day_name;

-- 2) Which of the customer types brings the most revenue?

SELECT customer_type, SUM(total) AS Total_Revenue
FROM sales
GROUP BY customer_type
ORDER BY Total_Revenue DESC;

-- 3) Which city has the largest tax percent/ VAT (**Value Added Tax**)?

SELECT city, ROUND(AVG(tax_pct),2) AS VAT_PCT
FROM sales
GROUP BY city
ORDER BY VAT_PCT DESC;

-- 4) Which customer type pays the most in VAT?

SELECT customer_type, ROUND(AVG(tax_pct),2) AS VAT_PCT
FROM sales
GROUP BY customer_type 
ORDER BY VAT_PCT DESC;

-- 5) Which month has the most revenue?

SELECT month_name, ROUND(SUM(total),2) AS Total_rev
FROM sales
GROUP BY month_name
ORDER BY Total_rev DESC;

-- 6) Which day of the week has the most revenue?

SELECT day_name, ROUND(SUM(total),2) AS Total_rev
FROM sales
GROUP BY day_name
ORDER BY Total_rev DESC;

-- 7) Write a query to return no of sales, total revenue made by product line?

SELECT product_line, 
COUNT(invoice_id) AS No_of_sales,
ROUND(SUM(total),2) AS Total_rev
FROM sales
GROUP BY product_line
ORDER BY No_of_sales DESC;

-- ---------------------------------------------------------------------------------------
-- ---------------------------CUSTOMER ANALYSIS-------------------------------------------

-- 1) How many unique customer types does the data have?

SELECT DISTINCT(customer_type) AS Uniq_customer_type, 
COUNT(invoice_id) AS Total_customer
FROM sales
GROUP BY Uniq_customer_type;

-- 2) How many unique payment methods does the data have?

SELECT DISTINCT payment AS Payment, 
SUM(total) AS Total_rev
FROM sales
GROUP BY Payment
ORDER BY Total_rev DESC;

-- 3) Which customer type buys the most?

SELECT customer_type, 
COUNT(invoice_id) AS Total_sales,
SUM(total) AS Total_rev
FROM sales
GROUP BY customer_type
ORDER BY Total_sales DESC;

-- 4) What is the gender of most of the customers?

SELECT gender, COUNT(gender) AS Total_customer
FROM sales
GROUP BY gender;

-- 5) What is the gender distribution per branch?

SELECT branch, gender, COUNT(*) AS Total_customer
FROM sales
GROUP BY branch, gender
ORDER BY branch;

-- 6) Which time of the day do customers give most ratings?

SELECT time_of_day, ROUND(AVG(rating),1) AS Avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY Avg_rating DESC;

-- 7) Which time of the day do customers give most ratings per branch?

SELECT branch, time_of_day, ROUND(AVG(rating),2) AS Avg_rating
FROM sales
GROUP BY branch,time_of_day
ORDER BY branch;

-- 8) Which day of the week has the best avg ratings?

SELECT day_name, AVG(rating) AS Avg_rating
FROM sales
GROUP BY day_name
ORDER BY Avg_rating DESC;

-- 9) Which day of the week does the customer order the most?

SELECT day_name, 
COUNT(invoice_id) AS No_of_orders,
ROUND(SUM(total),2) AS Total_rev
FROM sales
GROUP BY day_name
ORDER BY No_of_orders DESC;

-- 10) Write a query to return no of sales made by customer type per product line?

SELECT product_line, customer_type, 
COUNT(invoice_id) AS No_of_orders,
ROUND(SUM(total),2) AS Total_rev
FROM sales
GROUP BY product_line, customer_type
ORDER BY product_line;

