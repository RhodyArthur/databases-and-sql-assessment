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
CREATE TABLE IF NOT EXISTS authors (
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

CREATE TABLE IF NOT EXISTS books (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    isbn VARCHAR(13) UNIQUE,
    author_id INTEGER REFERENCES authors(id),
    publication_year INTEGER,
    genre VARCHAR(50),
    price DECIMAL(10, 2),
    available_copies INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- Create a 'members' table with:
-- - id (auto-incrementing primary key)
-- - first_name (varchar, not null, max 50 characters)
-- - last_name (varchar, not null, max 50 characters)
-- - email (varchar, unique, not null, max 100 characters)
-- - phone (varchar, max 20 characters)
-- - join_date (date, default current date)
-- - membership_type (varchar: 'basic', 'premium', 'gold')

CREATE TABLE IF NOT EXISTS members(
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    join_date DATE DEFAULT CURRENT_DATE,
    membership_type VARCHAR(20)
    CHECK (membership_type IN ('basic', 'premium', 'gold'))
);



-- Task 1.2: Alter Tables
-- Add a new column 'biography' (text) to the authors table
ALTER TABLE authors
ADD COLUMN biography TEXT;


-- Add a constraint to ensure publication_year is not less than 1000

ALTER TABLE books
ADD CONSTRAINT publication_year_check
CHECK (publication_year > 1000);


-- Create an index on books.isbn for faster lookups

CREATE INDEX idx_books_isbn
ON books(isbn);


-- Add a check constraint to ensure price is positive

ALTER TABLE books
ADD CONSTRAINT positive_price
CHECK (price > 0);




-- Task 1.3: Create Relationships
-- Create a 'borrowings' table with:
-- - id (primary key)
-- - member_id (foreign key to members.id, on delete cascade)
-- - book_id (foreign key to books.id, on delete cascade)
-- - borrow_date (date, not null, default current date)
-- - due_date (date, not null)
-- - return_date (date, nullable)
-- - status (varchar: 'borrowed', 'returned', 'overdue')
-- - fine_amount (decimal, default 0)

CREATE TABLE IF NOT EXISTS borrowings (
    id SERIAL PRIMARY KEY,
    member_id INTEGER REFERENCES members(id) ON DELETE CASCADE,
    book_id INTEGER REFERENCES books(id) ON DELETE CASCADE,
    borrow_date DATE NOT NULL DEFAULT CURRENT_DATE,
    due_date DATE NOT NULL,
    return_date DATE,
    status VARCHAR(20)
    CHECK (status IN ('borrowed', 'returned', 'overdue')),
    fine_amount DECIMAL(10,2) DEFAULT 0
);


-- Create a many-to-many relationship between books and genres
-- Create 'genres' table:
-- - id (primary key)
-- - name (varchar, unique, not null)

CREATE TABLE IF NOT EXISTS genres(
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL
);


-- Create 'book_genres' junction table:
-- - book_id (foreign key to books.id)
-- - genre_id (foreign key to genres.id)
-- - primary key (book_id, genre_id)

CREATE TABLE IF NOT EXISTS book_genres(
    book_id INTEGER REFERENCES books(id) ON DELETE CASCADE,
    genre_id INTEGER REFERENCES genres(id) ON DELETE CASCADE,
    PRIMARY KEY (book_id, genre_id)
);




-- ============================================
-- SECTION 2: DML (Data Manipulation Language)
-- ============================================

-- Task 2.1: INSERT Operations
-- Insert at least 5 authors
-- Your SQL here


-- Insert at least 10 books (make sure they reference valid authors)
-- Your SQL here


-- Insert at least 8 members
-- Your SQL here


-- Insert at least 5 borrowing records
-- Your SQL here




-- Task 2.2: UPDATE Operations
-- Your code here




-- Task 2.3: DELETE Operations
-- Your code here




-- Task 2.4: Complex INSERT
-- Your code here