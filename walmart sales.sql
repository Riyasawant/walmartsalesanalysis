create database salesDataWalmart;

create table sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
	branch VARCHAR(5) NOT NULL,
	city VARCHAR(30) NOT NULL,
	customer_type VARCHAR(30) NOT NULL,
	gender VARCHAR(30) NOT NULL,
	product_line VARCHAR(100) NOT NULL,
	unit_price DECIMAL(10,2) NOT NULL,
	quantity INT NOT NULL,
	VAT numeric(6, 4) NOT NULL,
	total DECIMAL(12,4) NOT NULL,
	date DATE NOT NULL,
	time TIME NOT NULL,
	payment_method VARCHAR(15) NOT NULL,
	cogs DECIMAL(10,2) NOT NULL,
	gross_margin_pct numeric(11,9) ,
	gross_income DECIMAL(12,4) NOT NULL,
	rating numeric(2,1) 

);


select * from sales;

SELECT 
	time,
    (CASE 
        WHEN time BETWEEN '1899-12-30 00:00:00' AND '1899-12-30 12:00:00' THEN 'Morning'
		WHEN time BETWEEN '1899-12-30 12:01:00' AND '1899-12-30 16:00:00' THEN 'Afternoon'
        
        ELSE 'Evening'  -- Specify the default value when no conditions match
    END) AS time_of_date
FROM sales;

ALTER TABLE sales
	ADD time_of_date VARCHAR(20);

UPDATE sales
	SET time_of_date = 
		(CASE 
        WHEN time BETWEEN '1899-12-30 00:00:00' AND '1899-12-30 12:00:00' THEN 'Morning'
		WHEN time BETWEEN '1899-12-30 12:01:00' AND '1899-12-30 16:00:00' THEN 'Afternoon'
        
        ELSE 'Evening'  -- Specify the default value when no conditions match
    END) 
   

Select date, 
	DATENAME(weekday,date) as day_name from sales;
   
ALTER TABLE sales ADD day_name VARCHAR(10)

UPDATE sales
   SET day_name = DATENAME(weekday,date)

SELECT date, 
	FORMAT(date, 'MMMM') AS month_name
	FROM sales;

ALTER TABLE sales 
	ADD month_name VARCHAR(10);
UPDATE sales 
	SET month_name = FORMAT(date, 'MMMM');

--How many unique cities does the data has--
SELECT DISTINCT city
	from sales;
--How many branches do we have
SELECT DISTINCT branch
	from sales;

SELECT DISTINCT city,branch
	from sales;

-- -------------------------------PRODUCT----------------------------------------


select count(distinct "Product line")
	from sales;

-- What is the common payment method--
select payment, 
	count(payment) as cnt 
	from sales
Group by payment
ORDER BY cnt DESC;

-- What is the most selling product line--
select "Product line", 
	COUNT("Product line")as cnt 
	from sales 
GROUP BY "Product line"
order by cnt desc;

-- What is the total revenue by month--
SELECT month_name AS month,
       SUM(total) AS total_revenue
	FROM sales
GROUP BY month_name
ORDER BY total_revenue DESC;

-- Which month has largest cogs--
SELECT month_name AS month,
		SUM(cogs) AS cogs
	FROM sales
GROUP BY month_name
ORDER BY cogs DESC;

--Which product line has largest revenue---
SELECT 
	"Product line", 
	SUM(total) as Total_revenue
	FROM sales
GROUP BY "Product line"
ORDER BY Total_revenue DESC;

-- what city has largest revenue?
select branch, 
		city, 
		sum(total) as Total_revenue
		from sales
group by city, branch
Order by Total_revenue desc;

-- What product line had largest VAT?
select "Product line", 
	AVG("Tax 5%") as avg_tax
	from sales
group by "Product line"
Order by avg_tax desc;

--Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
select 
	branch, 
	sum(quantity) as qty 
	from sales
group by branch
	Having sum(quantity)> (select avg(quantity) from sales
	);
-- What is the most common product line by gender?
select * from sales;

select Gender, 
	"product line", 
	COUNT(Gender) as total_cnt 
	from sales
GROUP BY gender,"product line"
ORDER BY total_cnt desc;

-- What is the average rating of each product line?
select avg(rating) as avg_ratings, 
		"product line" 
		from sales
GROUP BY "product line"
ORDER BY avg_ratings desc;


