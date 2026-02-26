import psycopg2
from dotenv import load_dotenv
import os

# Load environment variables
load_dotenv()

def test_connection():
    try:
        # Connect to database
        conn = psycopg2.connect(
            host=os.getenv('DB_HOST'),
            port=os.getenv('DB_PORT'),
            database=os.getenv('DB_NAME'),
            user=os.getenv('DB_USER'),
            password=os.getenv('DB_PASSWORD')
        )
        
        print("✅ Database connection successful!")
        
        # Test query
        cur = conn.cursor()
        cur.execute("SELECT version();")
        version = cur.fetchone()
        if version is not None:
            print(f"PostgreSQL version: {version[0]}")
        else:
            print("Could not retrieve PostgreSQL version.")
        
        # Close connections
        cur.close()
        conn.close()
        
        return True
        
    except psycopg2.Error as e:
        print(f"❌ Database connection failed: {e}")
        return False

if __name__ == "__main__":
    test_connection()