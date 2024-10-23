import os

from dotenv import load_dotenv
from langchain import OpenAI
from langchain.retrievers import PostgresDatabase
from langchain.chains import RetrievalQA
from langchain.embeddings.openai import OpenAIEmbeddings

# Load environment variables from .env file
load_dotenv()

# Connection parameters from environment variables
host = os.getenv("DB_HOST")
port = os.getenv("DB_PORT")
user = os.getenv("DB_USER")
password = os.getenv("DB_PASSWORD")
database_name = os.getenv("DB_NAME")
openai_api_key = os.getenv("OPENAI_API_KEY")

# Define your PostgreSQL connection string
connection_string = f"postgresql://{user}:{password}@{host}:{port}/{database_name}"

# Create a PostgresDatabase object
database = PostgresDatabase.from_uri(connection_string, table_name="embeddings_table")


#TODO: Add open ai key to .env file
# Create an embedding function
embeddings = OpenAIEmbeddings()

# Use the PostgresDatabase as a retriever
retriever = database.as_retriever(embedding_function=embeddings)

# Create a language model instance
llm = OpenAI(temperature=0.7)

# Create the RAG chain using LangChain's RetrievalQA
rag_chain = RetrievalQA(
    llm=llm,
    retriever=retriever,
    input_key="query",  # Define the key for query input
    output_key="result" # Define the key for generated result
)

# Define your query
query = "What are the most popular products in the database?"

# Run the chain
result = rag_chain({"query": query})
print(result['result'])
