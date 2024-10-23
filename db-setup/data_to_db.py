from dotenv import load_dotenv
import os
import json
import psycopg2



def handle_list_input(value: str):
    """Cleans string to be csv, string, or empty string"""
    # Handles null edgecase
    if value == None:
        return ""

    # Handles string formatted list edgecase ex. "[\"Entry1\", \"Entry2\""]" -> "Entry1,Entry2"
    if value[0] == "[":
        # Remove the following chars [, ], "
        formatted_value = value[1:-1].replace("\"","")
        return formatted_value

    # Handles regular string case
    return value

def main():
    """Reads workouts in free-exercise-db.json and inserts into database"""

    # Load enviornment variables
    load_dotenv()

    # Get enviornment variable values
    host = os.getenv("DB_HOST")
    port = os.getenv("DB_PORT")
    user = os.getenv("DB_USER")
    password = os.getenv("DB_PASSWORD")
    database_name = os.getenv("DB_NAME")


    # Read json file and convert to dictionary
    with open("free-exercise-db.json", "r") as f:
        data = json.load(f)

    
    try:
        # Connect to the specific database
        connection = psycopg2.connect(
            host=host,
            port=port,
            user=user,
            password=password,
            dbname=database_name
        )
        cursor = connection.cursor()

        # Read schema file for workout db
        with open("workouts_shema.sql", "r") as f:
            table_query = f.read()
            cursor.execute(table_query)

        # for each workout insert into the table (clean each entry)
        for i, workout_list in enumerate(data["rows"]):
            print(f"{i}: {name}")

            name = handle_list_input(workout_list[0])
            force = handle_list_input(workout_list[1])
            level = handle_list_input(workout_list[2])
            mechanic = handle_list_input(workout_list[3])
            equipment = handle_list_input(workout_list[4])
            primaryMuscles = handle_list_input(workout_list[5])
            secondaryMuscles = handle_list_input(workout_list[6])
            instructions = handle_list_input(workout_list[7])
            category = handle_list_input(workout_list[8])
            images = handle_list_input(workout_list[9])
            id_str = handle_list_input(workout_list[10])


            # Format insert query
            insert_query = '''INSERT INTO workouts (name, force, level, mechanic,
                                                    equipment, primary_muscles, secondary_muscles,
                                                    instructions, category, images, id_str
                                                    ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);'''
            
            # Values to be inserted
            values = (name, force, level, mechanic, equipment, primaryMuscles, secondaryMuscles, instructions, category, images, id_str)

        
            # Execute the INSERT command
            cursor.execute(insert_query, values)

    except Exception as e:
        print(f"Error {e}")

if __name__ == "__main__":
    main()