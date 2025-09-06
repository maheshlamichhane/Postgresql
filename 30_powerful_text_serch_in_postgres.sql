-- The Good Old Text search
-- A full-text serach refers to techniques for searching a single computer-stored doucment or a collection in a full text database
SELECT * FROM movies WHERE movie_name LIKE '%Star%';

-- Introducing 'tsvector'
-- postgres comes with a powerful full text search engine that give us more option when earching for information in large amount of textr
-- tsvector,tsquery
SELECT to_tsvector('washes');
SELECT to_tsvector('washed');
SELECT to_tsvector('washing');
SELECT to_tsvector('The quick brown fox jumbed over the lazy dog.');

-- Using tsquery with operators
SELECT to_tsvector('This is a test');
SELECT to_tsvector('This is a');
SELECT to_tsvector('This is an amazing story');
SELECT to_tsvector('PostgreSQL tsvector text search is very powerful');
SELECT to_tsvector('Walking & sitting');

SELECT to_tsvector('This is a lamp') @@ to_tsquery('lamp');
SELECT to_tsvector('The quick brown fox jumped over the lazy dog') 
@@ to_tsquery('foxes');

-- Full text search within a table
CREATE TABLE docs(
	doc_id SERIAL PRIMARY KEY,
	doc_text TEXT,
	doc_text_search TSVECTOR
);
INSERT INTO docs(doc_text) VALUES
('The five boxing wizards jump quickly.'),
('Pack my box with five dozens pepsi jugs.'),
('How vexingly quick daft zebras jump!'),
('Jackdaws love my big sphinx of quartz'),
('Sphinx of black quartz, judge my vow.'),
('Bright viens jump; dozy fowl quack.');

SELECT * FROM docs;

UPDATE docs
SET doc_text_search = to_tsvector(doc_text);

SELECT * FROM docs;
SELECT 
	doc_id,
	doc_text
FROM docs
WHERE doc_text_search @@ to_tsquery('jump');
SELECT 
	doc_id,
	doc_text
FROM docs
WHERE doc_text_search @@ to_tsquery('jump & quick');

SELECT 
	doc_id,
	doc_text
FROM docs
WHERE doc_text_search @@ to_tsquery('jump <-> quick');

SELECT 
	doc_id,
	doc_text
FROM docs
WHERE doc_text_search @@ to_tsquery('sphinx <2> quartz');

-- Ranking query matches
-- ts rank

SELECT 
	doc_id,
	doc_text,
	ts_rank(
		doc_text_search,
		to_tsquery('jump <-> quick')
	) as score
FROM docs
WHERE doc_text_search @@ to_tsquery('jump <-> quick');



