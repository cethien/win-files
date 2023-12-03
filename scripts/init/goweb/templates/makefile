ifneq (,$(wildcard ./.env))
include .env
export
endif

.PHONY: default clean install format build docker dev

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

dev: export APP_ENV=development
dev: export PORT=9876
dev:
	air & \
	bun run dev:js & \
	bun run dev:css
