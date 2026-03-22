"""
PHASE 3 ASSESSMENT - SECTION 7
Python with psycopg2
"""

import psycopg2
from psycopg2 import pool
from dotenv import load_dotenv
import os
from datetime import datetime
from psycopg2.extras import RealDictCursor

# Load environment variables
load_dotenv()

# Database connection parameters
DB_CONFIG = {
    'host': os.getenv('DB_HOST'),
    'port': os.getenv('DB_PORT'),
    'database': os.getenv('DB_NAME'),
    'user': os.getenv('DB_USER'),
    'password': os.getenv('DB_PASSWORD')
}


# ============================================
# TASK 7.1: Basic Database Connection
# ============================================

def create_connection():
    """
    Create and return a database connection
    """
    conn = psycopg2.connect(
        dbname=DB_CONFIG['database'],
        user=DB_CONFIG['user'],
        password=DB_CONFIG['password'],
        host=DB_CONFIG['host'],
        port=DB_CONFIG['port']
    )
    return conn


def execute_query(query, params=None, fetch=False):
    """
    Execute a query and return results
    """
    with create_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(query, params)
        if fetch:
            return cur.fetchall()



# ============================================
# TASK 7.2: CRUD Operations
# ============================================

class BookRepository:
    """Repository pattern for Book operations"""
    
    def __init__(self, connection):
        self.conn = connection
        self.cur = self.conn.cursor(cursor_factory=RealDictCursor)
    
    def create_book(self, title, isbn, author_id, publication_year, price):
        """
        Insert a new book
        Return the created book's ID
        """
        # cur = self.conn.cursor()
        self.cur.execute(
            """INSERT INTO books (title, isbn, author_id, publication_year, price) 
               VALUES (%s, %s, %s, %s, %s)
               RETURNING id;""",
            (title, isbn, author_id, publication_year, price))
        book_id = self.cur.fetchone()['id']
        self.conn.commit()
        return book_id
    
    def get_book_by_id(self, book_id):
        """
        Get a book by ID
        Return dict with book data or None
        """
        self.cur.execute(
            "SELECT * FROM books WHERE id = %s;",
            (book_id,)
        )
        return self.cur.fetchone()
    
    def get_all_books(self, limit=10, offset=0):
        """
        Get all books with pagination
        Return list of dicts
        """
        self.cur.execute(
            "SELECT * FROM books ORDER BY id LIMIT %s OFFSET %s;",
            (limit, offset)
        )
        return self.cur.fetchall()
    
    def update_book_price(self, book_id, new_price):
        """
        Update book price
        Return True if successful
        """
        self.cur.execute(
            """UPDATE books 
            SET price = %s 
            WHERE id = %s;
            """,
            (new_price, book_id)
        )
        self.conn.commit()
        return self.cur.rowcount > 0
    
    def delete_book(self, book_id):
        """
        Delete a book
        Return True if successful
        """
        pass
    
    def search_books(self, keyword):
        """
        Search books by title (case-insensitive)
        Return list of matching books
        """
        pass


# ============================================
# TASK 7.3: Transactions
# ============================================

def borrow_book(member_id, book_id):
    """Process book borrowing with transaction"""
    pass


def return_book(borrowing_id):
    """Process book return with transaction"""
    pass


# ============================================
# TASK 7.4: Connection Pooling
# ============================================

class DatabasePool:
    """Connection pooling implementation"""
    pass


# ============================================
# TEST YOUR CODE
# ============================================

if __name__ == "__main__":
    print("Testing psycopg2 operations...\n")
    
    # Test connection
    conn = create_connection()
    if conn:
        print("✅ Connection successful")
        conn.close()
    else:
        print("❌ Connection failed")