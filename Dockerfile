FROM ruby:2.5.1

# Information about author
LABEL author.name="HoanKy" \
  author.email="hoanki2212@gmail.com"

# Install apt based dependencies required to run Rails as
# well as RubyGems. As the Ruby image itself is based on a
# Debian image, we use apt-get to install those.
RUN apt-get update && \
  apt-get install -y nodejs nano vim

# Set the timezone.
ENV TZ=Asia/Ho_Chi_Minh
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Configure the main working directory. This is the base
# directory used in any further RUN, COPY, and ENTRYPOINT
# commands.
ENV APP_PATH /my_app
WORKDIR $APP_PATH

# Copy the Gemfile as well as the Gemfile.lock and install
# the RubyGems. This is a separate step so the dependencies
# will be cached unless changes to one of those two files
# are made.
COPY Gemfile Gemfile.lock $APP_PATH/
RUN bundle install --without production --retry 2 \
  --jobs `expr $(cat /proc/cpuinfo | grep -c "cpu cores") - 1`

# Add a script to be executed every time the container starts.
COPY docker/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# The main command to run when the container starts. Also
# tell the Rails dev server to bind to all interfaces by
# default.
CMD ["rails", "server", "-b", "0.0.0.0"]
