-- Creating view with normal approach
CREATE OR REPLACE VIEW v_movie_quick AS
SELECT
	movie_name,
	movie_length,
	release_date
FROM movies mv;
SELECT * FROM v_movie_quick;

-- Lets see how to use view now
CREATE OR REPLACE VIEW v_movies_directors_all AS
SELECT
	mv.movie_id,
	mv.movie_name,
	mv.movie_length,
	mv.movie_lang,
	mv.age_certificate,
	mv.release_date,
	mv.director_id,

	d.first_name,
	d.last_name,
	d.date_of_birth,
	d.nationality
FROM movies mv
INNER JOIN directors d on d.director_id = mv.director_id;

SELECT * FROM v_movies_directors_all;

-- Rename a view
ALTER VIEW v_movie_quick RENAME TO v_movie_quick2;

-- Drop a view
DROP VIEW v_movie_quick2;

-- Using conditions/filters with views
CREATE OR REPLACE VIEW v_movies_after_1997 AS
SELECT
*
FROM movies 
WHERE release_date >= '1997-12-31'
ORDER BY release_date DESC;

-- Select all movies with english language only from the view
SELECT
*
FROM v_movies_after_1997
WHERE movie_lang='English'
ORDER BY movie_lang;

-- Select all movies with directors with american and japansese nationalities
SELECT
*
FROM movies mv
INNER JOIN directors d ON d.director_id = mv.director_id
WHERE d.nationality IN ('American','Japanese');

SELECT 
*
FROM v_movies_directors_all
WHERE nationality IN ('American','Japanese');

-- A view using SELECT and UNION with multiple tables
-- Lets have a view for all peoples in a movie like actors and directors with first and last names
CREATE VIEW v_all_actors_directors AS
SELECT
	first_name,
	last_name,
	'actors' as people_type
FROM actors
UNION ALL 
SELECT
	first_name,
	last_name,
	'directors' as people_type
FROM directors;

SELECT * FROM v_all_actors_directors
WHERE first_name LIKE 'J%';

-- Connecting multiple table with a single view
-- Lets connect movies,directors,movies revenues tables with a single view
CREATE VIEW v_movies_directors_revenues AS
SELECT
 mv.movie_id,
 mv.movie_name,
 mv.movie_length,
 mv.movie_lang,
 mv.age_certificate,
 mv.release_date,

 d.director_id,
 d.first_name,
 d.last_name,
 d.nationality,
 d.date_of_birth,

 r.revenue_id,
 r.revenues_domestic,
 r.revenues_international

FROM movies mv
INNER JOIN directors d ON d.director_id = mv.director_id
INNER JOIN movies_revenues r ON r.movie_id = mv.movie_id;

SELECT
*
FROM v_movies_directors_revenues;


-- Changing Views
-- Can i re-arrange a column to an existing view?
CREATE VIEW v_directors AS
SELECT
	first_name,
	last_name
FROM directors;

-- Can i remove a column from an existing view??
-- drop old view then 
CREATE VIEW v_directors AS
SELECT first_name from directors;

-- Can i add a column to an exising view??
CREATE OR REPLACE VIEW v_directors AS
SELECT
	first_name,
	last_name,
	nationality
FROM directors;

CREATE OR REPLACE VIEW v_directors AS
SELECT
	first_name,
	nationality,
	last_name
FROM directors;

-- A regular view
-- does not store data physically
-- always give updated data
SELECT 
*
FROM v_directors;
INSERT INTO directors (first_name) VALUES ('test name1');
DELETE FROM directors where director_id = 39;
SELECT * FROM directors;


-- WHAT IS AN UPDATABLE VIEW
-- An updatable view allows you to update the data on the underlyuing data. however there are some rules to follow:
-- 1. The querymust have one FROM entry which can be either a table or another updatable view
-- 2. The query cannot contains the following at the top level: DISTINCE,GROUP BY,WITH,LIMIT,OFFSET,UNION,INTERSECT,EXCEPT,hAVING
-- 3. You cannot use the following in selection list Any window function,any set-retruning function,any aggregat function
-- 4. You can use the following operations t update data: INSERT,UPDATE,DELETE along with say a where clause
-- 5. When you perform an update operations, user must have corresponsding privilege on the view, but you don't need to have privilege on the underlying table. This will help a lot on sercuing database.

-- Create updatable view
CREATE OR REPLACE VIEW vu_directors AS
SELECT
	first_name,
	last_name
FROM directors;
INSERT INTO vu_directors (first_name) 
VALUES ('dir1'),('dir2');
DELETE FROM vu_directors WHERE first_name='dir1';
SELECT * FROM vu_directors;
SELECT * FROM directors;

-- Updatable views using WITH CHECK OPTION
 CREATE TABLE countries(
	country_id SERIAL PRIMARY KEY,
	country_code VARCHAR(4),
	city_name VARCHAR(100)
 );
INSERT INTO countries (country_code,city_name) VALUES
('US','New York'),
('US','New Jersey'),
('UK','London');
SELECT * FROM countries;

CREATE OR REPLACE VIEW v_cities_us AS
SELECT
	country_id,
	country_code,
	city_name
FROM countries
WHERE country_code='US';
SELECT * FROM v_cities_us;
INSERT INTO v_cities_us (country_code,city_name) VALUES
('US','California');
SELECT * FROM v_cities_us;
CREATE OR REPLACE VIEW v_cities_us AS
SELECT
	country_id,
	country_code,
	city_name
FROM countries
WHERE country_code='US'
WITH CHECK OPTION;

INSERT INTO v_cities_us(country_code,city_name) VALUES
('UK','Leeds');
SELECT * FROM v_cities_us;
UPDATE v_cities_us
SET country_code='UK'
WHERE city_name='New York';


