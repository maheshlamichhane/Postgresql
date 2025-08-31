-- count function
SELECT count(*) FROM movies;
SELECT count(movie_length) FROM movies;
SELECT count(DISTINCT(movie_lang)) FROM movies;
SELECT count(DISTINCT(director_id)) FROM movies;
SELECT count(*) FROM movies WHERE movie_lang='English';

-- sum function
SELECT SUM(revenues_domestic) FROM movies_revenues;
SELECT SUM(revenues_domestic) FROM movies_revenuespublic
WHERE revenues_domestic > 200;
SELECT SUM(movie_length) FROM movies WHERE movie_lang='English';
SELECT SUM(DISTINCT revenues_domestic) FROM movies_revenues;

-- min and max functions
SELECT MAX(movie_length) FROM movies;
SELECT MIN(movie_length) FROM movies;
SELECT MAX(movie_length) FROM movies WHERE movie_lang='Japanese';
SELECT MAX(release_date) FROM movies WHERE movie_lang='Chinese';
SELECT MAX(movie_name) FROM movies;
SELECT MIN(movie_name) FROM movies;

-- greatest and least functions
SELECT GREATEST(200,20,30);
SELECT LEAST(-10,3,100);
SELECT GREATEST('A','B','C');
SELECT LEAST('A','B','C');
SELECT movie_id,revenues_domestic,revenues_international,
GREATEST(revenues_domestic,revenues_international) AS "GREATEST"
FROM movies_revenues;

-- AVG Average function
SELECT AVG(movie_length) FROM movies;

-- Combining columns using Mathematical operators
SELECT 2+10 AS addition;
SELECT 2-10 AS substraction;
SELECT 2*10 AS multiplication;
SELECT 11/2 AS divide;
SELECT 11%2 AS modulo;




