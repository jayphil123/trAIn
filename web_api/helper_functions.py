import os
import psycopg2
import hashlib
from dotenv import load_dotenv

# Load enviornment variables
load_dotenv()
salt = os.getenv("SALT")

def get_cursor():
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
        return 1
    if check_existing_username(username):
        return 2
    

    # Create new user
    with get_cursor() as cur:
        new_pass = salt_and_hash_password(password)
        params = (username, new_pass)
        cur.execute("INSERT INTO users (username, password) VALUES (?, ?) ", params) # TODO table name?
        
    # Double Check it now exists
    if not check_existing_username(username):
        return 3
    if not check_existing_login(username, password):
        return 3
   
    
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

def check_valid_cookie(username: str, cookie: str):
    """Returns True if login exists and False if login does not exist."""
    
    # Connect with the database
    with get_cursor() as cur:  

        # Set up login format  
        params = (username, cookie)

        # Check if login exists
        cur.execute("SELECT * FROM users WHERE username = ? AND password = ? ", params) # TODO table name?
        results = len(cur.fetchall())

    # Return if user information found
    return results == 1

def get_workout_info(workouts: list[str]) -> dict:
    workout_info = {}
    with get_cursor() as cur:
        for workout in workouts:
            workout_info[workout] = {}
                
            sql_query = "SELECT * FROM workouts WHERE name = %s"
            cur.execute(sql_query, (workout,))

            results = cur.fetchall()
            if len(results) != 1:
                continue
            
            results = results[0]

            # Store the results in the dictionary
            info = {}
            info["id"] = results[0]
            info["force"] = results[2]
            info["level"] = results[3]
            info["mechanic"] = results[4]
            info["equipment"] = results[5]
            info["primary_muscles"] = results[6]
            info["secondary_muscles"] = results[7]
            info["instructions"] = results[8]
            info["category"] = results[9]
            info["images"] = results[10]
            info["id_str"] = results[11]
            workout_info[workout] = info
    return workout_info
