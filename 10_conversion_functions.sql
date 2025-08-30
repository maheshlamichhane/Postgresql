-- Convert an integer to a string
SELECT TO_CHAR(100870,'9,99999');

-- lets view movie release dae in DD-MM-YYYY format
SELECT release_date,TO_CHAR(release_date,'DD-MM-YYYY'),
TO_CHAR(release_date,'Dy, MM, YYYY') FROM movies;

-- converting timestamp literal to a string
SELECT TO_CHAR(TIMESTAMP '2020-01-01 10:30:5','HH24:MI:SS');

-- Adding currency symbol to say movies revenues
SELECT movie_id,revenues_domestic,TO_CHAR(revenues_domestic,'$99999D99') 
FROM movies_revenues;

-- Convert a string to a number
SELECT TO_NUMBER('1420.88','9999.');

-- Formating
SELECT TO_NUMBER('$1,420.64','L9G999.99');
SELECT TO_NUMBER('1,234,567.87','9G999g999D99');


-- String to date
SELECT TO_DATE('2020/10/22','YYYY/MM/DD');
SELECT TO_DATE('022188','MMDDYY');
SELECT TO_DATE('March 07, 2018', 'Month DD, YYYY');

-- String to timestamp
SELECT TO_TIMESTAMP('2020-10-28 10:30:25','YYYY-MM-DD HH:MI:SS');
SELECT TO_TIMESTAMP('2020-01-01 23:08:00','YYYY-MM-DD HH24:MI:SS');






SELECT * from movies;