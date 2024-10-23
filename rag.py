import os

from dotenv import load_dotenv
from langchain import OpenAI
from langchain_postgres import PGVector
from langchain_postgres.vectorstores import PGVector
from langchain.embeddings.openai import OpenAIEmbeddings

# Load environment variables from .env file
load_dotenv()

# Connection parameters from environment variables
host = os.getenv("DB_HOST")
port = os.getenv("DB_PORT")
user = os.getenv("DB_USER")
password = os.getenv("DB_PASSWORD")
database_name = os.getenv("DB_NAME")
openai_key = os.getenv("OPENAI_API_KEY")

# Define your PostgreSQL connection string
connection_string = f"postgresql://{user}:{password}@{host}:{port}/{database_name}"

# TODO: Add open ai key to .env file
# Create an embedding function
embeddings = OpenAIEmbeddings(openai_api_key=openai_key, model="text-embedding-3-small")

# Create a PostgresDatabase object
database = PGVector(
    connection=connection_string,
    table_name="embeddings",
    embedding_function=embeddings,
)

# Use the PostgresDatabase as a retriever
retriever = database.as_retriever()

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
query = "What are the best chest workouts for building muscle in the database?"

# Run the chain
result = rag_chain({"query": query})
print(result['result'])
