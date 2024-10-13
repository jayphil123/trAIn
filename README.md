# trAIn

## Set Up Docker/PostgreSQL

Step 1.) Install Docker 
- Download the appropriate version of docker desktop app onto your computer (for windows make sure its the right version chip arcitechture arm64 vs x86 for your device)

- Once downloaded, open the desktop app

Step 2.) Modify "/bin/setup_postgre.sh"

- Update the username and password to your desired values

- Once completed modify the .env file and to your updated username and password

- *IMPORTANT*: After you run, change password back to passwordTemp before committing to repo otherwise PASSWORD LEAK

Step 3.) Run `./bin/setup_postgre.sh`

- This will install the appropriate version of the postgre docker container onto your computer

- The following should be the ending of the expected output if it worked

```
CONTAINER ID   IMAGE             COMMAND                  CREATED        STATUS                  PORTS                                              NAMES
6df75c658f04   postgres:17.0     "docker-entrypoint.s…"   1 second ago   Up Less than a second   0.0.0.0:5432->5432/tcp                             postgresql
```

## Set Up Python

Step 1.) Download Python3.12 or later

- This will be required for all of our api endpoints, including the initial setup for the database

Step 2.) Download the required libraries

- Run `pip install -r requirements.txt`

Step 3.) Create a .env file that contains the following content and modify tempPassword and my_new_databse to whatever values you'd like (password must match password in `bin/setup_postgre.sh`)

```
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=tempPassword
DB_NAME=my_new_database
```
** NOTE MAKE SURE YOU'RE GIT IGNORE CONTAINS `.env` OR YOUR PASSWORD WILL LEAK

Step 4.) Run postgretest.py

- execute `python3 postgre_make_db.py`, and if the output says `Database 'my_new_database' created sucessfully` congrats it worked! 