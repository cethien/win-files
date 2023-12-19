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

commitlint:
	@bun commitlint --edit $(msg)

format:
	@gofmt -s -l -w . && \
	bun run format

build:
	@bun build --target=browser views/layouts/index.ts --outfile=public/main.min.js --minify && \
	bun tailwindcss -i views/layouts/styles.css -o ./public/main.min.css --minify && \
	templ generate && \
	go build -o ./dist/app ./cmd/app/

docker:
	@docker build .

dev: export APP_ENV=development
dev: export PORT=9876
dev:
	@bun build --target=browser views/layouts/index.ts --outfile=public/main.js --watch & \
	bun tailwindcss -i views/layouts/styles.css --watch -o ./public/main.css & \
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
