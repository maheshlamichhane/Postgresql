-- Sub query
-- find the movies avg length and use this result to fond movies which are more then average movie length
SELECT 
	movie_name,
	movie_length
FROM movies
WHERE movie_length  >
(
SELECT
	AVG(movie_length)
FROM movies
)
ORDER BY movie_length DESC;

-- Can we filter the previous records for english movies only
SELECT 
	movie_name,
	movie_length
FROM movies
WHERE movie_length  >
(
SELECT
	AVG(movie_length)
FROM movies
WHERE movie_lang='English'
)
ORDER BY movie_length DESC;

-- Get first and last name of all actors who are younger than douglas silva
SELECT 
	first_name,
	last_name,
	date_of_birth
FROM actors
WHERE date_of_birth >
(
SELECT
date_of_birth
FROM actors
WHERE first_name='Douglas'
);

-- Subquery with IN operator
-- What if inner query or subquery is returning multiple records?
-- Find all movies where domestic revenues are greater than 200
SELECT
	movie_name,
	movie_lang
FROM movies
WHERE movie_id IN
(
	SELECT 
		movie_id
	FROM movies_revenues
	WHERE
		revenues_domestic > 200
);

-- FInd all movies where domestic revenues are higher than  international revenues
SELECT
	movie_id,
	movie_name
FROM movies
WHERE movie_id IN
(
SELECT 
movie_id
FROM movies_revenues
WHERE revenues_domestic > revenues_international
);

-- Subquery with Joins
-- List all the directors where their movies made more than the average total revenues of all english moviesl

SELECT
	d.director_id,
	SUM(r.revenues_domestic + r.revenues_international) AS "total_revenues"
FROM directors d
INNER JOIN movies mv ON mv.director_id = d.director_id
INNER JOIN movies_revenues r ON r.movie_id = mv.movie_id
WHERE 
	(r.revenues_domestic + r.revenues_international) >
(
SELECT 
	AVG(revenues_domestic + revenues_international)  AS "total_revenues"
FROM movies_revenues
)
GROUP BY d.director_id;


-- Order entries in a UNION without ORDER BY?
SELECT 
* 
FROM 
(
SELECT first_name, 0 myorder,'actors' as table_name FROM actors
UNION
SELECT first_name, 1, 'directors' as table_name  FROM directors
) t
ORDER BY myorder;


-- Sub query with an alias
-- List all movies records
SELECT
*
FROM 

(
	SELECT 
	*
	FROM movies
) t1;


-- A SELECT without a FROM
SELECT(
	SELECT MAX(revenues_domestic) FROM movies_revenues
),
(
	SELECT MIN(revenues_domestic) FROM movies_revenues
);


-- Correlated Subqueries
-- A correlated subquery is a subquery that contains a reference to a table(in the parent query) that also apperas in the outer query.
-- List movie name,movie lang and movie age certification for all movies win an above minimum length of 
-- for each age certification
SELECT
	mv1.movie_name,
	mv1.movie_lang,
	mv1.movie_length,
	mv1.age_certificate
FROM movies mv1
WHERE mv1.movie_length >
(
	SELECT 
		MIN(movie_length) 
	FROM movies mv2
	WHERE mv1.age_certificate = mv2.age_certificate
)
ORDER BY mv1.movie_length ASC;

-- List first name, last name and date of birth for the oldest actor foe each gender
SELECT
	ac1.first_name,
	ac1.last_name,
	ac1.date_of_birth,
	ac1.gender
FROM actors ac1
WHERE 
	ac1.date_of_birth >
	(
		SELECT MIN(date_of_birth) FROM actors ac2
		WHERE ac1.gender = ac2.gender
	)
ORDER BY ac1.gender,ac1.date_of_birth;

-- Using IN with subquery
-- Find suppliers that are same countries as customers
SELECT * FROM customers;
SELECT * FROM suppliers;

SELECT
*
FROM suppliers
WHERE
	country IN (SELECT country FROM customers);


-- Using ANY with subquery
-- Find customers details where they ordered more than 20 items in a single product
SELECT
*
FROM customers
WHERE
customer_id = ANY
(
	SELECT 
		customer_id
	FROM orders
	INNER JOIN order_details ON order_details.order_id = orders.order_id
	WHERE order_details.quantity > 20
);

-- Using ALL with subquery
-- Find all products where their order amount were lower than the average amount of all the products.

SELECT
*
FROM products
INNER JOIN order_details ON order_details.product_id = products.product_id
WHERE ((order_details.unit_price * order_details.quantity)-order.details.discount) < ALL
(
	-- avg price of all products
	SELECT
		AVG((unit_price * quantity) - discount)
	FROM order_details
	
)














