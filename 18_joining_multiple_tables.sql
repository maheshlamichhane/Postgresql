-- INNER JOINS
-- Let combine movies and directors tables
SELECT * FROM movies INNER JOIN directors 
ON movies.director_id = directors.director_id;

SELECT 
	movies.movie_id,
	movies.movie_name,
	movies.director_id,
	directors.first_name
FROM movies 
INNER JOIN directors 
ON movies.director_id = directors.director_id;

SELECT 
	m.movie_id,
	m.movie_name,
	d.first_name
FROM movies m
INNER JOIN directors d
ON m.director_id = d.director_id;

SELECT 
	m.movie_id,
	m.movie_name,
	m.movie_lang,
	d.first_name
FROM movies m
INNER JOIN directors d
ON m.director_id = d.director_id
WHERE m.movie_lang='English' AND d.director_id = 3;

SELECT 
	m.*,
	d.first_name
FROM movies m
INNER JOIN directors d
ON m.director_id = d.director_id;

-- INNER JOIN with USING
-- Lets connect 'movies' and 'directors' table with using keyword
SELECT * FROM movies INNER JOIN directors 
USING (director_id);

-- Can we connect movies and movies_revenues too ??
SELECT * FROM movies 
INNER JOIN movies_revenues USING (movie_id);

-- Can we connect more than two tables
SELECT * FROM movies 
INNER JOIN directors USING (director_id)
INNER JOIN movies_revenues USING (movie_id);

-- Select movie name,director name,domestic revenues for all japanesse movies
SELECT
	m.movie_name,
	d.first_name,
	mr.revenues_domestic
FROM movies m
INNER JOIN directors d USING(director_id)
INNER JOIN movies_revenues mr USING(movie_id)
WHERE m.movie_lang='Japanese';

-- Select movie name, director name for all English, Chisese and Japansese 
-- where domestic revenues is greater then 100
SELECT
	m.movie_name,
	d.first_name
FROM movies m
INNER JOIN directors d USING(director_id)
INNER JOIN movies_revenues mr USING(movie_id)
WHERE m.movie_lang IN ('Japansese','English','Chinese') 
AND mr.revenues_domestic > 100;

-- Select movie name, director name, movie language, total revenues for all top 5 movies
SELECT
	m.movie_name,
	m.movie_lang,
	d.first_name,
	(mr.revenues_domestic + mr.revenues_international) AS "total_revenues"
FROM movies m
INNER JOIN directors d USING(director_id)
INNER JOIN movies_revenues mr USING(movie_id)
ORDER BY 4 DESC NULLS LAST
OFFSET 1 LIMIT 5;

-- What were the top 10 most profitable movies between year 2005 and 2008. Print 
-- the movie name, director name,movie lang,total revenues;
SELECT
	m.movie_name,
	m.movie_lang,
	m.release_date,
	d.first_name,
	(mr.revenues_domestic + mr.revenues_international) AS "total_revenues"
FROM movies m
INNER JOIN directors d USING(director_id)
INNER JOIN movies_revenues mr USING(movie_id)
WHERE m.release_date BETWEEN '2005-01-01' AND '2008-12-31'
ORDER BY 4 DESC NULLS LAST
OFFSET 1 LIMIT 10;

-- How to inner join tables with different columns data types
CREATE TABLE t1(test INT);
CREATE TABLE t2(test VARCHAR(10));
SELECT * FROM t1 INNER JOIN t2 ON t1.test = CAST(t2.test AS INT);

-- LEFT Joins
CREATE TABLE left_products (
	product_id SERIAL PRIMARY KEY,
	product_name VARCHAR(100)
);

CREATE TABLE right_products (
	product_id SERIAL PRIMARY KEY,
	product_name VARCHAR(100)
);

INSERT INTO left_products (product_id,product_name) VALUES
(1,'Computers'),
(2,'Laptops'),
(3,'Monitors'),
(5,'Mics');

INSERT INTO right_products (product_id,product_name) VALUES
(1,'Computers'),
(2,'Laptops'),
(3,'Monitors'),
(4,'Pen'),
(7,'Paper');

