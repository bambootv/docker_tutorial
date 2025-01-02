# Use the official Ubuntu image as the base
FROM ubuntu:latest

# Configure the main working directory
WORKDIR /app

# Update package lists and install necessary packages
RUN apt-get update; \
    apt-get install -y --no-install-recommends \
        nginx \
        nano \
        vim \
        postgresql; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

# Copy the startup script and set permissions
COPY start.sh .
RUN chmod +x ./start.sh

# Set the entrypoint
ENTRYPOINT ["./start.sh"]

# Expose the required port
EXPOSE 80
