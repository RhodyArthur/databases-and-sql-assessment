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
WHERE b.author_id = a.id


-- LEFT JOIN: Get all authors and count of their books (include authors with 0 books)
SELECT a.name, COUNT(b.author_id)
FROM authors a
LEFT JOIN books b
WHERE a.id = b.author_id
GROUP BY a.author_id


-- Get all borrowings with member name and book title
-- Your SQL here


-- Get all members who have never borrowed a book (use LEFT JOIN and WHERE)
-- Your SQL here


-- Get books with their authors and genres (multiple joins)
-- Your SQL here




-- Task 3.4: Aggregations and GROUP BY
-- Your code here




-- ============================================
-- SECTION 4: Advanced SQL
-- ============================================

-- Task 4.1: Subqueries
-- Your code here




-- Task 4.2: Complex Queries with HAVING
-- Your code here




-- Task 4.3: Window Functions (Optional)
-- Your code here




-- Task 4.4: Transactions
-- Your code here