from rag import rag_workouts
from flask import Flask, request, redirect, url_for, session
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


@app.route("/login-page", methods=['GET'])
def login_page():
    if 'username' in session:
        return redirect(url_for('show_index')) # TODO: Replace for actual homepage
    context = {}
    return render_template("login.html", **context) # TODO: Replace for actual 




@app.route('/signup-form', methods=['GET', 'POST'])
def signup():
    if request.method == 'POST':
        # Get form data
        username = request.form.get('username')
        password = request.form.get('password')

        # Create new user entry
        create_new_login(username, password)

        # Set session data
        session['username'] = username
        session['cookie-token'] = salt_and_hash_password(password)        

        # Redirect to home page
        return redirect(url_for('index'))
    
    # Render signup page if GET request
    return render_template('signup.html')

@app.route('/logout-form', methods=['POST'])
def logout_page():
    """Get the login page."""
    session.clear()
    return redirect(url_for('login_page') or url_for('show_index')) # TODO: Replace both


if __name__ == "__main__": 
    app.run(debug=True) 






