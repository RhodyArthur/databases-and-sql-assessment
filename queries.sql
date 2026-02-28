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
WHERE join_date < CURRENT_DATE - INTERVAL '6 months'


-- Get all books where available_copies > 0, ordered by title
SELECT *
FROM books
WHERE available_copies > 0
ORDER BY title


-- Get unique genres from the books table
SELECT UNIQUE genre
FROM books


-- Get the top 5 most expensive books
SELECT price
FROM books
ORDER BY price desc 
LIMIT 5




-- Task 3.2: WHERE Clause and Filtering
-- Your code here




-- Task 3.3: JOINs
-- Your code here




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