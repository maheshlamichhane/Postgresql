-- String uppercase
SELECT UPPER ('amazing postgresql');
SELECT 
	UPPER(first_name) as first_name,
	UPPER(last_name) as last_name
FROM directors;

-- String lowercase
SELECT LOWER('Amazing Postgresql');
SELECT 
	LOWER(first_name) as first_name,
	LOWER(last_name) as last_name
FROM directors;

-- String initcap
SELECT INITCAP('the world is changing with a lighting speed');
SELECT 
	INITCAP(
		CONCAT(first_name,' ', last_name)
		) AS full_name
FROM
	directors;

-- String LEFT functions
SELECT LEFT('ABCD',1);
SELECT LEFT('ABC',-2);
SELECT LEFT(first_name,1) AS initial FROM directors ORDER BY 1;
SELECT movie_name, LEFT(movie_name,6) FROM movies;

-- String RIGHT functions
SELECT RIGHT('ABCD',2);
SELECT RIGHT('ABCD',-1);
SELECT last_name FROM directors WHERE RIGHT(last_name,2) = 'on';

-- String REVERSE function
SELECT REVERSE('Amazing PostgreSQL');

-- String SPLIT_PART function
SELECT SPLIT_PART('1,2,3',',',2);
SELECT SPLIT_PART('ONE,TWO,THREE',',',2);
SELECT SPLIT_PART('A|B|C|D','|',3);
SELECT movie_name,release_date,
SPLIT_PART(release_date::text,'-',1) as release_year
FROM movies;
SELECT * FROM movies;

-- String TRIM,BTRIM,LTRIM and RTRIM functions
SELECT
TRIM(LEADING FROM ' Amazing PostgreSQL'),
TRIM(TRAILING FROM 'Amazing PostgreSQL '),
TRIM(' Amazing PostgreSQL ');
SELECT TRIM(LEADING '0' FROM CAST (000123456 AS TEXT));
SELECT LTRIM('yummy','y');
SELECT RTRIM('yummy','y');
SELECT BTRIM('yummy','y');
SELECT LTRIM(' Amazing PostgeSQL');
SELECT LTRIM('Amazing PostgeSQL');
SELECT RTRIM('Amazing PostgeSQL ');

-- String LPAD and RPAD
SELECT LPAD('Database',15,'*');
SELECT RPAD('Database',15,'*');
SELECT LPAD('1111',6,'A');

-- String LENGTH function
SELECT LENGTH('Amazing PostgreSQL');
SELECT LENGTH (CAST(100122 AS TEXT));
SELECT length('Amazing dude');
SELECT char_length('');
SELECT char_length(' ');

SELECT first_name || ' ' || last_name AS full_name,
LENGTH(first_name || ' ' || last_name) full_name_length
FROM directors ORDER BY 2 DESC;

-- String POSITION function
SELECT POSITION('Amazing' IN 'Amazing PostgreSQL');
SELECT POSITION('omp' IN 'THis is a computer');
SELECT position('A' IN 'KlickAnalytics.');

-- String STRPOS function
SELECT strpos('World Bank','bank');
SELECT first_name,last_name FROM directors WHERE strpos(last_name,'on') > 0;

-- String SUBSTRING function
SELECT substring('What a wonderful world' from 1 for 4);
SELECT substring('What a wonderful world' from 8 for 10);
SELECT substring('What a wonderful world' for 7);

SELECT first_name,last_name,SUBSTRING(first_name,1,1) AS initial
FROM directors ORDER BY last_name;

-- String REPEAT function
SELECT repeat('A',4);
SELECT repeat(' ',10);



-- String REPLACE Function
SELECT REPLACE('ABC XYZ','X','1');
SELECT replace('What a wonderful world', 'a wonderful', 'an amazing');
SELECT replace('I like cats','cats','dogs');