SELECT * FROM left_products l LEFT JOIN right_products r
ON l.product_id = r.product_id;

-- List all the movies with directors first and last names and movie name
SELECT 
m.movie_name,
d.first_name,
d.last_name
FROM movies m
LEFT JOIN directors d
ON m.director_id = d.director_id;

-- reverse
SELECT 
m.movie_name,
d.first_name,
d.last_name
FROM directors d
LEFT JOIN movies m
ON m.director_id = d.director_id;

INSERT INTO directors (first_name,last_name,date_of_birth,nationality) VALUES
('James','David','2010-01-01','American');

-- Can we add a where conditions say get list of english and chinese movies only
SELECT 
m.movie_name,
d.first_name,
d.last_name
FROM directors d
LEFT JOIN movies m
ON m.director_id = d.director_id
WHERE m.movie_lang IN ('English','Chinese');

-- Count all movies for each directors
SELECT 
d.first_name,
d.last_name,
COUNT(*) AS "total movies"
FROM directors d
LEFT JOIN movies m
ON m.director_id = d.director_id
GROUP BY first_name,last_name


-- Get all the movies with age certification for all directors where nationalities are
-- 'American','Chinese' and 'Japanese'
SELECT 
d.first_name,
d.last_name,
m.movie_name,
m.age_certificate
FROM directors d
LEFT JOIN movies m
ON m.director_id = d.director_id
WHERE d.nationality IN ('American','Chinese','Japanese');

-- Get all the total revenues done by all films for each directors
SELECT 
d.first_name,
d.last_name,
SUM(mr.revenues_domestic + mr.revenues_international) AS "total revenues"
FROM directors d
LEFT JOIN movies m
ON m.director_id = d.director_id
LEFT JOIN movies_revenues mr
ON m.movie_id = mr.movie_id
GROUP BY d.first_name,d.last_name

-- RIGHT JOINS
SELECT 
* 
FROM left_products
RIGHT JOIN right_products
ON left_products.product_id = right_products.product_id;

-- List all the movies with directors first and last names and movie name
SELECT
	d.first_name,
	d.last_name,
	mv.movie_name
FROM directors d
RIGHT JOIN movies mv on mv.director_id = d.director_id;

SELECT
	d.first_name,
	d.last_name,
	mv.movie_name
FROM movies mv
RIGHT JOIN directors d on mv.director_id = d.director_id;

-- Count all movies for each directors
SELECT
	d.first_name,
	d.last_name,
	COUNT(*)
FROM movies mv
RIGHT JOIN directors d on mv.director_id = d.director_id
GROUP BY d.first_name,d.last_name


-- FULL JOIN
SELECT
*
FROM left_products
FULL JOIN right_products ON left_products.product_id = right_products.product_id;

-- Joining multiple tables via JOIN
-- Same as INNER JOIN,shortkurt for it.
-- Lets join movies,directors and movies revenues tables
SELECT 
* FROM movies mv
JOIN directors d on d.director_id = mv.director_id
JOIN movies_revenues r on r.movie_id = mv.movie_id;

-- Self JOIN
SELECT 
*
FROM left_products t1
INNER JOIN left_products t2 
ON t1.product_id = t2.product_id;

-- Let self join directors table
SELECT
*
FROM directors t1
INNER JOIN directors t2 ON t1.director_id = t2.director_id;

-- Lets self join finds all pair of movies that have the same movie length
SELECT
	t1.movie_name,
	t2.movie_name,
	t1.movie_length
FROM movies t1
INNER JOIN movies t2
ON t1.movie_length = t2.movie_length
AND t1.movie_name <> t2.movie_name;

-- CROSS JOIN Cartesian product
SELECT 
*
FROM left_products
CROSS JOIN right_products;

-- Natural Join it can be either inner,left or right
SELECT 
* 
FROM left_products
NATURAL JOIN right_products;

SELECT 
* 
FROM left_products
NATURAL LEFT JOIN right_products;

SELECT 
* 
FROM left_products
NATURAL RIGHT JOIN right_products;
