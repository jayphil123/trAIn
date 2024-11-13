#!/usr/bin/env bash

# Function to convert array to JSON array
array_to_json() {
  local -n arr="$1"  # Reference the array passed as an argument
  local json="["

  for goal in "${arr[@]}"; do
    json+="\"$goal\","
  done
  
  json="${json%,}]"  # Remove the trailing comma and close the array
  echo "$json"
}

# Define the arrays
GOALS=("Get JAcked" "Big muscles!" "Stay fit")
FREQUENCY=("One to 2 times per day")
INTENSITY=("Super intense")
TIMEFRAME=("1-2 times per week")

# Convert arrays to JSON format
GOALS_JSON=$(array_to_json GOALS)
FREQUENCY_JSON=$(array_to_json FREQUENCY)
INTENSITY_JSON=$(array_to_json INTENSITY)
TIMEFRAME_JSON=$(array_to_json TIMEFRAME)

# Other variables
USERNAME="dummy"
PASSWORD="test"
NAME="MyName!"
WEIGHT="100"
HEIGHT="180"
AGE="21"
GENDER="Male"
WORKOUTPLANS="I want to get beefy"

# Use curl to send the data to the Flask server
curl -X POST http://localhost:5000/signup_form \
     -H "Content-Type: application/json" \
     -d '{
           "username": "'"$USERNAME"'",
           "password": "'"$PASSWORD"'",
           "name": "'"$NAME"'",
           "weight": "'"$WEIGHT"'",
           "height": "'"$HEIGHT"'",
           "age": "'"$AGE"'",
           "goals": '"$GOALS_JSON"',
           "frequency": '"$FREQUENCY_JSON"',
           "intensity": '"$INTENSITY_JSON"',
           "timeframe": '"$TIMEFRAME_JSON"',
           "workoutplans": "'"$WORKOUTPLANS"'",
           "gender": "'"$GENDER"'"
         }'
