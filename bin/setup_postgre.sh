# Enviornment Variables:
# NOTE: Replace 'tempUserName' and 'tempPassword' with your desired username and password
export username="tempUsername"
export password="tempPassword"

# Pull PostgreSQL Docker Container
docker pull postgres

# Create a directory for persistent data storage
mkdir -p ./data

# Stop and remove any existing container named "postgresql" to avoid conflicts
docker stop postgresql 2>/dev/null || true
docker rm postgresql 2>/dev/null || true

# Run PostgreSQL Docker Container
docker run --name my_postgres -e POSTGRES_PASSWORD=$password -d -p 5432:5432 postgres

# Verify that the container is running
docker ps
