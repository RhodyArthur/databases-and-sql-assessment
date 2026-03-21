"""
PHASE 3 ASSESSMENT - SECTION 7
Python with psycopg2
"""

import psycopg2
from psycopg2 import pool
from dotenv import load_dotenv
import os
from datetime import datetime

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


def execute_query(query, params=None):
    """
    Execute a query and return results
    """
    pass


# ============================================
# TASK 7.2: CRUD Operations
# ============================================

class BookRepository:
    """Repository pattern for Book operations"""
    
    def __init__(self, connection):
        self.conn = connection
    
    # Your methods here


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