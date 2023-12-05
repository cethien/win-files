# build
FROM golang:1-bullseye as builder
RUN apt-get update && apt-get install -y git curl unzip make && \
    curl -fsSL https://bun.sh/install | bash -s
WORKDIR /src
COPY . .
RUN . /root/.bashrc && make clean install build

# runner
FROM busybox:latest as runner
WORKDIR /app
COPY --from=builder /src/dist/ ./
COPY --from=builder /src/public ./public

ENTRYPOINT /app/app
LABEL Name=example.com/template Version=alpha-0.0.0
EXPOSE 80
