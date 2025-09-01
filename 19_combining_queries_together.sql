-- Combining queries together with UNION
SELECT 
	product_id,product_name
FROM left_products
UNION
SELECT
	product_id,product_name
FROM right_products;

 -- Do we get deuplicate records when we used UNION? no
INSERT INTO right_products (product_id,product_name) VALUES ('11','Pen');

-- Lets combine directors and actors table
SELECT
	first_name,
	last_name,
	'directors' AS "tablename"
FROM directors
UNION
SELECT
	first_name,
	last_name,
	'actors' AS "tablename"
FROM actors
ORDER BY first_name ASC;

-- Lets combine all directors where nationality are american,chinese and japanese with all female actors
SELECT 
	first_name,
	last_name
FROM directors
WHERE nationality IN ('American','Chinese','Japanese')
UNION
SELECT
	first_name,
	last_name
FROM actors 
WHERE 
	gender='F';


-- Select the first name and last name of all directors and actors wihc are born after 1990
SELECT
	first_name,
	last_name,
	date_of_birth,
	'directors' AS "tablename"
FROM directors
WHERE
	date_of_birth > '1970-12-31'
UNION
SELECT
	first_name,
	last_name,
	date_of_birth,
	'actors' AS "tablename"
FROM actors
WHERE date_of_birth > '1970-12-31'
ORDER BY first_name ASC;

-- Select the first name and last name of all directors and actors where
-- therir first names starts with 'A'
SELECT
	first_name,
	last_name,
	'directors' AS "tablename"
FROM directors
WHERE
	first_name like 'A%'
UNION
SELECT
	first_name,
	last_name,
	'actors' AS "tablename"
FROM actors
WHERE first_name like 'A%'
ORDER BY first_name ASC;

-- How to combine table with different column
CREATE TABLE table1(
	col1 INT,
	col2 INT
);
CREATE TABLE table2(
	col3 INT
);

SELECT col1,col2 FROM table1
UNION  
SELECT NULL as col1,col3 FROM table2;
drop table table2;

-- Combining queries together with INTERSECT
SELECT 
	product_id,
	product_name
FROM left_products
INTERSECT
SELECT
	product_id,
	product_name
FROM right_products;

-- Lets intersect first name, last name of directors and actors tables
SELECT
	first_name,
	last_name
FROM directors
INTERSECT
SELECT
	first_name,
	last_name
FROM actors;

-- Combining queries together with EXCEPT
SELECT
	product_id,
	product_name
FROM left_products
EXCEPT
SELECT
	product_id,
	product_name
FROM right_products

-- lets EXCEPT first name, last name of directors and actors
SELECT
	first_name,
	last_name
FROM directors
EXCEPT
SELECT
	first_name,
	last_name
FROM actors;










