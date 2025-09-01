-- Get total count of all movies group by movie language
SELECT movie_lang,COUNT(movie_lang) from movies GROUP BY movie_lang;

-- Get average movie length group by movie language
SELECT movie_lang,AVG(movie_length) FROM movies GROUP BY movie_lang;

-- Get the sum total movie length per age certificate
SELECT age_certificate,SUM(movie_length) FROM movies GROUP BY age_certificate;

-- List minimum and maximum movie length gropup by movie language
SELECT movie_lang,MAX(movie_length),MIN(movie_length) FROM movies 
GROUP BY movie_lang;

-- Get average movie length group by movie language and age certification
SELECT 
	movie_lang,
	age_certificate,
	COUNT(movie_length),
	AVG(movie_length)
FROM movies
GROUP BY movie_lang,age_certificate;

-- Get average movie length group by movie language and age certification 
-- where movie length greater than 100
SELECT 
	movie_lang,
	age_certificate,
	COUNT(movie_length),
	AVG(movie_length)
FROM movies
WHERE movie_length > 100
GROUP BY movie_lang,age_certificate;

-- Get average movie length group by movie age certificate where age certificate = 10
SELECT 
	age_certificate,
	COUNT(movie_length),
	AVG(movie_length)
FROM movies
WHERE age_certificate = 'PG'
GROUP BY age_certificate;

-- How many directors are there per each nationality;
SELECT 
	nationality,
	COUNT(directors)
FROM directors
GROUP BY nationality;

-- Get total sum movie length for each age certificate and movie language combo
SELECT 
	movie_lang,
	age_certificate,
	COUNT(movie_length),
	SUM(movie_length)
FROM movies
GROUP BY age_certificate,movie_lang;

-- Order of execution in GROUP BY
-- FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> DISTINCT -> ORDER BY -> LIMIT

-- Having clause
SELECT 
	movie_lang,
	SUM(movie_length)
FROM movies
GROUP BY movie_lang
HAVING SUM(movie_length) > 200;

-- List directors where their sum total movie length is greater then 200
SELECT 
	director_id,
	SUM(movie_length) as "Director movie sum"
FROM movies
GROUP BY director_id
HAVING SUM(movie_length) > 200;

-- Order of execution inwith having
-- FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> DISTINCT ->  ORDER BY-> LIMIT

-- HAVING vs WHERE 
-- having workds on result group vs where works on select columns

-- Handling NULL values with GROUP BY

CREATE TABLE employees_test(
	employee_id SERIAL PRIMARY KEY,
	employee_name VARCHAR(100),
	department VARCHAR(100),
	salary INT
); 
INSERT INTO employees_test (employee_name,department,salary) VALUES
('John','Finance',2500),
('Mary',NULL,3000),
('Adam',NULL,4000),
('Bruce','Finance',4000),
('Linda','IT',5000),
('Megan','IT',4000);

SELECT * FROM employees_test;9

SELECT 
	COALESCE(department,'NO DEPARTMENT') AS department,
	COUNT(salary) AS total_employees
FROM employees_test
GROUP BY department;













