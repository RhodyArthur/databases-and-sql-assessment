-- ============================================
-- PHASE 3 ASSESSMENT - SECTIONS 3-4
-- SELECT Queries & Advanced SQL
-- ============================================

-- ============================================
-- SECTION 3: SELECT Statements
-- ============================================

-- Task 3.1: Basic Queries
-- Get all books with their titles and prices
SELECT title, price
FROM books


-- Get all members who joined in the last 6 months
SELECT *
FROM members
WHERE join_date >= CURRENT_DATE - INTERVAL '6 months'


-- Get all books where available_copies > 0, ordered by title
SELECT *
FROM books
WHERE available_copies > 0
ORDER BY title


-- Get unique genres from the books table
SELECT DISTINCT genre
FROM books


-- Get the top 5 most expensive books
SELECT title, price
FROM books
ORDER BY price desc 
LIMIT 5


-- Task 3.2: WHERE Clause and Filtering
-- Get all books published between 2010 and 2020
SELECT *
FROM books
WHERE publication_year BETWEEN 2010 AND 2020


-- Get all members with 'gmail.com' email addresses
SELECT *
FROM members
WHERE email LIKE '%@gmail.com'


-- Get all books that cost between $10 and $30
SELECT *
FROM books
WHERE price BETWEEN 10 AND 30


-- Get all borrowings that are currently overdue (status='overdue' OR due_date < current_date)
SELECT *
FROM borrowings
WHERE status = 'overdue' OR due_date < CURRENT_DATE


-- Get all books whose title contains the word 'Python' (case-insensitive)
-- Your SQL here
SELECT *
FROM books
WHERE title ILIKE '%python%'



-- Task 3.3: JOINs
-- INNER JOIN: Get all books with their author names
SELECT b.title, a.name
FROM books b
INNER JOIN authors a
ON b.author_id = a.id


-- LEFT JOIN: Get all authors and count of their books (include authors with 0 books)
SELECT a.name, COUNT(b.author_id)
FROM authors a
LEFT JOIN books b
ON a.id = b.author_id
GROUP BY a.name


-- Get all borrowings with member name and book title
SELECT b.title, m.first_name || ' ' || m.last_name AS member_name
FROM borrowings br
JOIN members m ON br.member_id = m.id
JOIN books b ON br.book_id = b.id


-- Get all members who have never borrowed a book (use LEFT JOIN and WHERE)
SELECT m.*
FROM members m
LEFT JOIN borrowings br
ON m.id = br.member_id
WHERE br.id IS NULL;


-- Get books with their authors and genres (multiple joins)
SELECT 
    b.title,
    a.name AS author,
    g.name AS genre
FROM books b
JOIN authors a 
    ON b.author_id = a.id
JOIN book_genres bg 
    ON b.id = bg.book_id
JOIN genres g 
    ON bg.genre_id = g.id;


-- Task 3.4: Aggregations and GROUP BY
-- Count total number of books in the library
SELECT COUNT(*) AS total_books
FROM books;

-- Get average price of books by genre
SELECT genre, AVG(price) AS avg_price
FROM books
GROUP BY genre;


-- Get total fine amount collected from each member
SELECT m.first_name || ' ' || m.last_name AS member_name, SUM(b.fine_amount) as total_fine_amount
FROM borrowings b
JOIN members m
ON b.member_id = m.id
GROUP BY m.first_name, m.last_name;


-- Count how many books each author has written, ordered by count DESC
SELECT a.name, COUNT(b.id) as book_count
FROM authors a
LEFT JOIN books b
ON a.id = b.author_id
GROUP BY a.id
ORDER BY book_count DESC;


-- Get the most borrowed book (book with most borrowing records)
SELECT b.title, COUNT(br.book_id) as book_count
FROM borrowings br
JOIN books b
ON br.book_id = b.id
WHERE br.status = 'borrowed'
GROUP BY b.id
ORDER BY book_count DESC
LIMIT 1;


-- ============================================
-- SECTION 4: Advanced SQL
-- ============================================

-- Task 4.1: Subqueries
-- Get all books that are more expensive than the average book price
SELECT *
FROM books
WHERE price > (
    SELECT AVG(price)
    FROM books
);


-- Get members who have borrowed books by a specific author (use subquery)
SELECT *
FROM members
WHERE id IN (
    SELECT br.member_id
    FROM borrowings br
    JOIN books b ON br.book_id = b.id
    JOIN authors a ON b.author_id = a.id
    WHERE a.name = 'Haruki Murakami'
);


-- Get authors whose books have been borrowed at least once (use EXISTS)
SELECT *
FROM authors a
WHERE EXISTS (
    SELECT 1
    FROM books b
    JOIN borrowings br ON br.book_id = b.id
    WHERE b.author_id = a.id
    AND br.status = 'borrowed'
);


-- Find books that have never been borrowed (use NOT IN or NOT EXISTS)
SELECT *
FROM books b
WHERE NOT EXISTS (
    SELECT 1
    FROM borrowings br
    WHERE br.book_id = b.id
);


-- Task 4.2: Complex Queries with HAVING
-- Get authors who have written more than 2 books
SELECT a.name, COUNT(b.id) as total_books
FROM authors a
JOIN books b
ON a.id = b.author_id
GROUP BY a.id, a.name
HAVING total_books > 2;


-- Get members who have total fines greater than $20
SELECT  m.first_name || ' ' || m.last_name AS member_name, SUM(br.fine_amount) AS total_fines
FROM members m
JOIN borrowings br
ON m.id = br.member_id
GROUP BY m.id, m.first_name, m.last_name
HAVING SUM(br.fine_amount) > 20;

-- Get books that have been borrowed more than 3 times
SELECT b.title, COUNT(br.id) AS cnt 
FROM books b
JOIN borrowings br
ON b.id = br.book_id
WHERE br.status = 'borrowed'
GROUP BY b.id, b.title
HAVING COUNT(br.id) > 3;


-- Task 4.3: Window Functions (Optional)
-- Rank books by price within each genre
SELECT title, price, genre
RANK() OVER (
    PARTITION BY genre
    ORDER BY price DESC
) AS price_rank;
FROM books


-- Get running total of fine amounts by member
SELECT
    member_id,
    fine_amount,
    SUM(fine_amount) OVER (
        PARTITION BY member_id
        ORDER BY borrow_date
    ) AS running_total
FROM borrowings;


-- Task 4.4: Transactions
--Write a transaction that:
--Creates a new borrowing
--Decreases available_copies for the book
--Rolls back if available_copies would become negative

BEGIN;

UPDATE books
SET available_copies = available_copies - 1
WHERE id = 2
AND available_copies > 0;

INSERT INTO borrowings (member_id, book_id, borrow_date, due_date, status)
VALUES (1, 2, CURRENT_DATE, CURRENT_DATE + INTERVAL '14 days', 'borrowed');

COMMIT;