import os
import psycopg2
import numpy as np
from dotenv import load_dotenv
from langchain_openai import OpenAIEmbeddings
from queue import PriorityQueue
from numpy.linalg import norm


# General Case (user provides user query, return most similar workouts): 
# Incomplete - currently only provides a list of context exercises. Needs to query GPT with these exercises as contex
def rag_workouts(query, count):
    """Returns "count" # of workouts with the closest cosine similarity to the query."""

    # Load environment variables from .env file
    load_dotenv()

    # Connection parameters from environment variables
    host = os.getenv("DB_HOST")
    port = os.getenv("DB_PORT")
    user = os.getenv("DB_USER")
    password = os.getenv("DB_PASSWORD")
    database_name = os.getenv("DB_NAME")
    openai_key = os.getenv("OPENAI_API_KEY")

    # Connect to database
    try:
        connection = psycopg2.connect(
            host=host,
            port=port,
            user=user,
            password=password,
            dbname=database_name
        )

        # Create a cursor object
        cursor = connection.cursor()

        # SQL command to pull embeddings
        select_table_query = 'SELECT embedding, workout_name from embeddings'

        # Execute the create table command
        cursor.execute(select_table_query)
        
        # Select workout embeddings
        unprocessed_embeddings = cursor.fetchall()

        # GGenerate embedding of user Query 
        embeddings_model = OpenAIEmbeddings(
            openai_api_key=openai_key, model="text-embedding-3-small"
        )
        query_embedding = embeddings_model.embed_query(query)

        # Push cosine similarity of workout embeddings and the query into PQ
        pq = PriorityQueue()
        for embedding in unprocessed_embeddings:
            
            workout_embedding = embedding[0] 
            cosine = -np.dot(query_embedding, workout_embedding)/(norm(query_embedding)*norm(workout_embedding))
            workout_name = embedding[1]
            pq.put((cosine, workout_name))
        
        # Find the top n workouts similar to query 
        workouts = []
        for x in range(count):
            workouts.append(pq.get()[1])
        return workouts
        

    except psycopg2.Error as e:
        print(f"Error: {e}")
    finally:
        # Ensure the cursor and connection are closed properly
        if cursor:
            cursor.close()  # Close the cursor first
        if connection:
            connection.close()  # Then close the connection

