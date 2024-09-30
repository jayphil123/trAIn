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
    # Connect to the specific database
    connection = psycopg2.connect(
        host=host, 
        port=port, 
        user=user, 
        password=password, 
        dbname=database_name
    )
    
    # Create a cursor object
    cursor = connection.cursor()

    # SQL command to create a new table
    create_table_query = '''
    CREATE TABLE IF NOT EXISTS users (
        id SERIAL PRIMARY KEY,
        username VARCHAR(50) NOT NULL,
        email VARCHAR(100) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
    '''

    # Execute the create table command
    cursor.execute(create_table_query)

    # Prepare the INSERT command
    insert_query = '''INSERT INTO users (username, email) VALUES (%s, %s);'''
    # Values to be inserted
    values = ('your_username', 'your_email@example.com')  # replace with actual values

    # Execute the INSERT command
    cursor.execute(insert_query, values)

    # Execute the SELECT query
    cursor.execute("SELECT * FROM users;")

    # Fetch all rows
    rows = cursor.fetchall()

    # Print the results
    for row in rows:
        print(row)

    print("Table 'users' created successfully and data inserted.")

    # Commit the changes
    connection.commit()
    
except psycopg2.Error as e:
    print(f"Error: {e}")
finally:
    # Ensure the cursor and connection are closed properly
    if cursor:
        cursor.close()  # Close the cursor first
    if connection:
        connection.close()  # Then close the connection
