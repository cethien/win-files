ifneq (,$(wildcard ./.env))
include .env
export
endif

.PHONY: default clean install format \
	build docker \
	dev

default: clean install

clean:
	rm -rf dist/ node_modules/ public/css/ public/js/

install:
	go mod tidy && \
	go get -v ./... && \
	bun install

format:
	gofmt -s -l -w ./ && \
	bun run format

build:
	bun run build && \
	go build -o ./dist/app -v ./cmd/app/...

docker:
	docker build .

export GOOSE_DRIVER=sqlite3
export GOOSE_DBSTRING=${DB_URL}

migrate-create:
	goose -dir ./migrations create $(name) sql

migrate-up:
	goose -dir ./migrations up-by-one

migrate-down:
	goose -dir ./migrations down

migrate-redo:
	goose -dir ./migrations redo

dev: export APP_ENV=development
dev: export PORT=9876
dev:
	air & \
	bun run dev:js & \
	bun run dev:css
