ifneq (,$(wildcard ./.env))
include .env
export
endif

.PHONY: default clean pre-build install update format \
	build docker \
	migrate-create migrate-up migrate-down \
	dev

default: clean install

setup: clean install update format

clean:
	@rm -rf dist/ node_modules/ public/**/*.js public/**/*.css templates/**/*_templ.go

install:
	@templ generate && \
	go get -v ./... && \
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
	go build -o ./dist/app -v ./cmd/app/...

docker:
	@docker build .

migrate-create:
	@migrate create -dir sqlite/migrations -ext sql $(name)

migrate: export DB_URL=sqlite://data.db

migrate-up: migrate
	@migrate -path sqlite/migrations -database ${DB_URL} up 1

migrate-down: migrate
	@migrate -path sqlite/migrations -database ${DB_URL} down 1

dev: export APP_ENV=development
dev: export PORT=9876
dev:
	@bun run dev & \
	templ generate -watch & \
	wgo run ./cmd/app/main.go
