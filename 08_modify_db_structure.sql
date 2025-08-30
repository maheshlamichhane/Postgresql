-- Create table
CREATE TABLE persons(
	person_id SERIAL PRIMARY KEY,
	first_name VARCHAR(20) NOT NULL,
	last_name VARCHAR(20) NOT NULL
);

-- Add new column
ALTER TABLE persons ADD COLUMN age INT NOT NULL;
ALTER TABLE persons ADD COLUMN nationality VARCHAR(20) NOT NULL;

-- Rename a table
ALTER TABLE users RENAME TO persons;

-- Rename column
ALTER TABLE persons RENAME COLUMN age TO person_age;

-- Drop column
ALTER TABLE persons DROP COLUMN person_age;

-- Add new column
ALTER TABLE persons ADD COLUMN age VARCHAR(10);

-- Modify column
ALTER TABLE persons ALTER COLUMN age TYPE int USING age::integer;
ALTER TABLE persons ALTER COLUMN age TYPE VARCHAR(20);

-- Set a default values of a column
ALTER TABLE persons ADD COLUMN is_enable VARCHAR(1);
ALTER TABLE persons ALTER COLUMN is_enable SET DEFAULT 'Y';


-- Add a constraint to a column
CREATE TABLE web_links(
	link_id SERIAL PRIMARY KEY,
	link_url VARCHAR(255) NOT NULL,
	link_target VARCHAR(20)
);
INSERT INTO web_links(link_url,link_target) 
VALUES ('https://www.google.com','_blank');

-- Add unique constraint
ALTER TABLE web_links ADD CONSTRAINT unique_web_url UNIQUE (link_url);

-- Add custom constraint
ALTER TABLE web_links ADD COLUMN is_enable VARCHAR(2);

INSERT INTO web_links (link_url,link_target,is_enable) 
VALUES ('https://www.he.com','_blank','Y');

ALTER TABLE web_links ADD CHECK (is_enable IN ('Y','N'));

SELECT * from web_links;






