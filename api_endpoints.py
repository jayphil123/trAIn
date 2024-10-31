from rag import rag_workouts
from flask import Flask, request
  
app = Flask(__name__) 

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
  
if __name__ == "__main__": 
    app.run(debug=True) 






