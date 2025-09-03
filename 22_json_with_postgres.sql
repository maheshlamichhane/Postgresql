-- Exploring JSONB objects
CREATE TABLE books (
	book_id SERIAL PRIMARY KEY,
	book_info JSONB
);
INSERT INTO books (book_info) VALUES
('
{
	"title": "Book ttile3",
	"author": "author3"
}
'),
('
{
	"title": "Book ttile2",99999999999999999999999
	"author": "author2"
}
');

SELECT book_info FROM books;
SELECT book_info -> 'title' FROM books;
SELECT
	book_info ->> 'title' AS "title",
	book_info ->> 'author' AS author
FROM books;
SELECT
	book_info ->> 'title' AS "title",
	book_info ->> 'author' AS author
FROM books
WHERE book_info ->> 'author' = 'author1';

-- Update JSON data
SELECT * FROM books;
INSERT INTO books (book_info) VALUES
('
{
	"title": "Book title10",
	"author": "author10"
}
');

UPDATE books
SET book_info = jsonb_set(book_info, '{title}', '"hello"', false)
WHERE book_info ->> 'author' = 'author10'
RETURNING *;

 -- Create JSON from table
 SELECT row_to_json(directors) FROM directors;
 SELECT row_to_json(t) FROM 
(SELECT 
 	director_id,
	 first_name,
	 last_name,
	 nationality
FROM directors
) AS t;

-- Use json_agg() to aggregate data
SELECT * FROM movies;
SELECT 
director_id,
first_name,
last_name,
(
	SELECT json_agg(x) as all_movies FROM
	(
		SELECT movie_name FROM movies WHERE director_id= directors.director_id
	) as x
)
FROM directors;

-- Build a JSON array
select json_build_array(1,2,3,4,5,6,'Hi');
select json_build_object(2,3,4,5,6,'Hi');
select json_build_object ('first_name','mahesh');
SELECT json_object('{name,email}','{"adnan","a@b.com"}');

-- Create documents from data
CREATE TABLE directors_docs(
	id SERIAL PRIMARY KEY,
	body JSONB
);
INSERT INTO directors_docs (body) 
SELECT row_to_json(a)::jsonb FROM
(
SELECT 
	director_id,
	first_name,
	last_name,
	date_of_birth,
	nationality,
	(
		SELECT json_agg(x) as all_movies FROM
		(
			SELECT movie_name FROM movies 
			WHERE director_id = directors.director_id
		) x
	)
FROM directors
) as a;

SELECT * FROM directors_docs;

-- Null values in JSON document
SELECT jsonb_array_elements(body -> 'all movies') FROM directors_docs;


-- Getting information from JSON documents
SELECT
	*,
	jsonb_array_length(body -> 'all_movies') as total_movies
FROM directors_docs;

-- The Existence Operator ?
SELECT
* 
FROM directors_docs
WHERE body -> 'first_name' ? 'John';

-- The containment operator
SELECT
* 
FROM directors_docs
WHERE body @> '{"first_name":"John"}';

-- Mix and Match JSON search
SELECT 
*
FROM directors_docs
WHERE body ->> 'first_name' LIKE 'J%';

SELECT
*
FROM directors_docs
WHERE (body ->> 'director_id')::integer > 2;

SELECT
*
FROM directors_docs
WHERE (body ->> 'director_id')::integer IN (1,2,3);

-- Indeing on JSONB
















