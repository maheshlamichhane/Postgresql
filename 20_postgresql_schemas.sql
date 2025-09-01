-- A schema is a namespace that contains named db objects like table view function indees operators etc.
-- Schema Operations
-- CREATE schema
CREATE SCHEMA sales;

-- Rename schema
ALTER SCHEMA sales RENAME TO programming;

-- Drop schema
DROP SCHEMA programming;

-- Schema Hierarchy host -> cluster -> database -> schema -> object hr.public.emp
-- Select a table from a 'public' schema
SELECT * FROM hr.public.employees;

-- Select a table other than 'public' schema
SELECT * FROM hr.humanresources.employees;

-- Move a table to a new schema
ALTER TABLE humanresources.orders SET SCHEMA public;

-- Schema search path
-- schema search path is a list of schemas that is used to look for object
-- How t view the current schema??
SELECT current_schema();

-- How to view current search path?
SHOW search_path;

-- How to add new schema to search path
SET search_path TO '$user',humanresources, public;

-- Schema Ownerships
ALTER SCHEMA humanresources OWNER TO adam;

-- Duplicate a schema with all data
CREATE DATABASE test_schema;
CREATE TABLE test_schema.public.songs(
	song_id SERIAL PRIMARY KEY,
	song_title VARCHAR(100)
);
INSERT INTO test_schema.public.songs (song_title) VALUES
('Counting Star'),
('Rolling On');

select * from songs;

-- System catalog schema -> pg_catalog schema
-- Schema and privilages
-- Users can only access objects in the schemas that they own.
-- Two schema access level rights
-- * USAGE -> To access schema
-- * CREATE -> To create objects like tables etc in table
GRANT USAGE ON SCHEMA private TO adam;
GRANT SELECT ON ALL TABLES IN SCHEMA private TO adam;
GRANT CREATE ON SCHEMA private TO adam;












