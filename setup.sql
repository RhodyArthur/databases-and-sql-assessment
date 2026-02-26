-- ============================================
-- PHASE 3 ASSESSMENT - SECTIONS 1-2
-- DDL & DML Operations
-- ============================================

-- Connect to database (if running from command line)
-- \c library_assessment

-- ============================================
-- SECTION 1: DDL (Data Definition Language)
-- ============================================

-- Task 1.1: Create Tables
-- Create a 'authors' table with:
-- - id (auto-incrementing primary key)
-- - name (varchar, not null, max 100 characters)
-- - country (varchar, max 50 characters)
-- - birth_year (integer)
-- - created_at (timestamp with default current timestamp)
CREATE TABLE authors (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    country VARCHAR(50),
    birth_year INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- Create a 'books' table with:
-- - id (auto-incrementing primary key)
-- - title (varchar, not null, max 200 characters)
-- - isbn (varchar, unique, 13 characters)
-- - author_id (foreign key to authors.id)
-- - publication_year (integer)
-- - genre (varchar, max 50 characters)
-- - price (decimal with 2 decimal places)
-- - available_copies (integer, default 0)
-- - created_at (timestamp with default current timestamp)

-- Your SQL here


-- Create a 'members' table with:
-- - id (auto-incrementing primary key)
-- - first_name (varchar, not null, max 50 characters)
-- - last_name (varchar, not null, max 50 characters)
-- - email (varchar, unique, not null, max 100 characters)
-- - phone (varchar, max 20 characters)
-- - join_date (date, default current date)
-- - membership_type (varchar: 'basic', 'premium', 'gold')

-- Your SQL here



-- Task 1.2: Alter Tables
-- Your code here




-- Task 1.3: Create Relationships
-- Your code here




-- ============================================
-- SECTION 2: DML (Data Manipulation Language)
-- ============================================

-- Task 2.1: INSERT Operations
-- Your code here




-- Task 2.2: UPDATE Operations
-- Your code here




-- Task 2.3: DELETE Operations
-- Your code here




-- Task 2.4: Complex INSERT
-- Your code here