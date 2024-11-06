from rag import rag_workouts
from flask import Flask, request, redirect, url_for, session, Response
from helper_functions import create_new_login, salt_and_hash_password


app = Flask(__name__) 

def redirect_to_login(func):
    """Decorate to require login."""
    def check(*args, **kwargs):
        if 'username' not in session:
            return redirect(url_for('login_page'))
        return func(*args, **kwargs)
    check.__name__ = func.__name__
    return check



@app.route("/get_workout")
def index():
    args = request.args
    if args.get("query") is None:
        return "Please include a user-query"
    
    count = 5 
    if args.get("count") is not None:
        count = int(args.get("count"))
    
    query = args.get("query")
    return rag_workouts(query, count)


@app.route("/login-page", methods=['POST'])
def login_page():
    return



@app.route('/signup-form', methods=['POST'])
def signup():

    # Get form data
    username = request.form.get('username')
    password = request.form.get('password')

    # Create new user entry
    create_new_login(username, password)
    if create_new_login == 1:
        return Response("Exact Login already exists", status=200)
    if create_new_login == 2:
        return Response("Username already exists", status=200)
    if create_new_login == 3:
        return Response("Error Creating Account", status=200)

    # Set session data
    session['username'] = username
    session['cookie-token'] = salt_and_hash_password(password)        

    # Returns sucess
    return Response("Account Created", status=201)


if __name__ == "__main__": 
    app.run(debug=True) 






