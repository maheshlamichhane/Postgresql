-- Type conversion Implicit,Explicit via CAST
-- No conversion
SELECT * FROM movies WHERE movie_id=1;

-- Automatic conversion
SELECT * FROM movies WHERE movie_id='1';

-- Explicit conversion
SELECT * FROM movies WHERE movie_id= integer '1';

-- Using CAST for data conversion
CAST(expression AS target_data_type);

-- String to integer converison
SELECT CAST('10' AS INTEGER);

-- String to date confersion
SELECT CAST('2020-01-01' AS DATE),CAST('01-MAY-2020' AS DATE);

-- String to Boolean
SELECT CAST('true' AS BOOLEAN), CAST('false' as BOOLEAN),
CAST('T' as BOOLEAN),CAST('F' as BOOLEAN);
SELECT CAST('0' AS BOOLEAN), CAST('1' as BOOLEAN),
CAST('yes' as BOOLEAN),CAST('no' as BOOLEAN);

-- String to double
SELECT CAST('14.7888' AS DOUBLE PRECISION);

-- We can also do like this
SELECT '10'::INTEGER,
	   '2020-01-01'::DATE;

-- String to timestamp
SELECT '2020-02-20 10:30:25.467'::TIMESTAMP;

-- With timezone
SELECT '2020-02-20 10:30:25.467'::TIMESTAMPTZ;

-- String to Interval
SELECT
	'10 minute'::interval,
	'4 hour'::interval,
	'1 day'::interval,
	'2 week'::interval,
	'5 month'::interval;


-- Implicit to explicit conversions
-- Round with numeric
SELECT ROUND(10,4) AS "result";
SELECT ROUND(CAST (10 AS NUMERIC),4) AS "result";

-- CAST with text
SELECT SUBSTR('123456',2) AS "result";
SELECT
	SUBSTR('123456',2) AS "Implicit",
	SUBSTR(CAST('123456' AS TEXT),2) AS "Explicit";

-- Table data conversion
-- Lets create a table called 'ratings' with initial data as charters
CREATE TABLE ratings(
	rating_id SERIAL PRIMARY KEY,
	rating VARCHAR(1) NOT NULL
);
INSERT INTO ratings (rating) VALUES
('A'),
('B'),
('C'),
('D');
INSERT INTO ratings (rating) VALUES
(1),
(2),
(3),
(4);

-- now we will use CAST to change all non-numeric data to integer
SELECT
	rating_id,
	CASE
		WHEN rating~E'^\\d+$' THEN
			CAST (rating AS INTEGER)
		ELSE
			0
		END as rating
FROM
	ratings;
SELECT * FROM ratings;













