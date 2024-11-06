import os
import psycopg2
import json
from openai import OpenAI
import numpy as np
from dotenv import load_dotenv
from langchain_openai import OpenAIEmbeddings
from queue import PriorityQueue
from numpy.linalg import norm


# Query ChatGPT
def get_chatgpt_response(prompt):
    load_dotenv()

    try:
        with OpenAI(api_key=os.environ.get("OPENAI_API_KEY")) as client:
            convo = client.chat.completions.create(
                messages=[
                    {
                        "role": "user",
                        "content": prompt,
                    }
                ],
                model="gpt-3.5-turbo",
            )
            response = convo.choices[0].message.content
            return response
    except Exception as e:
        print(f"Error occurred: {e}")
        return None

# General Case (user provides user query, return most similar workouts): 
# Incomplete - currently only provides a list of context exercises. Needs to query GPT with these exercises as contex
def rag_workouts(query, count=5):
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


def generate_weekly_workout(new_msg: str, conversation_history: dict[str, list[str]], workouts: list[str]) -> dict:
    prompt =  "Your job is to generate a weekly workout routine for a user. Each day should have BETWEEN 4 TO 5 workouts assuming its not a rest day. "
    prompt += "If you do a rest day the only workout on that day should be \"Rest\" with \"N/A\" as all other fields. "
    prompt += "Keep in mind the any specific muscles, workouts, equipment, or goals they've mentioned.\n"
    prompt += f"\nPrev Convo: {conversation_history}\nLast sent message {new_msg}"
    prompt += "Please respond in the following format with: "
    prompt += "{\"monday\":[{\"workout\":\"<name>\", \"time\": \"<how long it should take>\", \"quantity\":\"<units appropriate reps/sets, how many miles, etc.>\"}, ...],...}\n"
    prompt += "DO NOT ADD ANY WORKOUT NOT IN THE LIST\nDO NOT ADD EXTRA FIELDS INTO THE RESPONSE BEYOND DAY OF WEEK, WORKOUT, TIME TAKEN, QUANTITY (ie reps/sets, how many miles, etc.)\n"
    prompt += f"THE ONLY WORKOUTS YOU CAN ADD ARE (THESE MUST BE VERBATIM): {workouts}"

    response = get_chatgpt_response(prompt)
    try:
        response = json.loads(response)
        print(response)
        return response
    except Exception as e:
        print(f"An unexpected error occurred: {e}")


def new_weekly_workout(new_msg: str, conversation_history: dict[str, list[str]]) -> dict:
    prompt =  "Your job is to generate keywords for a balanced workout routine for a user. "
    prompt += "Given the chat conversation generate a few keywords to provide to a RAG model "
    prompt += "to find appropriate keywords in the model. "
    prompt += "These key words should include specific muscles, workouts, equipment, or goals.\n"
    prompt += "Please respond in the following format with 5 keywords: "
    prompt += "{\"keywords\": [\"<key word 1>\",\"<key word 2>\",...]}\n"
    prompt += "\n\n\n"
    prompt += f"The chat history is: {str(conversation_history)}\n"
    prompt += f"The newest message that you must classify is: {str(new_msg)}"

    response = get_chatgpt_response(prompt)
    try:
        response = json.loads(response)
        print(f"reponse: {response}")
        keywords = response["keywords"]
        print(f"keywords: {keywords}")
        workouts = set()

        for word in keywords:
            for workout in rag_workouts(word):
                workouts.add(workout)

        return generate_weekly_workout(new_msg, conversation_history, workouts)
    except Exception as e:
        print(f"An unexpected error occurred: {e}")


def handle_conversation(new_msg: str, conversation_history: dict[str, list[str]]) -> dict:

    prompt =  "Your job is to determine which category of messages a message is classified into. "
    prompt += "Your options are 'New Weekly Workout Routine', 'Replace the Current Workout', 'General Question About Exercise'.\n"
    prompt += "Format your response as a json in the following format:\n"
    prompt += "{\"option\": \"<one of the options>\"}\n"
    prompt += "\n\n\n"
    prompt += f"The chat history is: {str(conversation_history)}\n"
    prompt += f"The newest message that you must classify is: {str(new_msg)}"

    # Example usage
    response = get_chatgpt_response(prompt)

    try:
        response = json.loads(response)
        if response["option"] == "New Weekly Workout Routine":
            print("New Weekly Workout Routine")
            return new_weekly_workout(new_msg, conversation_history)
        if response["option"] == "Replace the Current Workout":
            print("Replace the Current Workout")
        if response["option"] == "General Question About Exercise":
            print("General Question About Exercise")
    except:
        return "Error"