-- Using LOCAL and CASCADED in WITH CHECK OPTION
CREATE OR REPLACE VIEW v_cities_c AS
SELECT
	country_id,
	country_code,
	city_name
FROM countries
WHERE city_name LIKE 'C%';
SELECT * FROM v_cities_c;

CREATE OR REPLACE VIEW v_cities_c_us AS
SELECT
	country_id,
	country_code,
	city_name
FROM 
	v_cities_c
WHERE
	country_code = 'US'
WITH LOCAL CHECK OPTION;

-- The local conditions are satisfied within the curren tview i.e v_cities_c_us
-- The data must be of country_coe='US' for all data

INSERT INTO v_cities_c_us (country_code,city_name) VALUES
('US','Connectioncut');
SELECT * FROM v_cities_c_us;
INSERT INTO v_cities_c_us (country_code,city_name) VALUES
('US','Los Angles');
SELECT * FROM v_cities_c_us;
SELECT * FROM v_cities_c;
SELECT * FROM countries;

CREATE OR REPLACE VIEW v_cities_c_us AS
SELECT
	country_id,
	country_code,
	city_name
FROM 
	v_cities_c
WHERE
	country_code = 'US'
WITH CASCADED CHECK OPTION;

INSERT INTO v_cities_c_us (country_code,city_name) VALUES
('US','Boston');
INSERT INTO v_cities_c_us (country_code,city_name) VALUES
('US','Clearwater');
SELECT * FROM v_cities_c_us;
SELECT * FROM v_cities_c;
SELECT * FROM countries;


-- What is a Materialized View
-- it allow you to store result of a query physically and update the data periodically
-- A materialized view caches the result of a complex expensive query and then allow you to refresh this result periodically.
-- A materialized view executes the query once and then  holds onto those reults for your viewing pleasure unitl you refresh the materialized view again.
-- It is used to cache results of a heavy query.

-- Creating a materialized view
CREATE MATERIALIZED VIEW IF NOT EXISTS view_name AS query
WITH [NO] DATA;

CREATE MATERIALIZED VIEW IF NOT EXISTS mv_directors AS  
SELECT
	first_name,
	last_name
FROM directors
WITH DATA;

SELECT * FROM mv_directors;

CREATE MATERIALIZED VIEW IF NOT EXISTS mv_directors_nodata AS  
SELECT
	first_name,
	last_name
FROM directors
WITH NO DATA;

SELECT * FROM mv_directors_nodata;

REFRESH MATERIALIZED VIEW mv_directors_nodata;

SELECT * FROM mv_directors_nodata;

-- Drop a materialized view
DROP MATERIALIZED VIEW mv_director2;

-- materialized view with no data clause you are locking that table for as lnngs as it takes. tofully populate the view.

-- Changing Material view data
INSERT INTO mv_directors (first_name) values ('dir1'),('dir2'); --can't delete
DELETE FROM mv_directors WHERE first_name = 'dir1'; -- can't delete
UPDATE mv_directors SET first_name='ddir1' WHERE first_name='dir1'; -- can't delete


SELECT * FROM mv_directors;
INSERT INTO directors (first_name) values ('dir1'),('dir2');
REFRESH MATERIALIZED VIEW mv_directors;

-- How to check if a materialized view is populated or not??
CREATE MATERIALIZED VIEW mv_directors2 AS
SELECT
	first_name
FROM directors 
WITH NO DATA;
SELECT relispopulated FROM pg_class WHERE relname = 'mv_directors2';

-- How to refrresh data in a materialized view??
CREATE MATERIALIZED VIEW mv_directors_us AS
SELECT
	director_id,
	first_name,
	last_name,
	date_of_birth,
	nationality
FROM directors
WHERE nationality='American'
WITH NO DATA;
REFRESH MATERIALIZED VIEW mv_directors_us;
SELECT * FROM mv_directors_us;

-- REFRESH materialized view concurrently
CREATE UNIQUE INDEX idx_u_mv_directors_us_director_id 
ON mv_directors_us (director_id);
REFRESH MATERIALIZED VIEW CONCURRENTLY mv_directors_us;

-- Why not use a table instead of materialized view??
-- The major benifit over table is the ability to easily refresh it without locking everyoine else out of it.


-- Downside of using material views
-- Materialized views are dependent of their base table
-- Create dependencies on the tables they reference


-- Using materialized view for a website page clicks analytics
CREATE TABLE page_clicks(
	rec_id SERIAL PRIMARY KEY,
	page VARCHAR(200),
	click_time TIMESTAMP,
	user_id BIGINT
);

SELECT * FROM page_clicks;

INSERT INTO page_clicks(page,click_time,user_id)
SELECT 
(
	CASE (RANDOM() *2)::INT
		WHEN 0 THEN 'klickanalytics.com'
		WHEN 1 THEN 'clickapis.com'
		WHEN 2 THEN 'google.com'
	END
) AS page,
NOW() as click_time,
(FLOOR(random() * (111111111-10000000 +1) + 100000000))::INT as user_id
FROM GENERATE_SERIES(1,1000) seq;

SELECT * FROM page_clicks;

-- to analyze a dailly trend
CREATE MATERIALIZED VIEW mv_page_clicks AS
SELECT
	date_trunc('day',click_time) as day,
	page,
	COUNT(*) as total_clicks
FROM page_clicks
GROUP BY day,page;
REFRESH MATERIALIZED VIEW mv_page_clicks;
SELECT * FROM mv_page_clicks;

-- List all meterialized views
SELECT oid::regclass::text
FROM pg_class
WHERE relkind = 'm';














