from rag import rag_workouts, handle_conversation
from flask import Flask, request, redirect, url_for, session, Response
from helper_functions import check_existing_login, create_new_login, salt_and_hash_password, check_valid_cookie, add_user_stats


app = Flask(__name__)

@app.route("/get_workout")
def get_workouts():
    # Get args data
    cookies = request.session
    username = cookies.get('username')
    cookie = cookies.get('cookie')

    status = check_valid_cookie(username, cookie)
    status = True
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

# ********** Route for all queries sent through chat feature in app **********

@app.route("/send_convo")
def send_convo():
    args = request.args
    if args.get("query") is None:
        return "Please include a user-query"

    query = args.get("query")

    response = {
        "status": 0,
        "message": "Success",
        "content": []
    }

    # TODO change query to not be placeholder, add convo history dict[str -> list(str)]
    response["content"], response["status"] = handle_conversation(query, {})

    return response

# ********** Route for saving initial user information **********
@app.route("/save-user-info", methods=['POST'])
def save_user_info():
    response = {
        "status": 0,
        "message": "Success"
    }

    # Save args data into user_info dict
    user_info = {}
    args = request.args
    user_info["username"] = args.get('username')
    user_info["height"]  = args.get('height')
    user_info["weight"] = args.get('weight')
    user_info["gender"] = args.get('gender')
    user_info["age"] = args.get('age')
    user_info["goals"] = args.get('goals')
    user_info["frequency"] = args.get('frequency')
    user_info["intensity"] = args.get('intensity')
    user_info["timeframe"] = args.get('timeframe')
    user_info["workoutPlans"] = args.get('workoutPlans')

    status = add_user_stats(user_info)

    if status == 1:
        response = {
            "status": 1,
            "message": "Failure"
        }
        return Response(response, 400)

    return Response(response, 200)

# ********** All login / logout endpoints below **********

# Form: /login-form?username=<username>&password=<password>
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

        return Response(response, status=200)

    response["status"] = 1
    response["message"] = "failed login"
    return Response(response, status=400)


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
        return Response(response, status=400)
    if status == 2:
        response["message"] = "Username already exists"
        return Response(response, status=400)
    if status == 3:
        response["message"] = "Error Creating Account"
        return Response(response, status=400)

    # Set session data
    session['username'] = username

    # Returns success
    return Response(response, status=201)  # "status" = 0 on success

@app.route('/logout-form', methods=['POST'])
def logout():
    response = {
        "status": 0,
        "message": "Success"
    }

    # Remove session data
    session.clear()

    # Returns success
    return Response(response, status=200)


if __name__ == "__main__":
    app.run(debug=True)
