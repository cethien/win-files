#!/bin/bash

## setup ubuntu/debian in wsl

# install nala
sudo apt update &&
    sudo apt install -y nala

# update distro
sudo nala update &&
    sudo nala upgrade -y

# nix
curl -L https://nixos.org/nix/install | sh -s -- --no-daemon
source ~/.bashrc && source ~/.profile
nix-env -iA nixpkgs.home-manager

# remove sudo pw prompt
echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/"$USER" >/dev/null

sudo reboot