----------------------------------------------Sales----------------------------------------------

--Number of sales made in each time of the day per weekday
SELECT time_of_date, 
		COUNT(*) AS total_sales
		FROM sales
		WHERE day_name = 'Sunday'
GROUP BY time_of_date
ORDER BY total_sales desc;

SELECT time_of_date, 
		COUNT(*) AS total_sales
		FROM sales
		WHERE day_name = 'Monday'
GROUP BY time_of_date
ORDER BY total_sales desc;

SELECT time_of_date, 
		COUNT(*) AS total_sales
		FROM sales
		WHERE day_name = 'Tuesday'
GROUP BY time_of_date
ORDER BY total_sales desc;

SELECT time_of_date, 
		COUNT(*) AS total_sales
		FROM sales
		WHERE day_name = 'Wednesday'
GROUP BY time_of_date
ORDER BY total_sales desc;

SELECT time_of_date, 
		COUNT(*) AS total_sales
		FROM sales
		WHERE day_name = 'Thursday'
GROUP BY time_of_date
ORDER BY total_sales desc;

SELECT time_of_date, 
		COUNT(*) AS total_sales
		FROM sales
		WHERE day_name = 'Friday'
GROUP BY time_of_date
ORDER BY total_sales desc;

SELECT time_of_date, 
		COUNT(*) AS total_sales
		FROM sales
		WHERE day_name = 'Saturday'
GROUP BY time_of_date
ORDER BY total_sales desc;

-- Which customer bring the most revenue
select* from sales;

select "Customer type", 
		sum(total) as total_revenue 
		from sales
group by "Customer type"
order by total_revenue desc;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?

select city, 
	avg("Tax 5%") as VAT
	from sales
group by city
order by VAT desc;

-- Which customer type pays the most in VAT?
select "Customer type", 
	avg("Tax 5%") as VAT
	from sales
group by "Customer type"
order by VAT desc;


-------------Customer----------------------------------------------------


-- How many unique customer types does the data have?
select distinct"Customer type"
	from sales;

-- How many unique payment methods does the data have?
select * from sales;
select distinct Payment 
	from sales;


-- Which customer type buys the most?
select distinct"Customer type", 
	count(*) as cnt_ct
	from sales
group by "Customer type"
order by cnt_ct;

-- What is the gender of most of the customers?
select distinct Gender, 
		count(*) as cnt_gen
		from sales
group by Gender
order by cnt_gen desc;

-- What is the gender distribution per branch?

select distinct Gender, count(*) as cnt_gen
	from sales
	where branch = 'A'
	group by Gender
	order by cnt_gen desc;

	select distinct Gender, count(*) as cnt_gen
	from sales
	where branch = 'B'
	group by Gender
	order by cnt_gen desc;

select distinct Gender, count(*) as cnt_gen
	from sales
	where branch = 'C'
	group by Gender
	order by cnt_gen desc;
-- Which time of the day do customers give most ratings?
select * from sales;
select 
	time_of_date,
	AVG(Rating) as avg_ratings
	from sales
	group by time_of_date
	order by avg_ratings desc;
-- Which time of the day do customers give most ratings per branch?
select 
	time_of_date,
	AVG(Rating) as avg_ratings
	from sales
	where Branch = 'A'
	group by time_of_date
	order by avg_ratings desc;

select 
	time_of_date,
	AVG(Rating) as avg_ratings
	from sales
	where Branch = 'B'
	group by time_of_date
	order by avg_ratings desc;

select 
	time_of_date,
	AVG(Rating) as avg_ratings
	from sales
	where Branch = 'C'
	group by time_of_date
	order by avg_ratings desc;
-- Which day fo the week has the best avg ratings?
select 
	day_name,
	AVG(Rating) as avg_ratings
	from sales
	group by day_name
	order by avg_ratings desc;
-- Which day of the week has the best average ratings per branch?

select 
	day_name,
	AVG(Rating) as avg_ratings
	from sales
	where Branch = 'A'
	group by day_name
	order by avg_ratings desc;

select 
	day_name,
	AVG(Rating) as avg_ratings
	from sales
	where Branch = 'B'
	group by day_name
	order by avg_ratings desc;

select 
	day_name,
	AVG(Rating) as avg_ratings
	from sales
	where Branch = 'C'
	group by day_name
	order by avg_ratings desc;
