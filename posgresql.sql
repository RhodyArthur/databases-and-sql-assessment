-- ============================================
-- PHASE 3 ASSESSMENT - SECTIONS 6
-- PostgreSQL specific features
-- ============================================

-- Task 6.1: JSONB Data Type

-- Create a table with JSONB column for storing flexible metadata
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    metadata JSONB
);

-- Insert products with JSON metadata
INSERT INTO products(name, metadata)
VALUES ('Logitech Headphone', '{"price": 40, "color": "black", "noise_cancellation": "yes"}');

-- Query: Get all products where metadata contains a specific key-value
SELECT *
FROM products
WHERE metadata ->> 'color'= 'black'; 


-- Update: Add a new key to the JSONB column
UPDATE products
SET metadata = jsonb_set(
    metadata,
    '{rating}',
    '3.5'::jsonb
);


-- Task 6.2: Array Data Type
-- Create a table with an array column
CREATE TABLE articles (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200),
    tags TEXT[]
);

-- Insert articles with array of tags
INSERT INTO articles (title, tags)
VALUES ('Agentic Workflow', ARRAY['ai','mcp']),
 ('Basic SQL', ARRAY['sql','database']);


-- Query: Find articles that contain a specific tag
SELECT *
FROM articles
WHERE tags @> ARRAY['ai'];

-- Task 6.3: Ful text search

-- Add a tsvector column to books table for full-text search
ALTER TABLE books ADD COLUMN search_vector tsvector;


-- Perform a full-text search for books
SELECT *
FROM books
WHERE search_vector @@ to_tsquery('sql');

-- Task 6.4: Views

-- Create a view that shows all currently borrowed books with member details
CREATE VIEW currently_borrowed_books AS 
SELECT b.title, m.first_name,
    m.last_name, br.status
FROM borrowings br 
JOIN books b ON br.book_id = b.id
JOIN members m ON br.member_id = m.id
WHERE br.status = 'borrowed'


-- Query the view
SELECT *
FROM currently_borrowed_books
WHERE title = 'I am not a cat'