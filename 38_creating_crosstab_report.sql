-- What is a Crosstab Report
/*
	1. A typical relational database table contains multiple rows, quite often with
		duplicate values in some columns. Data in such a table is usually stored
		in random order. By running a query to select data from a database table, you can 
		perform filtering,sorting,grouping,selection and other operations with data.
	2. Nevertheless, the results of that kind of query(data) will still be 
		displayed downwwards.which may complicate the analysis. Pivot tables
		extend the data across rather than downward. In this way, the query
		results are much easier to percieve, compare,analyze and filter.
	3. A 'Pivot Table' or a 'Crosstab Reort' is an effective technique for 
		calculating,compiling, and analyzing data bound to simplify the search 
		for patterns and trends. Pivot tables can help you aggregate, sort, 
		organize, reorganize, group sum or average data stored in a database to 
		understand data relations and dependencies in the best possible way.
	4. Pivot Table/Crosstab reports/Cross tabulation provide a simple way to summirize
		and compare variables by displaying them in a table layout or in
		matrix format.

		In matrix
			Rows : represents ONE variable
			Columns: represents another variable
			Cell: represents where a row and column intersects to hold a value
*/

-- Install extension
CREATE EXTENSION IF NOT EXISTS tablefunc;
SELECT * FROM pg_extension;

-- Using crosstab function
-- 1. Lets create a sample table called 'scores'
CREATE TABLE scores(
	score_id SERIAL PRIMARY KEY,
	name VARCHAR(100),
	subject VARCHAR(100),
	score numeric(4,2),
	score_date DATE
);

-- 2. Lets insert some sample data
INSERT INTO scores (name,subject,score,score_date) VALUES
('Adam','Math',10,'2020-01-01'),
('Adam','English',8,'2020-02-01'),
('Adam','History',7,'2020-03-01'),
('Adam','Music',9,'2020-03-01'),
('Linda','Math',12,'2020-01-01'),
('Linda','English',10,'2020-02-01'),
('Linda','History',8,'2020-03-01'),
('Linda','Music',6,'2020-04-01');

-- 3. lets view data
SELECT * FROM scores;

-- 4. Lets create our first pivot table
SELECT DISTINCT(subject) FROM scores;
SELECT * FROM crosstab
(
	'
		SELECT name,subject,score FROM scores
	'
) AS ct
(
	name VARCHAR,
	Math NUMERIC,
	English NUMERIC,
	History NUMERIC,
	Music NUMERIC
);

-- Order matters in crootab
SELECT * FROM crosstab
(
	'
		SELECT name,subject,score FROM scores order by 1,2
	'
) AS ct
(
	name VARCHAR,
	English NUMERIC,
	History NUMERIC,
	Math NUMERIC,
	Music NUMERIC
);

-- Exmaining rainfalls data
SELECT * FROM rainfalls WHERE month = 1 and location='Dubai';

-- lets build a pivot to display sum of all raindays per each location for each year
SELECT * FROM crosstab
(
	'
		SELECT location,year,raindays FROM rainfalls order by 1,2
	'
) AS ct
(
	"location" text,
	"2012" int,
	"2013" int,
	"2014" int,
	"2015" int,
	"2016" int,
	"2017" int
);
SELECT DISTINCT(year) FROM rainfalls;

-- Pivoting Rows and Columns
-- By location view
SELECT * FROM crosstab(
	'
		SELECT location,month,SUM(raindays)::int
		FROM rainfalls
		GROUP BY location,month
		ORDER BY 1,2
	'
) AS CT
(
	location TEXT,
	"jan" INT,
	"feb" INT,
	"mar" INT,
	"apr" INT,
	"may" INT,
	"jun" INT,
	"jul" INT,
	"aug" INT,
	"sep" INT,
	"oct" INT,
	"nov" INT,
	"dec" INT
);

-- Matrix report via a query
SELECT
	name,
	MIN(CASE WHEN subject='English' THEN score END) English,
	MIN(CASE WHEN subject='History' THEN score END) History,
	MIN(CASE WHEN subject='Math' THEN score END) Math,
	MIN(CASE WHEN subject='Music' THEN score END) Music
FROM scores
GROUP BY name
ORDER by 3 DESC;

-- Static to dynamic pivots
/*
	Static Pivots:
	1. We've seen in both the crosstab and the traditional query form have the drawback that the;
		- Output columns must be explicitly enumerated
		- They must be added manually to the list
	2. These queries also lack flexibility;
		- To change the order of columns or transpose a different column of the source data
	3. Also, some pivots may have hundreds of columns, so listing them manually in SQL is too tedious.



	Dynamic Pivots:
	1. A polymorphic query that would automatically have row values transposed into columns without the
		need to edit the SQL statement.
*/

-- Creating a dynamic pivot query
SELECT
	location,
	json_object_agg(year,total_raindays ORDER BY year) as "mydata"
FROM 
(
	SELECT location,year,sum(raindays) AS total_raindays
	FROM rainfalls GROUP BY location,year
) s
GROUP BY location
ORDER BY LOCATION;








