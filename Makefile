include .env

start-container-pg:
	docker run --name postgres-in-black-glory -e POSTGRES_USER=$(POSTGRES_USER) -e POSTGRES_PASSWORD=$(POSTGRES_PASSWORD) -e POSTGRES_DB=$(POSTGRES_DB) -p $(POSTGRES_PORT):5432 -d postgres:latest

db_run:
	docker container start postgres-in-black-glory

docker-compose-up:
	docker-compose up

db:
	docker exec -it postgres-in-black-glory psql -U $(POSTGRES_USER) -d $(POSTGRES_DB)

build-image: 
	docker build -t murakaa-tote-app .

run-docker-compose:
	docker-compose up -d

stop-docker-compose:
	docker-compose down

rebuild:
	docker-compose down && docker-compose build --no-cache ibg-app && docker-compose up

build-app:
	docker-compose build --no-cache ibg-app


.PHONY: migration

migration:
	@read -p "Enter migration name:" migration_name; \
	npx typeorm migration:create src/db/migrations/$$migration_name