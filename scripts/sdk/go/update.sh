#!/bin/bash

CURRENT_GO_VERISON="$(go version | cut -d " " -f 3)"
LATEST_GO_VERSION="$(curl --silent https://go.dev/VERSION?m=text | head -n 1)"

if [[ "${CURRENT_GO_VERISON}" == "${LATEST_GO_VERSION}" ]]; then
    echo "go is up to date"
    return
fi

(cd "$HOME" && \
curl -fsSL https://s.id/golang-linux | bash -s && \
rm -rf go*.tar.gz)
