#!/bin/bash

## setup debian in wsl

## stop on WSLENV error
if [ -z "${WSLENV}" ] || [ -z "${USERPROFILE}" ] || [ -z "${POSH_THEMES_PATH}" ]; then
    echo "WSLENV / needed variables from WSLENV could no be loaded. exiting script"
    return
fi

mkdir "$HOME"/.local "$HOME"/.local/bin "$HOME"/.config
export PATH=$PATH:$HOME/.local/bin
BASHRC+=(
    ''
    'export PATH=$PATH:$HOME/.local/bin'
)

ln -s "$USERPROFILE"/.gitconfig "$HOME"/.gitconfig

# install nala
sudo apt update &&
    sudo apt install -y nala

# base requirements
sudo nala install -y \
    git wget apt-transport-https software-properties-common curl zip unzip python3 python3-pip

# some tools / replacemets
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc |
    sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" |
    sudo tee /etc/apt/sources.list.d/gierens.list >/dev/null
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list &&
    PACKAGES+=' eza bat ripgrep neovim' &&
    ln -s "$USERPROFILE"/AppData/Local/nvim "$HOME"/.config/nvim

# github cli
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg |
    sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg &&
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg &&
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] \
https://cli.github.com/packages stable main" |
    sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null &&
    PACKAGES+=' gh'

# powershell
wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb" &&
    sudo dpkg -i packages-microsoft-prod.deb &&
    rm packages-microsoft-prod.deb &&
    PACKAGES+=' powershell' &&
    ln -s "$USERPROFILE"/Documents/PowerShell/ "$HOME"/.config/powershell/

# update distro & install packages
sudo nala update &&
    sudo nala upgrade -y &&
    sudo nala install -y "$PACKAGES"

# bat needs this when installed with apt
ln -s /usr/bin/batcat "$HOME"/.local/bin/bat

# oh my posh / aliae
curl -fsSL https://ohmyposh.dev/install.sh | bash -s -- -d "$HOME"/.local/bin &&
    curl -fsSL https://aliae.dev/install.sh | bash -s -- -d "$HOME"/.local/bin &&
    ln -s "$USERPROFILE"/.aliae.yaml "$HOME"/.aliae.yaml &&
    BASHRC+=(
        ''
        'eval "$(aliae init bash)"'
    )

# setup sdks
for s in "$HOME"/scripts/sdk/**/setup.sh; do
    . "$s"
done

# remove sudo pw prompt
echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/"$USER" >/dev/null

# setup ~/.bashrc
for ((i = 0; i < ${#BASHRC[@]}; i++)); do
    echo "${BASHRC[$i]}" >>"$HOME"/.bashrc
done

sudo reboot
