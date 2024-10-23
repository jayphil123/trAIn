# trAIn

## Set Up Docker/PostgreSQL

Step 1.) Install Docker 
- Download the appropriate version of docker desktop app onto your computer (for windows make sure its the right version chip arcitechture arm64 vs x86 for your device)

- Once downloaded, open the desktop app

Step 2.) Modify "/bin/setup_postgre.sh"

- Update the password variable to your desired value

- Once completed modify the .env file and to your updated password

Step 3.) Run `./bin/setup_postgre.sh`

- This will install the appropriate version of the postgre docker container onto your computer

- The following should be the ending of the expected output if it worked

```
CONTAINER ID   IMAGE             COMMAND                  CREATED        STATUS                  PORTS                                              NAMES
6df75c658f04   postgres:17.0     "docker-entrypoint.s…"   1 second ago   Up Less than a second   0.0.0.0:5432->5432/tcp                             postgresql
```

- *IMPORTANT*: After you run, change password back to tempPassword in "/bin/setup_postgre.sh" before committing to repo

## Set Up Python

Step 1.) Download Python3.12 or later

- This will be required for all of our api endpoints, including the initial setup for the database

Step 2.) Create a python virtual environment in the root project directory

- Run `python -m venv env`

Step 3.) Download the required libraries

- Run `pip install -r requirements.txt`

Step 4.) Create a .env file that contains the following content and modify tempPassword and my_new_databse to whatever values you'd like (password must match password in `bin/setup_postgre.sh`)

```
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=tempPassword
DB_NAME=my_new_database
```
** NOTE MAKE SURE YOU'RE GIT IGNORE CONTAINS `.env` OR YOUR PASSWORD WILL LEAK

Step 5.) Run postgre_make_db.py

- execute `python3 postgre_make_db.py`, and if the output says `Database 'my_new_database' created sucessfully` congrats it worked! 

## Project File Hierarchy
bin/*
- Shell scripts to setup, run, and restart postgreSQL

db-setup/*
- SQL schema, python files setting up our database and tables  
- postgre_make_db.py: creates our overarching database to hold all tables  
- postgre_make_tb.py: creates user database  
- data_to_db.py: converts json workout data to a table in our postgreSQL database  
- free-exercise-db.json: the workout data used as context for the model  
- workouts_schema.sql: the schema for the table created in data_to_db.py  

sample_app/*
- Frontend application built using flutter  

