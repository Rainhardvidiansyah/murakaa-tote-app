include .env

.DEFAULT_GOAL := help

.PHONY: help start-container-pg db_run docker-compose-up db build-image run-docker-compose stop-docker-compose rebuild build-app migration



help:
	@echo "=================================================================="
	@echo " PERINTAH MAKEFILE YANG TERSEDIA"
	@echo "=================================================================="
	@echo " make start-container-pg  - Membuat & menjalankan container Postgres baru pertama kali"
	@echo " make db_run              - Menjalankan kembali container Postgres yang sudah mati"
	@echo " make docker-compose-up   - Menjalankan docker-compose di foreground (log terlihat)"
	@echo " make db                  - Masuk ke terminal database Postgres (CLI psql)"
	@echo " make build-image         - Membangun Docker image 'murakaa-tote-app'"
	@echo " make run-docker-compose  - Menjalankan docker-compose di background (mode -d)"
	@echo " make stop-docker-compose - Menghentikan dan menghapus container dari docker-compose"
	@echo " make rebuild             - Mematikan, build ulang tanpa cache, lalu jalankan app"
	@echo " make build-app           - Build ulang container app saja tanpa cache"
	@echo " make migration           - Membuat file migration TypeORM baru (akan ditanya namanya)"
	@echo "=================================================================="

start-container-pg:
	docker run --name postgres-murakaa-tote -e POSTGRES_USER=$(POSTGRES_USER) -e POSTGRES_PASSWORD=$(POSTGRES_PASSWORD) -e POSTGRES_DB=$(POSTGRES_DB) -p $(POSTGRES_PORT):5432 -d postgres:latest

db_run:
	docker container start postgres-murakaa-tote

docker-compose-up:
	docker-compose up

db:
	docker exec -it postgres-murakaa-tote psql -U $(POSTGRES_USER) -d $(POSTGRES_DB)

build-image: 
	docker build -t murakaa-tote-app .

run-docker-compose:
	docker-compose up -d

stop-docker-compose:
	docker-compose down

rebuild:
	docker-compose down && docker-compose build --no-cache murakaa-tote-app && docker-compose up

build-app:
	docker-compose build --no-cache murakaa-tote-app


.PHONY: migration

migration:
	@read -p "Enter migration name:" migration_name; \
	npx typeorm migration:create src/db/migrations/$$migration_name