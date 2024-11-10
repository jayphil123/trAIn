import os
import psycopg2
import json
from openai import OpenAI
import numpy as np
from dotenv import load_dotenv
from langchain_openai import OpenAIEmbeddings
from queue import PriorityQueue
from numpy.linalg import norm
from helper_functions import get_workout_info

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
                model="gpt-4o-mini",
                # model="gpt-3.5-turbo",

            )
            response = convo.choices[0].message.content
            return response
    except Exception as e:
        print(f"Error occurred: {e}")
        return None

# General Case (user provides user query, return most similar workouts):
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


### WEEKLY WORKOUT ROUTINE GENERATION FUNCTIONS

def generate_weekly_workout(new_msg: str, conversation_history: dict[str, list[str]], workouts: list[str]) -> dict:
    """Generates the actual workout based on the keywords created."""

    prompt =  "Your job is to generate a weekly workout routine for a user. Each day should have BETWEEN 4 TO 5 workouts assuming its not a rest day. "
    prompt += "If you do a rest day the only workout on that day should be \"Rest\" with \"N/A\" as all other fields. "
    prompt += "Keep in mind any specific muscles, workouts, equipment, or goals they've mentioned.\n"
    prompt += f"\nPrevious Conversation: {conversation_history}\nLast sent message: {new_msg}"
    prompt += "Please respond in the following format with: "
    prompt += "{\"monday\":[{\"workout\":\"<name>\", \"time\": \"<how long it should take>\", \"quantity\":\"<units appropriate reps/sets, how many miles, etc.>\"}, ...],...}\n"
    prompt += "DO NOT ADD ANY WORKOUT NOT IN THE LIST\nDO NOT ADD EXTRA FIELDS INTO THE RESPONSE BEYOND DAY OF WEEK, WORKOUT, TIME TAKEN, QUANTITY (ie reps/sets, how many miles, etc.)\n"
    prompt += f"THE ONLY WORKOUTS YOU CAN ADD ARE (THESE MUST BE VERBATIM): {workouts}\n"
    prompt += "REMINDER ALL WORKOUTS MUST BE IN THAT LIST ABOVE AS VERBATIM NAMES, DO NOT HALLUCINATE"

    with open("prompt.txt", "w") as f:
        f.write(prompt)


    response = get_chatgpt_response(prompt)
    """
    Format:
    {
        "Friday": [{quantity: "", time: "", workout: "name"},{}]
    }


    """
    try:
        response = json.loads(response) # Converts str -> dict
        workout_info = get_workout_info(workouts) # Retrieves SQL data about each workout
        """
        Format:
        {
            "<workoutname>":{
                "id": ""
                "equipment": ""
                ...
            }
            ...
        }
        """
        for day, routine in response.items():
            print(f"day: {day}")
            for i, workout in enumerate(routine):
                name_of_workout = workout["workout"]
                print(f"\tworkout: {name_of_workout}")

                # Don't Add Info for "Rest" Day
                if name_of_workout == "Rest":
                    continue

                # If ChatGPT hallucinates a workout name, delete it, if nothing for that day add a rest-day
                if name_of_workout not in workouts:
                    print("\t\thallucinated workout :(")
                    response[day].pop(i)
                    continue

                # Update known workout with known info
                info = workout_info[name_of_workout]
                response[day][i].update(info)

        days_of_the_week = ["friday","saturday","sunday","monday","tuesday","wednesday","thursday"]
        included_days = list(response.keys())

        for day in days_of_the_week:
            day = day.lower()
            if day not in included_days:
               print(f"rest_day added: {day}")
               response[day] = [{"workout":"Rest", "time": "N/A", "quantity": "N/A"}]

        return response
    except Exception as e:
        print(f"An unexpected error occurred: {e}")
        return {}

