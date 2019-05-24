# Syntax to run this file
# ./deploy.sh development
# ./deploy.sh staging

#! /bin/bash
echo "------------------------------------------------------>  Starting deploy ..."
echo "------------------------------------------------------>  Go to app root ..."
APP_ROOT=$(cd `dirname $0` && cd .. && pwd)
cd $APP_ROOT

# Only for staging environment
credentials="config/credentials.yml.enc"
credentials_bak="config/credentials.yml.enc.bak"
if [ -f "$credentials" ] && [ "$1" = "staging" ]; then
  echo "------------------------------------------------------>  [Staging only] Backing up key on credentials.yml.enc ..."
  cp -f $credentials $credentials_bak
fi

echo "------------------------------------------------------>  Updating source code ..."
git checkout master
git pull origin master

# Only for staging environment
if [ -f "$credentials_bak" ] && [ "$1" = "staging" ]; then
  echo "------------------------------------------------------>  [Staging only] Recovering key on credentials.yml.enc ..."
  cp -f $credentials_bak $credentials
fi

echo "------------------------------------------------------>  Removing all container ..."
docker-compose down

echo "------------------------------------------------------>  Building all container ..."
sudo docker-compose build
# Current user can not access some files, use `ls -la` to check

echo "------------------------------------------------------>  Starting mysql container ..."
docker-compose up -d mysql
echo "------------------------------------------------------>  Starting spring container ..."
docker-compose run -e RAILS_ENV=$1 -d spring
echo "------------------------------------------------------>  Starting precompile and migrate ..."
docker-compose run -e RAILS_ENV=$1 --rm app /bin/bash -c "rails assets:precompile && rails db:create && rails db:migrate"

# echo "------------------------------------------------------>  Updating crontab ..."
# docker exec -it  $(docker ps --format='{{.Names}}' | grep "worker") /bin/bash -c "service cron start && whenever --set environment=$1 --update-crontab"

echo "------------------------------------------------------>  Starting rails server ..."
docker-compose run -e RAILS_ENV=$1 -d -p 3000:3000 app rails s

echo -e "\n \n \n                   *************************** Deploy successfully ! *************************** \n \n \n"
