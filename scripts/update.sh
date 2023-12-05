#!/bin/bash

COMMAND=$1
ARG=$2

if [ -z "$COMMAND" ]; then
    sudo nala update && \
    sudo nala upgrade -y && \
    curl -fsSL https://ohmyposh.dev/install.sh | bash -s -- -d "$HOME"/.local/bin && \
    curl -fsSL https://aliae.dev/install.sh | bash -s -- -d "$HOME"/.local/bin
    return
fi

if [[ $COMMAND == "sdk" ]]; then
    SDK=$ARG

    if [[ -z $SDK ]]; then
        for s in "$HOME"/scripts/sdk/**/*.sh; do
            . "$s"
        done
        return
    fi

    . "$HOME"/scripts/sdk/"$SDK"/update.sh
    return
fi

