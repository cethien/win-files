#!/bin/bash

## setup debian in wsl
## setup via WSLENV (https://devblogs.microsoft.com/commandline/share-environment-vars-between-wsl-and-windows/)
WIN_USER_DIR=$USERPROFILE

mkdir $HOME/.local $HOME/.local/bin $HOME/.config
export PATH=$PATH:$HOME/.local/bin
BASHRC+=('export PATH=$PATH:$HOME/.local/bin')

ln -s $WIN_USER_DIR/.gitconfig $HOME/.gitconfig

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
    ln -s $WIN_USER_DIR/AppData/Local/nvim $HOME/.config/nvim

# just command runner
wget -qO - 'https://proget.makedeb.org/debian-feeds/prebuilt-mpr.pub' |
    gpg --dearmor | sudo tee /usr/share/keyrings/prebuilt-mpr-archive-keyring.gpg >/dev/null &&
    echo \
        "deb [arch=all,$(dpkg --print-architecture) signed-by=/usr/share/keyrings/prebuilt-mpr-archive-keyring.gpg] \
https://proget.makedeb.org prebuilt-mpr $(lsb_release -cs)" |
    sudo tee /etc/apt/sources.list.d/prebuilt-mpr.list >/dev/null &&
    PACKAGES+=' just'

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
    PACKAGES+=' powershell'
ln -s $WIN_USER_DIR/Documents/PowerShell/ $HOME/.config/powershell/

# update distro & install packages
sudo nala update &&
    sudo nala upgrade -y &&
    sudo nala install -y $PACKAGES

# bat needs this when installed with apt
ln -s /usr/bin/batcat $HOME/.local/bin/bat

# oh my posh / aliae
curl -fsSL https://ohmyposh.dev/install.sh | bash -s -- -d $HOME/.local/bin &&
    curl -fsSL https://aliae.dev/install.sh | bash -s -- -d $HOME/.local/bin &&
    POSH_THEMES_PATH="$WIN_USER_DIR/AppData/Local/Programs/oh-my-posh/themes" &&
    ln -s $WIN_USER_DIR/.aliae.yaml $HOME/.aliae.yaml &&
    BASHRC+=(
        "export POSH_THEMES_PATH="$POSH_THEMES_PATH""
        'eval "$(aliae init bash)"'
    )

# node
N_PREFIX=$HOME/.local/n
curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n | bash -s lts &&
    npm install -g n &&
    n latest &&
    corepack enable

# go
GO_TOOLS=(
    'golang.org/x/tools/gopls@latest'
    'github.com/ramya-rao-a/go-outline@latest'
    'github.com/go-delve/delve/cmd/dlv@latest'
    'honnef.co/go/tools/cmd/staticcheck@latest'
)

curl -fsSL https://s.id/golang-linux | bash -s &&
    rm -rf go*.tar.gz &&
    export GOROOT="$HOME/go" &&
    export GOPATH="$HOME/go/packages" &&
    export PATH=$PATH:$GOROOT/bin:$GOPATH/bin &&
    (
        for tool in ${GO_TOOLS[@]}; do
            go install $tool
        done
    ) &&
    BASHRC+=(
        'export GOROOT="$HOME/go"'
        'export GOPATH="$HOME/go/packages"'
        'export PATH=$PATH:$GOROOT/bin:$GOPATH/bin'
    )

# dotnet
curl -fsSL https://dot.net/v1/dotnet-install.sh | bash -s -- --channel STS &&
    curl -fsSL https://dot.net/v1/dotnet-install.sh | bash -s -- --channel LTS &&
    BASHRC+=(
        'export DOTNET_ROOT=$HOME/.dotnet'
        'export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools'
    )

# remove sudo pw prompt
echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$USER >/dev/null

# setup ~/.bashrc
echo "/n" >>$HOME/.bashrc
for ((i = 0; i < ${#BASHRC[@]}; i++)); do
    echo "${BASHRC[$i]}" >>$HOME/.bashrc
done

sudo reboot
