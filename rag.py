import os
from dotenv import load_dotenv
from langchain_community.document_loaders import WebBaseLoader
from langchain_chroma import Chroma
from langchain_core.output_parsers import StrOutputParser
from langchain_core.runnables import RunnablePassthrough
from langchain_openai import OpenAIEmbeddings
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain.chains import RetrievalQA
from langchain_openai import ChatOpenAI
import psycopg2
from langchain_community.llms import OpenAI

# Load environment variables from .env file
load_dotenv()

# Connection parameters from environment variables
host = os.getenv("DB_HOST")
port = os.getenv("DB_PORT")
user = os.getenv("DB_USER")
password = os.getenv("DB_PASSWORD")
database_name = os.getenv("DB_NAME")
openai_key = os.getenv("OPENAI_API_KEY")

try:
    # Connect to the specific database
    connection = psycopg2.connect(
        host=host,
        port=port,
        user=user,
        password=password,
        dbname=database_name
    )

    # Create a cursor object
    cursor = connection.cursor()

    # SQL command to pull embeddings
    select_table_query = 'SELECT embedding from embeddings'

    # Execute the create table command
    cursor.execute(select_table_query)
    
    # Process the embeddings
    unprocessed_embeddings = cursor.fetchall()
    embeddings = []
    for embedding in unprocessed_embeddings:
        embeddings.append(embedding[0])
    

    embeddings_model = OpenAIEmbeddings(
        openai_api_key=openai_key, model="text-embedding-3-small"
    )

    llm = ChatOpenAI(model="gpt-3.5-turbo")

    
    
    vectorstore = Chroma(embedding_function=embeddings_model)  # No 'embeddings' argument here

    # Add the embeddings to Chroma
    vectorstore.add(embeddings)

    retriever = vectorstore.as_retriever()

    # Create a retrieval-based QA chain
    qa_chain = RetrievalQA.from_chain_type(
        llm=llm,
        chain_type="stuff",  # Choose the appropriate type for your task
        retriever=retriever
    )

    # Run a sample query
    result = qa_chain.run("I want to exercise my arms for a moderate difficulty workout. What should I do?")
    print(result)

    # print(rag_chain.invoke("I want to excerise my arms for a moderate difficulty workout what should I do please?"))


except psycopg2.Error as e:
    print(f"Error: {e}")
finally:
    # Ensure the cursor and connection are closed properly
    if cursor:
        cursor.close()  # Close the cursor first
    if connection:
        connection.close()  # Then close the connection

