#!/bin/bash

curl -fsSL https://dot.net/v1/dotnet-install.sh | bash -s -- --version latest && \
(
    echo -e "\n" >> "$HOME"/.bashrc &&
    echo 'export DOTNET_ROOT=$HOME/.dotnet"' >> "$HOME"/.bashrc &&
    echo 'export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools' >> "$HOME"/.bashrc
)