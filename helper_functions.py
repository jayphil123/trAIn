import os
import psycopg2
import hashlib
from typing import cursor
from dotenv import load_dotenv

# Load enviornment variables
load_dotenv()
salt = os.getenv("SALT")

def get_cursor() -> cursor:
    """Returns cursor object."""    

    # Get enviornment variable values
    host = os.getenv("DB_HOST")
    port = os.getenv("DB_PORT")
    user = os.getenv("DB_USER")
    password = os.getenv("DB_PASSWORD")
    database_name = os.getenv("DB_NAME")
    
    # Connects to database
    connection = psycopg2.connect(
        host=host,
        port=port,
        user=user,
        password=password,
        dbname=database_name
    )
    cur = connection.cursor()
    return cur

def salt_and_hash_password(password: str):
    """Returns a hashed and salted password."""
    algorithm = 'sha512'
    hash_obj = hashlib.new(algorithm)

    salted_password = salt + password
    hash_obj.update(salted_password.encode('utf-8'))
    hashed_password = hash_obj.hexdigest()

    return hashed_password


def create_new_login(username: str, password: str):
    
    # Simple validation
    if check_existing_login(username, password):
        return False
    if check_existing_username(username):
        return False

    # Create new user
    with get_cursor() as cur: 
        new_pass = salt_and_hash_password(password)
        params = (username, new_pass)
        cur.execute("INSERT INTO users (username, password) VALUES (?, ?) ", params) # TODO table name?
        
    # Double Check it now exists
    if not check_existing_login(username, password):
        return False
    if not check_existing_username(username):
        return False
    
    return True

def check_existing_login(username: str, password: str):
    """Returns True if login exists and False if login does not exist."""
    
    # Connect with the database
    with get_cursor() as cur:  

        # Set up login format  
        new_pass = salt_and_hash_password(password)
        params = (username, new_pass)

        # Check if login exists
        cur.execute("SELECT * FROM users WHERE username = ? AND password = ? ", params) # TODO table name?
        results = len(cur.fetchall())

    # Return if user information found
    return results == 1

def check_existing_username(username: str):
    """Returns True if username exists and False if username does not exist."""
    
    # Connect with the database
    with get_cursor() as cur:  

        # Set up username params  
        params = (username,)

        # Check if login exists
        cur.execute("SELECT * FROM users WHERE username = ?", params) # TODO table name?
        results = len(cur.fetchall())

    # Return if user information found
    return results == 1