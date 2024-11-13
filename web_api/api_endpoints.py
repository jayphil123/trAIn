from rag import rag_workouts, handle_conversation
from flask import Flask, request, redirect, url_for, session, Response
from helper_functions import check_existing_login, create_new_login, salt_and_hash_password, check_valid_cookie, add_user_stats, get_user_info


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

# ********** All login / logout endpoints below **********

# Form: /login-form?username=<username>&password=<password>
@app.route("/login_form", methods=['POST'])
def login_page():
    # Get args data
    args = request.args
    username = args.get('username')
    password = args.get('password')

    if not check_existing_login(username, password):
        return Response({"status": 1, "message": "Failed login"}, 400)


    user_info = get_user_info(username)

    response = {
        "status": 0,
        "message": "Success",
        "user_info": user_info
    }

    # Set session data
    session['username'] = username

    return Response(response, status=200)


@app.route('/signup_form', methods=['POST'])
def signup():
    # Save attatched json data into user_info dict
    user_info = request.get_json()

    # Create new user entry
    status = add_user_stats(user_info)

    response = {
        "status": status,
        "message": "Success"
    }

    if status != 0:
        response["message"] = "Exact Login already exists"
        return Response(response, status=400)

    # Set session data
    session['username'] = user_info["username"]

    # Returns success
    return Response(response, status=201)  # "status" = 0 on success

@app.route('/logout_form', methods=['POST'])
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
