import psycopg2
from dotenv import load_dotenv
from langchain.embeddings import OpenAIEmbeddings
import os

# Load environment variables from .env file
load_dotenv()

# Connection parameters from environment variables
host = os.getenv("DB_HOST")
port = os.getenv("DB_PORT")
user = os.getenv("DB_USER")
password = os.getenv("DB_PASSWORD")
database_name = os.getenv("DB_NAME")
openai_key = os.getenv("OPENAI_API_KEY")

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
    CREATE TABLE IF NOT EXISTS embeddings (
        id SERIAL PRIMARY KEY,
        workout_name TEXT,
        embedding FLOAT8[] NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
    '''

    # Execute the create table command
    cursor.execute(create_table_query)

    select_table_query = "SELECT * FROM workouts"
    cursor.execute(select_table_query)
    workouts = cursor.fetchall()

    embeddings_model = OpenAIEmbeddings(
        openai_api_key=openai_key, model="text-embedding-3-small"
    )

    for i, workout in enumerate(workouts):
        workout_sentence = f"The {workout[1]} is an {workout[2]} excercise that is of {workout[3]} difficulty."

        print(f"Generating embedding for {i}: {workout[1]}...", end="")
        embedding = embeddings_model.embed_query(workout_sentence)
        print("\t\tFinished.")

        # Prepare the INSERT command
        insert_query = (
            """INSERT INTO embeddings (workout_name, embedding) VALUES (%s, %s)"""
        )
        # Values to be inserted
        values = (workout[1], embedding)

        # Execute the INSERT command
        cursor.execute(insert_query, values)

    connection.commit()


except psycopg2.Error as e:
    print(f"Error: {e}")
finally:
    # Ensure the cursor and connection are closed properly
    if cursor:
        cursor.close()  # Close the cursor first
    if connection:
        connection.close()  # Then close the connection
