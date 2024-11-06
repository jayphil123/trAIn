from rag import rag_workouts
from flask import Flask, request, redirect, url_for, session, Response
from helper_functions import check_existing_login, create_new_login, salt_and_hash_password, check_valid_cookie


app = Flask(__name__) 

@app.route("/get_workout")
def index():
    # Get args data
    cookies = request.session
    username = cookies.get('username')
    cookie = cookies.get('cookie')

    status = check_valid_cookie(username, cookie)
    response = { 
        "status": 0,
        "message": "Success",
        "content": []
    }

    if not status:
        response["status"] = 1
        response["message"] = "Not valid user"
        return response

    args = request.args
    if args.get("query") is None:
        return "Please include a user-query"
    
    count = 5 
    if args.get("count") is not None:
        count = int(args.get("count"))
    
    query = args.get("query")

    response["content"] = rag_workouts(query, count)
    return response


@app.route("/login-form", methods=['POST'])
def login_page():
    # Get args data
    args = request.args
    username = args.get('username')
    password = args.get('password')

    status = check_existing_login(username, password)
    response = { 
        "status": 0,
        "message": "Success"
    }

    if status == True:
         # Set session data
        session['username'] = username
        session['cookie-token'] = salt_and_hash_password(password)        
        return Response(response, status=200)
   
    response["status"] = 1
    response["message"] = "failed login"
    return Response(response, status=200)


@app.route('/signup-form', methods=['POST'])
def signup():

    # Get args data
    args = request.session
    username = args.get('username')
    password = args.get('password')

    # Create new user entry
    status = create_new_login(username, password)

    response = {
        "status": status,
        "message": "Success"
    }

    # Check error messages
    if status == 1:
        response["message"] = "Exact Login already exists" 
        return Response(response, status=200)
    if status == 2:
        response["message"] = "Username already exists" 
        return Response(response, status=200)
    if status == 3:
        response["message"] = "Error Creating Account"
        return Response(response, status=200)

    # Set session data
    session['username'] = username
    session['cookie-token'] = salt_and_hash_password(password)        

    # Returns success
    return Response(response, status=201)

@app.route('/logout-form', methods=['POST'])
def signup():
    response = {
        "status": 0,
        "message": "Success"
    }

    # Set session data
    session['username'] = ""
    session['cookie-token'] = ""

    # Returns success
    return Response(response, status=200)


if __name__ == "__main__": 
    app.run(debug=True) 

