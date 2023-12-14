ifneq (,$(wildcard ./.env))
include .env
export
endif

.PHONY: default setup clean update \
	format \
	build docker \
	dev \
	db-up db-down migrate-create migrate-up migrate-down

default: clean format

setup: clean update format

clean:
	@rm -rf dist/ node_modules/ \
	public/*.js public/*.css \
	views/**/*_templ.go && \
	templ generate && \
	go mod tidy && \
	bun install

update:
	@go get -u ./... & \
	bun update

format:
	@gofmt -s -l -w ./ && \
	bun run format

build:
	@bun run build && \
	templ generate && \
	go build -o ./dist/app ./cmd/app/

docker:
	@docker build .

dev: export APP_ENV=development
dev: export PORT=9876
dev:
	@bun run dev & \
	templ generate -watch & \
	wgo run ./cmd/app/main.go

db-up:
	@docker compose -f docker-compose.yml up -d

db-down:
	@docker compose -f docker-compose.yml down

migrate-create:
	@migrate create -dir ./postgres/migrations -ext sql $(name)

migrate-up:
	@migrate -path ./postgres/migrations -database ${DB_URL} up 1

migrate-down:
	@migrate -path ./postgres/migrations -database ${DB_URL} down 1
