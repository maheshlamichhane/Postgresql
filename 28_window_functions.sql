-- Create our trades table
CREATE TABLE trades(
	region text,
	country text,
	year int,
	imports numeric(50,0),
	exports numeric(50,0)
);

SELECT * FROM trades;
SELECT COUNT(*) FROM trades;
SELECT DISTINCT(region) FROM trades ORDER BY region;
SELECT DISTINCT(country) FROM trades ORDER BY country;
SELECT MIN(year),MAX(year) FROM trades;
SELECT * FROM trades WHERE country='USA';

-- Using aggregate functions
SELECT 
	MIN(imports)/1000000,
	MAX(imports)/1000000,
	AVG(imports)/1000000
FROM trades;

SELECT 
	region,
	ROUND(MIN(imports)/1000000,0) as min,
	ROUND(MAX(imports)/1000000,0) as max,
	ROUND(AVG(imports)/1000000,0) as avg
FROM trades
GROUP BY region
ORDER BY 3 DESC;

SELECT 
	region,
	ROUND(MIN(exports)/1000000,0) as min,
	ROUND(MAX(exports)/1000000,0) as max,
	ROUND(AVG(exports)/1000000,0) as avg
FROM trades
WHERE year >= 2015
GROUP BY region
ORDER BY 3 DESC;


-- Using GROUP with ROLLUP
SELECT 
	region,
	ROUND((AVG(imports)/1000000000),2) as avg
FROM trades
GROUP BY region;

SELECT 
	region,
	country,
	ROUND((AVG(imports)/1000000000),2) as avg
FROM trades
WHERE country IN ('USA','Argentina','Singapore','Brazil')
GROUP BY ROLLUP (region,country)
ORDER BY 1;

-- Using GROUP BY CUBE
SELECT
	region,
	country,
	ROUND(AVG(imports/1000000000),2)
FROM trades
WHERE
	country IN ('USA','France','Germany','Brazil')
GROUP BY
	CUBE (region,country);


-- Using By GROUPING SETS
SELECT
	region,
	country,
	ROUND(AVG(imports/1000000000),2)
FROM trades
WHERE
	country IN ('USA','France','Germany','Brazil')
GROUP BY
	GROUPING SETS ((),region,country);

-- Query performance analysis
EXPLAIN SELECT
	region,
	country,
	ROUND(AVG(imports/1000000000),2)
FROM trades
WHERE
	country IN ('USA','France','Germany','Brazil')
GROUP BY
	GROUPING SETS ((),region,country);

SHOW enable_hashagg;
SET enable_hashagg TO off;
-- 0.201ms, 11.686 ms grouping aggregate
SET enable_hashagg TO on;
-- 0.102 ms , 1.272 ms mixed aggregate

-- Using FILTER clause
SELECT
	region,
	AVG(exports) as avg_all,
	AVG(exports) FILTER (WHERE year < 1995) as avg_old,
	AVG(exports) FILTER (WHERE year >= 1995) as avg_latest
FROM trades
GROUP BY 
	ROLLUP(region);

-- Using window functions
SELECT AVG(exports) FROM trades;
-- 72443407670.13915858

SELECT country,year,imports,exports,avg(exports) OVER() as 
avg_exports FROM trades;

-- Partitioning the data
SELECT country,year,imports,exports,avg(exports) OVER(PARTITION BY country) as 
avg_exports FROM trades;

-- Can we even filter data in PARTITION BY?
SELECT country,year,imports, exports, avg(exports) OVER(PARTITION BY year > 2000) 
as avg_exports FROM trades;

-- Set data into millions format
select 
	imports,
	ROUND(imports/1000000,2)
FROM trades;

UPDATE trades
SET
imports = ROUND(imports/1000000,2),
exports = ROUND(exports/1000000,2);
SELECT * FROM trades;

-- Ordering inside window

-- ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW is default

SELECT
	country,
	year,
	exports,
	MIN(exports) OVER (PARTITION BY country ORDER BY year)
FROM trades
WHERE
	year > 2001 AND country IN ('USA','France');

SELECT
	country,
	year,
	exports,
	MAX(exports) OVER (PARTITION BY country ORDER BY year)
FROM trades
WHERE
	year > 2001 AND country IN ('USA','France');