def generate_weekly_workout_keywords(new_msg: str, conversation_history: dict[str, list[str]]):
    """Generate keywords related to chat history."""

    prompt =  "Your job is to generate keywords for a balanced workout routine for a user. "
    prompt += "Given the chat conversation generate a few keywords to provide to a RAG model "
    prompt += "to find appropriate keywords in the model. These keywords should be specfic. "
    prompt += "These key words should include specific muscles, workouts, equipment, or goals "
    prompt += "included in the conversation and message.\n"
    prompt += "These words should not be general like \"workout\" or \"fitness\", instead \"arms\" or \"legs\""
    prompt += "Please respond in the following format with 5 keywords: "
    prompt += "{\"keywords\": [\"<key word 1>\",\"<key word 2>\",...]}\n"
    prompt += "\n\n\n"
    prompt += f"The chat history is: {str(conversation_history)}\n"
    prompt += f"The newest message that you must classify is: {str(new_msg)}"

    response = get_chatgpt_response(prompt)

    try:
        response = json.loads(response) # Converts str -> dict
        return response["keywords"]
    except Exception as e:
        print(f"Error: {e}")
        return {}

def new_weekly_workout_endpoint(new_msg: str, conversation_history: dict[str, list[str]]) -> dict:
    """Generates a JSON of weeks worth of workout routines."""

    # Generates keywords based of conversation
    keywords = generate_weekly_workout_keywords(new_msg, conversation_history)
    print(f"keywords: {keywords}")

    # Creates a set of workouts based on each keyword
    workouts = set()
    for word in keywords:
        workouts.update(rag_workouts(word))
    print(workouts)


    # Generates Weekly workout routine, querying LLM to consider chat history
    routine = generate_weekly_workout(new_msg, conversation_history, workouts)

    return routine

### REPLACE INDIVIDUAL WORKOUT GENERATION FUNCTIONS


def approve_workouts(new_msg: str, conversation_history: dict[str: list[str]], existing_workout: dict[str: str]):
    """Generates a status for each workout to verify if user wants them."""

    prompt =  "Your job is to VERIFY if workouts should be removed or replaced based on chat history. Unless specified by the chat history \"KEEP\" rest days. "
    prompt += "Given the Chat History and the Workout's Info let me know if any workout should be removed or replaced. \n"
    prompt += "You are provided the entire routine, if it is not related or applicable to the message or prompt ALWAYS KEEP IT."
    prompt += "BE FAIRLY GENEROUS WITH WHAT YOU KEEP, ONLY DELETE OR REPLACE IF ABSOLUTELY SURE THEY DONT WANT IT."
    # prompt += "For example if they ask to replace REST days with leg days, don't touch arm days."
    prompt += "The format you respond it should be as follows:\n"
    prompt += "{\"day of the week\": [{\"workout\": \"name\", \"KEEP\": \"Reason to be kept\"}, {\"workout\": \"name\", \"REPLACE\": \"Reason to be replaced\"}, {\"workout\": \"name\", \"DELETE\": \"Reason to be deleted\"}}]\n"
    prompt += "\n\n\n"
    prompt += f"The chat history is: {str(conversation_history)}\n"
    prompt += f"The newest message is from the user is: {str(new_msg)}"
    prompt += f"This is the existing workout you are verifying: {existing_workout}"
    prompt += "Do not hallucinate or change any of the names of the workouts"
    response = get_chatgpt_response(prompt)

    try:
        response = json.loads(response) # Converts str -> dict
        print(response)
        return list(response.values())
    except Exception as e:
        print(f"Error: {e}")
        return {}

def generate_replacement_workout(new_msg: str, conversation_history: dict[str: list[str]], workout_to_be_removed: dict[str: str], reason: str) -> dict[str: str]:
    """Suggests replacement workouts for current plan, also returns info for each workout."""

    keywords = generate_weekly_workout_keywords(reason, workout_to_be_removed)
    workouts = set()
    for key in keywords:
        workouts.add(rag_workouts(key))

    possible_workouts = get_workout_info(list(workouts))

    prompt =  "Your job is to DELETE AND CREATE a new workout based on the conversation history. Unless specified by the chat history \"KEEP\" rest days. "
    prompt += "Given the Chat History and the Workout's Info let me know what newworkout it should be replaced with. \n"
    # prompt += "You are provided the entire routine, if it is not related or applicable to the message or prompt ALWAYS KEEP IT."
    prompt += "The format should rank the workouts in order of MOST to LEAST applicable as follows:\n"
    prompt += "{\"1\":\"workout\", \"2\":\"workout\", ...}\n"
    prompt += "\n\n\n"
    prompt += f"The chat history is: {str(conversation_history)}\n"
    prompt += f"The newest message is from the user is: {str(new_msg)}"
    prompt += f"The workout you are replacing is {workout_to_be_removed} because {reason}\n"
    prompt += f"These are other options to replace the above workout {possible_workouts}"
    prompt += "Do not hallucinate or change any of the names of the workouts"
    response = get_chatgpt_response(prompt)

    try:
        response = json.loads(response) # Converts str -> dict

        return response, possible_workouts
    except Exception as e:
        print(f"Error: {e}")
        return {}


