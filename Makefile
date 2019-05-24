.PHONY: all

build: down
	# Current user can not access some files, use `ls -la` to check
	sudo docker-compose build

console:
	docker exec -it spring rails c

migrate:
	docker exec -it spring /bin/bash -c "rails db:create && rails db:migrate"

seed:
	docker exec -it spring /bin/bash -c "rails db:migrate:reset && rails db:seed"

routes:
	docker exec -it spring rails routes

dev:
	docker-compose run --rm -p 3000:3000 app rails s -b 0.0.0.0

up:
	docker-compose up -d mysql
	docker-compose up -d spring

down:
	docker-compose down

migrate_dev:
	docker-compose run --rm -p 3000:3000 app /bin/bash -c "rails db:create db:migrate && rails s"

test:
	docker exec -it -e RAILS_ENV=test spring /bin/bash -c "spring rubocop -a app spec lib config db && spring rspec"

rspecs:
	docker exec -it -e RAILS_ENV=test spring spring rspec

rspec:
	docker exec -it -e RAILS_ENV=test spring spring $(MAKECMDGOALS)

rubocop:
	docker exec -it spring rubocop -a app spec lib config db

spring:
	docker exec -it $(MAKECMDGOALS)

doc:
	http-server -o -c-1 ./docs
