import psycopg2
from dotenv import load_dotenv
import os

# Load environment variables from .env file
load_dotenv()

# Connection parameters from environment variables
host = os.getenv("DB_HOST")
port = os.getenv("DB_PORT")
user = os.getenv("DB_USER")
password = os.getenv("DB_PASSWORD")
database_name = os.getenv("DB_NAME")

try:
    # Connect to the PostgreSQL server (without specifying a database)
    connection = psycopg2.connect(host=host, port=port, user=user, password=password)
    
    # Create a cursor object
    cursor = connection.cursor()

    # Commit any existing transactions (if any)
    connection.autocommit = True  # Enable autocommit mode

    # Execute the CREATE DATABASE command
    cursor.execute(f"CREATE DATABASE {database_name}")
    print(f"Database '{database_name}' created successfully.")
    
except psycopg2.Error as e:
    print(f"Error creating database: {e}")
finally:
    # Ensure the cursor and connection are closed properly
    if cursor:
        cursor.close()  # Close the cursor first
    if connection:
        connection.close()  # Then close the connection
