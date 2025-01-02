# Use the official Ubuntu image as the base
FROM ubuntu

# Attach metadata
LABEL author.name="Bamboo" \
      author.email="hoan.nguyen.mfn@gmail.com"

# Configure the main working directory
ENV APP_PATH=/venv
WORKDIR $APP_PATH

# Set the timezone
ENV TZ=Asia/Ho_Chi_Minh
RUN set -eux; \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime; \
    echo $TZ > /etc/timezone

# Update package lists and install necessary packages
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        nginx \
        nano \
        vim \
        mysql-server; \
    echo "mysql-server mysql-server/root_password password root" | debconf-set-selections; \
    echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

# Copy the startup script and set permissions
COPY start.sh /venv/
RUN chmod +x /venv/start.sh

# Set the entrypoint
ENTRYPOINT ["/venv/start.sh"]

# Expose the required port
EXPOSE 80