SELECT
	country,
	year,
	exports,
	MAX(exports) OVER (PARTITION BY country) AS max_exports_per_country
FROM trades
WHERE
	year > 2001 AND country IN ('USA','France')
	ORDER BY country,year;

-- Sliding dynamic windows
SELECT
	country,
	year,
	exports,
	MIN(exports) OVER (PARTITION BY country ORDER BY year ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) as avg_moving
FROM trades
WHERE
	year BETWEEN 2001 AND 2010
	AND country IN('USA','France');

-- Understanding Window frames
-- Window frames are used to indicate how many rows around the current row, the window function should include.
-- Specifying window frame via ROWS or RANGE,BETWEEN.
-- Window frames in window functions use UNBOUNDED PREECEDING by default.
-- RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
-- ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
-- ROWS BETWEEN UNBOUNDED PRECEDING
-- ROWS BETWEEN UNBOUNNDED FOLLOWING

-- ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
SELECT
*,
array_agg(x) OVER (ORDER BY x)
FROM generate_series(1,3) as x;

-- ROWS BETWEEN UNBOUNDED PREECEDING AND UNBOUNDED FOLLOWING
SELECT
*,
array_agg(x) OVER (ORDER BY x ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM generate_series(1,3) as x;

-- ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
SELECT
*,
array_agg(x) OVER (ORDER BY x ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING)
FROM generate_series(1,3) as x;

-- ROWS BETWEEN CURRENT ROW AND CURRENT ROW
SELECT
*,
array_agg(x) OVER (ORDER BY x ROWS BETWEEN CURRENT ROW AND CURRENT ROW)
FROM generate_series(1,3) as x;

-- ROWS BETWEEN 1 PROCEEDING AND 1 FOLLOWING
SELECT
*,
array_agg(x) OVER (ORDER BY x ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING)
FROM generate_series(1,3) as x;

-- ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
-- ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING
-- ROWS BETWEEN 1 PRECEDING AND CURRENT ROW
-- ROWS BETWEEN 1 FOLLOWING AND 2 FOLLOWING

-- ROWS and RANGE indicators
-- RANGE can only be used with UNBOUNDED
-- ROWS can actually be used for all of the options.
-- If the field you use for ORDER BY does not contain unique values for each row, then range will combine all
-- the rows it comes across for non-unique values rather than processing them one at a time.
-- ROWS will include all of the rows in the non-unique buch but process each of them separately
SELECT
	*,
	x / 3 as y,
	array_agg(x) OVER (ORDER BY x ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) as rows1,
	array_agg(x) OVER (ORDER BY x RANGE BETWEEN 1 PRECEDING AND 1 FOLLOWING) as range1,
	array_agg(x/3) OVER (ORDER BY x/3 ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) as rows2,
	array_agg(x/3) OVER (ORDER BY x/3 RANGE BETWEEN 1 PRECEDING AND 1 FOLLOWING) as range2
FROM generate_series(1,10) as x;

-- WINDOW function
-- allows us to add columns to the result set that has been calculated on the fly.
-- Allows to pre-defined a result set and used it anywhere in a query.

-- lets get min and max exports per year each country say from year 2000 onwards in a single query.
SELECT
	country,
	year,
	exports,
	MIN(exports) OVER w,
	MAX(exports) OVER w
FROM trades
WHERE
	country = 'USA' AND year > 2000
WINDOW w AS (ORDER BY year ROWS BETWEEN UNBOUNDED PRECEDING 
AND CURRENT ROW);


-- RANK AND DENSE_RANK functions
-- rank() function returns the no of the current row within its window. counting starts at 1.
-- To avoid duplicate ranks, we used DENSE_RANK() function

-- lets look at top 10 exports by year for USA
SELECT
	year,
	exports,
	RANK() OVER (ORDER BY exports DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as r
FROM trades
WHERE
	country='USA'
LIMIT 10;

-- NTILE function
-- It will split data into ideally equal groups 10 ROWS 2 EACH
-- Get USA exports from year 2000 into 4 buckets
SELECT
	year,
	exports,
	NTILE(4) OVER (ORDER BY exports DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as r
FROM trades
WHERE
	country='USA' AND year > 2000;

SELECT
	country,
	year,
	exports,
	NTILE(5) OVER (PARTITION BY country ORDER BY exports DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as r
FROM trades
WHERE
	country IN ('USA','France','Belgium') AND year > 2000;


-- LEAD and LAG funcions
-- these allows you to move lines within the resultsets.
-- very useful function to compare data of current row with any other rows.


-- LEAD example
SELECT
	year,
	exports,
	LEAD(exports,1) OVER(ORDER BY year DESC)
FROM trades
WHERE country='Belgium'
LIMIT 10;

-- LAG example
SELECT
	year,
	exports,
	LAG(exports,1) OVER(ORDER BY year DESC)
FROM trades
WHERE country='Belgium'
LIMIT 10;

-- lets calculate the difference of exports from one year to another year for belgium
SELECT
	country,
	year,
	exports,
	LAG(exports,1) OVER(PARTITION BY country ORDER BY year)
FROM trades
WHERE country IN ('Belgium','USA') AND year > 2010

SELECT
	country,
	year,
	exports,
	LEAD(exports,1) OVER(PARTITION BY country ORDER BY year)
FROM trades
WHERE country IN ('Belgium','USA') AND year > 2010



-- first_value(),nth_value(),and last_value() functions.
SELECT
	year,
	imports,
	FIRST_VALUE(imports) OVER(ORDER BY year)
FROM trades
WHERE country = 'Belgium';

SELECT
	year,
	imports,
	LAST_VALUE(imports) OVER(ORDER BY year)
FROM trades
WHERE country = 'Belgium';
-- ROWS BETWEEN 0 PRECEDING AND 0 FOLLOWING is defalt here

SELECT
	year,
	imports,
	LAST_VALUE(imports) OVER(ORDER BY year ROWS BETWEEN 0 PRECEDING AND UNBOUNDED FOLLOWING)
FROM trades
WHERE country = 'Belgium';

SELECT
	year,
	imports,
	LAST_VALUE(imports) OVER(ORDER BY country)
FROM trades
WHERE country = 'Belgium';

SELECT
	year,
	imports,
	NTH_VALUE(imports,5) OVER(ORDER BY year)
FROM trades
WHERE country = 'Belgium';

-- Multiple country
SELECT
	country,
	year,
	imports,
	FIRST_VALUE(imports) OVER(PARTITION BY country ORDER BY year)
FROM trades
WHERE country IN ('Belgium','USA') AND year > 2014;


-- ROW_NUMBER() function
-- can simpley be used to return a virtual ID

-- assign a unique integer value to each row in a result set starting with 1
SELECT
	year,
	imports,
	ROW_NUMBER() OVER (ORDER BY imports) as r
FROM trades
WHERE
	country='France';
	
-- Get the 4th imports from each country order by year
SELECT
* 
FROM
(
	SELECT
	country,
	year,
	imports,
	ROW_NUMBER() OVER (PARTITION BY country ORDER BY year) as r
FROM trades
WHERE year >= 2010
) as t
WHERE r =4
ORDER BY imports DESC;


-- Finding correlations
SELECT
	country,
	corr(imports,exports)
FROM trades
WHERE country IN ('USA','France','Japan','Brazil','singapore')
GROUP BY country
ORDER BY 2 DESC
NULLS LAST;

-- Using OVER() function
SELECT
	first_name,
	salary,
	SUM(salary) OVER()
FROM employees;

SELECT
	first_name,
	salary,
	SUM(salary) OVER() as "Total Salary",
	ROUND(salary/SUM(salary) OVER() * 100,2)
FROM employees
ORDER by 4 DESC;


-- Difference compared to average
SELECT
	first_name,
	salary,
	ROUND(salary - AVG(salary) OVER(),2) as avg,
	ROUND(AVG(salary) OVER(),2) as "Total AVG Salary"
FROM employees
ORDER BY 3 DESC;

-- Cumulative totals using window function
SELECT
	first_name,
	salary,
	SUM(salary) OVER(),
	SUM(salary) OVER(ORDER BY salary DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM employees;

-- Comparing with next values
SELECT 
	first_name,
	salary,
	salary - LAG(salary,2) OVER (ORDER BY salary DESC) as diff_nexy
FROM employees
ORDER BY salary DESC;









