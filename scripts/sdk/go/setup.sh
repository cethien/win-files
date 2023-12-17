#!/bin/bash

(
    cd "$HOME" &&
    curl -fsSL https://s.id/golang-linux | bash -s &&
    rm -rf go*.tar.gz) && \
(
    export GOROOT="$HOME/go" &&
    export GOPATH="$HOME/go/packages" &&
    export PATH=$PATH:$GOROOT/bin:$GOPATH/bin) && \
(
    go install golang.org/x/tools/gopls@latest &&
    go install honnef.co/go/tools/cmd/staticcheck@latest &&
    go install github.com/go-delve/delve/cmd/dlv@latest &&
    go install github.com/ramya-rao-a/go-outline@latest &&
    go install github.com/josharian/impl@latest &&
    go install github.com/bokwoon95/wgo@latest &&
    go install -tags 'postgres' github.com/golang-migrate/migrate/v4/cmd/migrate@latest &&
    go install -tags 'sqlite' github.com/golang-migrate/migrate/v4/cmd/migrate@latest) && \
(
    go install github.com/spf13/cobra-cli@latest &&
    go install github.com/gohugoio/hugo@latest) && \
(
    echo -e "\n" >> "$HOME"/.bashrc &&
    echo 'export GOROOT="$HOME/go"' >> "$HOME"/.bashrc &&
    echo 'export GOPATH="$HOME/go/packages"' >> "$HOME"/.bashrc &&
    echo 'export PATH=$PATH:$GOROOT/bin:$GOPATH/bin' >> "$HOME"/.bashrc
    )

