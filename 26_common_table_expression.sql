-- Common Table Expressions
-- CTE is a temporary result taken from a sql statement. A good alternative of sub queries.
-- Using the CTE, you can define one or more tables upfront with subqueries
-- Unklike subqueries, CTEs can be reference multiple times in multiple places in query statement
-- it can be used to improve readability and interpretbility of the code.
-- CTE are non-recursive type by default
-- Lifetime of a CTE is a lifetime of a query.
-- From postgrewql version 12 things have changede new options introduced Materalized and non materialized.

-- Syntax
WITH cte_name (column_list) AS (
	CTE_query_definition
)
statement;

-- The statment can contains SELECT, INSERT, UPDATE, or DELETE
-- Lets create a number series from 1 to 10
WITH num AS
(
	SELECT * FROM generate_series(1,10) AS id
)
SELECT * FROM num;

-- List all movies by director_id = 1
WITH cte_director_2 AS
(
	SELECT * FROM movies mv
	INNER JOIN directors d ON d.director_id = mv.director_id
	WHERE d.director_id=1
)
SELECT * FROM cte_director_2

-- Lets view all long movies where long movies are 120 hrs and more
WITH cte_long_movies AS
(
	SELECT
		movie_name,
		movie_length,
		(
		CASE 
			WHEN movie_length < 100 THEN 'SHORT'
			WHEN movie_length < 120 THEN 'MEDIUM'
			ELSE 'LONG'
		END
		) As m_length
	FROM movies
)
SELECT * FROM cte_long_movies
WHERE
	m_length = 'LONG';

-- Combine CTE with a table
-- Lets calculate total revenues for each directors
WITH cte_movie_count AS
(
	SELECT
		d.director_id,
		SUM(r.revenues_domestic + r.revenues_international) AS total_revenues
	FROM directors d
	INNER JOIN movies mv on mv.director_id = d.director_id
	INNER JOIN movies_revenues r ON r.movie_id = mv. movie_id
	GROUP BY d.director_id
)
SELECT 
	d.director_id,
	d.first_name,
	d.last_name,
	cte.total_revenues
FROM cte_movie_count cte
INNER JOIN directors d ON d.director_id = cte.director_id;

-- Simultaneous DELETE, INSERT via CTE
CREATE TABLE articles(
	article_id SERIAL PRIMARY KEY,
	title VARCHAR(100)
);
-- delete_articles table
CREATE TABLE articles_delete AS SELECT * FROM articles limit 0;

-- Lsets insert soe data in articles
INSERT INTO articles (title) VALUES
('ARTILCE1'),
('ARTILCE2'),
('ARTILCE3'),
('ARTILCE4');

SELECT * FROM articles;
SELECT * FROM articles_delete;

-- Lets create our CTEs
WITH cte_delete_articles AS
(
	DELETE FROM articles
	WHERE article_id = 1
	RETURNING *
)
INSERT INTO articles_delete
SELECT * FROM cte_delete_articles;
-- same for insert


-- Recursive CTEs
-- CTEs that calls itself until a condition is met
-- can be used to work with hierarchical data

-- Creating a time series with recursive CTEs
WITH RECURSIVE series (list_num) AS
(
	-- non recursive statement
		SELECT 10
	UNION ALL
		SELECT list_num + 5 FROM series
		WHERE list_num + 5 <= 50
	-- recursive statemnt
	
)
SELECT * from series;









