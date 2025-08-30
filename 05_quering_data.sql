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





