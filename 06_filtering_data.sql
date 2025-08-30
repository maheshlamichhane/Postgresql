-- Get all japanese language movies
SELECT * FROM movies WHERE movie_lang = 'Japanese';

-- Use multiple condition
SELECT * FROM movies WHERE movie_lang='English' AND age_certificate ='18';

-- Get all english language or chinese movies
SELECT * FROM movies WHERE movie_lang='English' OR movie_lang='Chinese';

-- Get all English language and director id equal to 8 
SELECT * FROM movies WHERE movie_lang='English' AND director_id='8';

-- Get all english or chinise movies and movies with age_certiface equal to 12
SELECT * FROM movies WHERE (movie_lang='English' OR movie_lang='Chinese')
AND age_certificate='12';

-- where with aliases not possible
SELECT first_name,last_name AS surname FROM actors WHERE surname='Allen';

-- FROM | WHERE | SELECT | ORDER BY order of execution
SELECT * FROM movies WHERE movie_lang='English' ORDER BY movie_length DESC;

-- Logical operators
SELECT * FROM movies WHERE movie_length > 100;
SELECT * FROM movies WHERE movie_length >= 100;
SELECT * FROM movies WHERE movie_length >= '100';
SELECT * FROM movies WHERE movie_length < 100;
SELECT * FROM movies WHERE movie_length <= 100;
SELECT * FROM movies WHERE release_date = '2000-07-06';
SELECT * FROM movies WHERE release_date > '2000-07-06';
SELECT * FROM movies WHERE movie_length != 100;
SELECT * FROM movies WHERE movie_lang > 'English';
SELECT * FROM movies WHERE movie_lang < 'English';
SELECT * FROM movies WHERE movie_lang <> 'English';

-- Using limit and offset to limit records
SELECT * FROM movies ORDER BY movie_length DESC LIMIT 5;
SELECT * FROM directors WHERE nationality = 'American' 
ORDER BY date_of_birth ASC LIMIT 5;
SELECT * FROM actors WHERE gender='F' ORDER BY date_of_birth DESC LIMIT 10;
SELECT * FROM movies_revenues ORDER BY revenues_domestic 
DESC NULLS LAST  LIMIT 10;
SELECT * FROM movies ORDER BY movie_id LIMIT 5 OFFSET 4;
SELECT * FROM movies_revenues ORDER BY revenues_domestic DESC NULLS LAST 
LIMIT 5 OFFSET 5;

-- Using fetch
SELECT * FROM movies FETCH FIRST 1 ROW ONLY;
SELECT * FROM movies FETCH FIRST 5 ROW ONLY;
SELECT * from movies ORDER BY movie_length DESC FETCH FIRST 5 ROW ONLY;
SELECT * FROM directors ORDER BY date_of_birth ASC FETCH FIRST 5 ROW ONLY;
SELECT * FROM actors WHERE gender='F' ORDER BY 
date_of_birth DESC FETCH FIRST 10 ROW ONLY;
SELECT * FROM movies ORDER BY movie_length DESC
FETCH FIRST 5 ROW ONLY
OFFSET 5;

-- Use In and NOT IN
SELECT * FROM movies WHERE movie_lang IN ('Chinese','English')
ORDER BY movie_lang;
SELECT * FROM movies WHERE movie_lang NOT IN ('Chinese','English')
ORDER BY movie_lang;

-- Use BETWEEN and NOT BETWEEN
SELECT * FROM actors WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-01-01'
ORDER BY date_of_birth;
SELECT * FROM actors WHERE date_of_birth NOT BETWEEN '1990-01-01' AND '2000-01-01'
ORDER BY date_of_birth;
SELECT * FROM movies WHERE  director_id BETWEEN 10 AND 15 ORDER BY director_id;
SELECT * FROM movies WHERE  director_id NOT BETWEEN 10 AND 15 ORDER BY director_id;

-- Use like operator
SELECT * FROM actors WHERE first_name LIKE 'A%' ORDER BY first_name;
SELECT * FROM actors WHERE last_name LIKE '%a' ORDER BY last_name;
SELECT * FROM actors WHERE first_name LIKE '_____' ORDER BY first_name;
SELECT * FROM actors WHERE first_name LIKE '_l%' ORDER BY first_name;
SELECT * FROM actors WHERE first_name LIKE '%Tim%' ORDER BY first_name;
SELECT * FROM actors WHERE first_name ILIKE '%tim%' ORDER BY first_name;

-- Use IS NULL and NOT NULL operator
SELECT * FROM actors WHERE date_of_birth IS NULL;
SELECT * FROM actors WHERE date_of_birth IS NOT NULL;

-- Concatenate techniques
SELECT 'string1' || 'string2' AS new_String;
SELECT 'string1' || ' ' || 'string2' AS new_String;
SELECT CONCAT(first_name,last_name) AS fullname FROM actors;
SELECT CONCAT_WS(' ',first_name,last_name) AS fullname FROM actors;

-- When concatenaitno, how NULL values are handles
SELECT 'Hello' || ' ' || 'World';
SELECT 'Hello' || NULL || 'World';
SELECT revenues_domestic,revenues_international,CONCAT(revenues_domestic,
revenues_international) AS profits FROM movies_revenues;









