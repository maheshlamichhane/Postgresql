-- Get all records from movies table
SELECT * FROM movies;

-- Get all actors
SELECT * FROM actors;

-- Get first_name from actors table
SELECT first_name FROM actors;

-- Get first_name and last_name from actors table
SELECT first_name,last_name FROM actors;

-- Get movie_name,movie_lang from movies table
SELECT movie_name,movie_lang FROM movies;

-- Lets get all records from actors table, and review it from non tech pov
SELECT * FROM actors;

-- Make an alias for first_name 
SELECT first_name AS firstName FROM actors;
SELECT first_name AS "firstName" FROM actors;
SELECT first_name AS "First Name" FROM actors;
SELECT movie_name AS "Movie Name", movie_lang AS "Language" FROM movies;
SELECT movie_name "Movie Name", movie_lang "Language" FROM movies;


-- Asigning column alias to expression
SELECT first_name || last_name from actors;
SELECT first_name || ' ' || last_name from actors;
SELECT first_name || ' ' || last_name AS "Full Name" FROM actors;
SELECT 10*2 AS total;


-- Sort based on single colunn9
SELECT * FROM movies ORDER BY release_date ASC;
SELECT * FROM movies ORDER BY release_date DESC;

-- Sort based on multiple columns
SELECT * FROM movies ORDER BY release_date DESC,movie_name DESC;

-- Column and order by as alias 
SELECT first_name,last_name AS surname FROM actors ORDER BY surname;

-- Calculate the length of the actor name
SELECT first_name,LENGTH(first_name) AS len FROM actors;

-- Sort rows by length of the actor name in desc
SELECT first_name,LENGTH(first_name) AS len FROM actors ORDER BY len DESC;

--  Sort all records by first_name asc, date_of_birth descending
SELECT * FROM actors ORDER BY first_name ASC,date_of_birth DESC;

-- Use column number instead of column name for sorting 
SELECT first_name,last_name,date_of_birth FROM actors ORDER BY 1 ASC,2 DESC;


-- Using order by with NULL values
CREATE TABLE demo_sorting(
	num INT
);
INSERT INTO demo_sorting(num) VALUES (1),(2),(3),(NULL);
SELECT * from demo_sorting;
SELECT * from demo_sorting ORDER By num ASC;
SELECT * FROM demo_sorting ORDER BY num NULLS FIRST;
SELECT * from demo_sorting ORDER By num DESC;
SELECT * from demo_sorting ORDER By num DESC NULLS LAST;
DROP table demo_sorting;

-- Select distinct data from column
SELECT DISTINCT movie_lang FROM movies ORDER BY 1;
SELECT DISTINCT movie_lang,director_id FROM movies ORDER By 1;
SELECT DISTINCT * FROM movies;













