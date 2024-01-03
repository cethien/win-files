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
    mkdir -p $HOME/.config/nix &&
	echo "experimental-features = nix-command flakes" >> $HOME/.config/nix/nix.conf &&
    . $HOME/.nix-profile/etc/profile.d/nix.sh &&

    rm -f $HOME/.bashrc $HOME/.profile &&
    nix build .config/home-manager#homeConfigurations.cethien.activationPackage &&
    result/activate &&
    home-manager switch

# remove sudo pw prompt
echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/"$USER" >/dev/null

sudo reboot
