#!/bin/bash

## setup ubuntu/debian in wsl

# install nala
sudo apt update &&
    sudo apt install -y nala

# update distro
sudo nala update &&
    sudo nala upgrade -y

# nix + home manager
sh <(curl -fsSL https://nixos.org/nix/install) --no-daemon &&
    mv "$HOME"/.bashrc "$HOME"/.bashrc_default &&
    mv "$HOME"/.profile "$HOME"/.profile_default &&
    . "$HOME"/.nix-profile/etc/profile.d/nix.sh &&
    nix build .config/home-manager#homeConfigurations.cethien.activationPackage &&
    result/activate &&
    home-manager switch &&
    rm -rf result

# remove sudo pw prompt
echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/"$USER" >/dev/null

sudo reboot
