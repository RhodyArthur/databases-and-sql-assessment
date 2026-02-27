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
INSERT INTO authors (name, country, birth_year)
VALUES
    ('Chinua Achebe', 'Nigeria', 1930),
    ('Isabel Allende', 'Chile', 1942),
    ('Margaret Atwood', 'Canada', 1939),
    ('Jorge Luis Borges', 'Argentina', 1899),
    ('Haruki Murakami', 'Japan', 1949);


-- Insert at least 10 books (make sure they reference valid authors)
INSERT INTO books (title,isbn,author_id,publication_year,genre,price, available_copies)
VALUES
    ('Things Fall Apart', '9780385474542', 1, 1958, 'Fiction', 12.99, 5),
    ('No Longer at Ease', '9780385474559', 1, 1960, 'Fiction', 11.99, 4),
    ('The House of the Spirits', '9780553383805', 2, 1982, 'Magical Realism', 14.50, 6),
    ('City of the Beasts', '9780060535031', 2, 2002, 'Adventure', 13.75, 3),
    ('The Handmaid''s Tale', '9780385490818', 3, 1985, 'Dystopian', 15.00, 7),
    ('Oryx and Crake', '9780385721677', 3, 2003, 'Science Fiction', 16.25, 4),
    ('Ficciones', '9780802130303', 4, 1944, 'Short Stories', 10.99, 5),
    ('Labyrinths', '9780811216999', 4, 1962, 'Philosophical Fiction', 12.50, 2),
    ('Norwegian Wood', '9780375704024', 5, 1987, 'Romance', 14.20, 8),
    ('Kafka on the Shore', '9781400079278', 5, 2002, 'Magical Realism', 17.00, 6);


-- Insert at least 8 members
INSERT INTO members (first_name, last_name, email, phone, membership_type)
VALUES
    ('Ama', 'Mensah', 'ama.mensah@email.com', '0201234567', 'basic'),
    ('Kofi', 'Owusu', 'kofi.owusu@email.com', '0242345678', 'premium'),
    ('Akosua', 'Boateng', 'akosua.boateng@email.com', '0553456789', 'gold'),
    ('Yaw', 'Asare', 'yaw.asare@email.com', '0274567890', 'basic'),
    ('Efua', 'Adjei', 'efua.adjei@email.com', '0265678901', 'premium'),
    ('Kojo', 'Bediako', 'kojo.bediako@email.com', '0546789012', 'gold'),
    ('Abena', 'Frimpong', 'abena.frimpong@email.com', '0507890123', 'basic'),
    ('Kwame', 'Darko', 'kwame.darko@email.com', '0238901234', 'premium');


-- Insert at least 5 borrowing records
INSERT INTO borrowings (member_id, book_id, borrow_date, due_date, status, fine_amount)
VALUES
    (1, 1, CURRENT_DATE, CURRENT_DATE + INTERVAL '14 days', 'borrowed', 0),
    (2, 5, CURRENT_DATE - INTERVAL '10 days', CURRENT_DATE + INTERVAL '4 days', 'borrowed', 0),
    (3, 3, CURRENT_DATE - INTERVAL '20 days', CURRENT_DATE - INTERVAL '5 days', 'overdue', 5.00),
    (4, 7, CURRENT_DATE - INTERVAL '15 days', CURRENT_DATE - INTERVAL '1 day', 'returned', 0),
    (5, 10, CURRENT_DATE, CURRENT_DATE + INTERVAL '14 days', 'borrowed', 0);



-- Task 2.2: UPDATE Operations
-- Update the price of all books published before 2000 by increasing it by 10%
UPDATE books SET price = 1.10 * price WHERE publication_year < 2000;


-- Mark all borrowings as 'overdue' where due_date has passed and status is 'borrowed'
UPDATE borrowings SET status = 'overdue' WHERE due_date < CURRENT_DATE AND status = 'borrowed';


-- Update available_copies for a specific book (decrease by 1) when borrowed
UPDATE books SET available_copies = available_copies - 1 WHERE id IN (
    SELECT book_id
    FROM borrowings
    WHERE status = 'borrowed'
);


-- Change membership_type to 'gold' for members who have borrowed more than 5 books
UPDATE members SET membership_type = 'gold' WHERE id IN (
    SELECT member_id
    FROM borrowings
    GROUPBY member_id
    HAVING COUNT(*) > 5
);


-- Task 2.3: DELETE Operations
-- Delete all borrowing records that were returned more than 2 years ago
DELETE FROM borrowings 
WHERE return_date IS NOT NULL AND 
return_date < CURRENT_DATE - INTERVAL '2 years';


-- Delete members who have never borrowed any books
DELETE FROM members 
WHERE NOT EXISTS
(SELECT 1
FROM borrowings 
WHERE borrowings.member_id = members.id);


-- Delete books that have 0 available copies and have never been borrowed
DELETE FROM books 
WHERE available_copies = 0 AND 
NOT EXISTS (SELECT 1 FROM borrowings WHERE borrowings.book_id = books.id);




-- Task 2.4: Complex INSERT
-- Insert a new borrowing and automatically update available_copies in books table
-- Use a transaction to ensure both operations succeed or both fail
BEGIN;
UPDATE books SET available_copies = available_copies - 1 WHERE id = 2 AND available_copies > 0;

INSERT INTO borrowings (member_id, book_id, borrow_date, due_date, status)
VALUES (6, 2, CURRENT_DATE, CURRENT_DATE + INTERVAL '14 days', 'borrowed');
COMMIT;


-- Insert multiple records using a single INSERT statement with VALUES
-- Insert 3 genres at once
INSERT INTO genres (name)
VALUES
('Fantasy'),
('Biography'),
('Historical Fiction');


-- Insert data from a SELECT query (copy all 'premium' members to a new table)
-- First create the table, then insert
CREATE TABLE premium_members AS 
SELECT *
FROM members
WHERE membership_type = 'premium';