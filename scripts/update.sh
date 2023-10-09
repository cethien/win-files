#!/bin/bash

sudo nala update && \
sudo nala upgrade -y && \
curl -fsSL https://ohmyposh.dev/install.sh | bash -s -- -d $HOME/.local/bin && \
curl -fsSL https://aliae.dev/install.sh | bash -s -- -d $HOME/.local/bin