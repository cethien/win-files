#!/bin/bash

sudo nala update &&
    sudo nala upgrade -y &&
    sudo nala autoremove -y

nix-channel --update
(cd "$HOME"/.config/home-manager && nix flake update)