def handle_remove_or_replace(new_msg: str, conversation_history: dict[str: list[str]], existing_workout: dict[str: str], keep_or_delete: dict[str: str]):
    """Generates new workout plan taking in necessary context for the old workouts and why they should be kept or deleted."""

    days = existing_workout.keys()
    new_workout = {}

    for day in days:
        new_workout[day] = []
        print(day)
        for i, workout in enumerate(keep_or_delete[day][0]):
            status = list(workout.keys())[1]
            reasoning = list(workout.values())[1]
            if status == "DELETE":
                print(f"\tDELETING {workout["workout"]}")
                # TODO if this was the only workout change to rest day?
            elif status == "REPLACE":
                print(f"\tREPLACING {workout["workout"]}")
                removed_workout = existing_workout[day][i]
                possible_replacements, workout_info = generate_replacement_workout(new_msg, conversation_history, removed_workout, workout[status])
                for rank, info in possible_replacements.items():
                    if info["workout"] == removed_workout["workout"]:
                        continue
                    new_workout[day].append(workout_info[info["workout"]])
                    break

            else:
                new_workout[day].append(existing_workout[day][i])
                print(f"\tKEEPING {workout["workout"]}")

    return new_workout



def replace_workout_endpoint(new_msg: str, conversation_history: dict[str, list[str]], existing_workout_routine: dict[str: list[dict: str]]) -> dict:
    """Handles replacing a workout user does not want."""

    # IDEAS:
    # - Add num workouts for that day/

    # Classify each workout as being KEPT or DELETED
    keep_or_delete = {}
    for day in existing_workout_routine:
        keep_or_delete[day] = approve_workouts(new_msg, conversation_history, {day: existing_workout_routine[day]})

    print("OLD:")
    for day, val in existing_workout_routine.items():
        print(day)
        for workout in val:
            print(f"\t{workout["workout"]}")



    print("STATUS:")
    for day, val in keep_or_delete.items():
        print(day)
        for workout in val:
            print(f"\t{workout}")


    new_workout = handle_remove_or_replace(new_msg, conversation_history, existing_workout_routine, keep_or_delete)


    print("NEW:")
    for day, val in new_workout.items():
        print(day)
        for workout in val:
            print(f"\t{workout["workout"]}")



    return new_workout

# def general_:


def handle_conversation(new_msg: str, conversation_history: dict[str, list[str]]) -> dict:

    prompt =  "Your job is to determine which category of messages a message is classified into. "
    prompt += "Your options are 'New Weekly Workout Routine', 'Replace a Workout/they don't like a workout', 'General Question About Exercise'.\n"
    prompt += "Format your response as a json in the following format:\n"
    prompt += "{\"option\": \"<one of the options>\"}\n"
    prompt += "\n\n\n"
    prompt += f"The chat history is: {str(conversation_history)}\n"
    prompt += f"The newest message that you must classify is: {str(new_msg)}"

    # Example usage
    response = get_chatgpt_response(prompt)

    try:
        response = json.loads(response)
        print(response)
        if response["option"] == "New Weekly Workout Routine":
            print("New Weekly Workout Routine")
            new_plan = new_weekly_workout_endpoint(new_msg, conversation_history)
            return new_plan, 1
        if response["option"] == "Replace a Workout/they don't like a workout":
            print("Replace the Current Workout")
            workout_routine = {}
            with open("web_api/example_routine.json", "r") as f:
                workout_routine = json.load(f)
            fixed_plan = replace_workout_endpoint(new_msg, conversation_history, workout_routine)
            return fixed_plan, 2
        if response["option"] == "General Question About Exercise":
            print("General Question About Exercise")

            return {}, 3
    except Exception as e:
        print(e)
        return {"Error": "Error"}, 4

