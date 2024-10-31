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

def list_to_english(the_list):
    sentence = ""
    the_list = the_list.split(",")
    for item in the_list[:-1]:
        sentence += item + ", "
    if len(the_list) > 1:
        sentence += "and "

    sentence += the_list[-1]
    return sentence

def create_exercise(workout):
     
    workout_sentence = f"{workout[1]}"
    if workout[2] != None and workout[2] != "":
        workout_sentence += f" is an {workout[9]} exercise for a {workout[2]} day and"    
    if workout[3] != None and workout[3] != "":
        workout_sentence += f" is of difficulty {workout[3]} and"
    if workout[4] != None and workout[4] != "":
        workout_sentence += f" works out the {workout[4]} mechanic and"
    if workout[5] != None and workout[5] != "":
        workout_sentence += f" requires {workout[5]} as equipment and"
    if workout[6] != None and workout[6] != "":
        muscle_group_sentence = list_to_english(workout[6])
        workout_sentence += f" works out these primary muscle groups {muscle_group_sentence}"
    if workout[7] != None and len(workout[7]) != 0 and workout[7] != "":
        muscle_group_sentence = list_to_english(workout[7])
        workout_sentence += f" works out these secondary muscle groups {muscle_group_sentence}."
    if workout[8] != None and len(workout[8]) != 0 and workout[8] != "":
        workout_sentence += f"\nThese are the instructions to do the excerise: {workout[8].replace(",","")}"
    
    return workout_sentence


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
        workout_sentence = create_exercise(workout)
        output = f"Generating embedding for {i}: {workout[1]}..."
        print(f"{output:<90}", end="")
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
