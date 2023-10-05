#!/bin/bash

## install script to setup a debian(-based) distro

printf '\n' >> $HOME/.bashrc

mkdir $HOME/.local $HOME/.local/bin $HOME/.config
export PATH=$PATH:$HOME/.local/bin
printf 'export PATH=$PATH:$HOME/.local/bin
\n' >> $HOME/.bashrc

# install nala
sudo apt update && \
sudo apt install -y nala

# base requirements
sudo nala install -y \
    git wget apt-transport-https software-properties-common curl zip unzip python3 python3-pip

# some tools / replacemets
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | \
sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | \
sudo tee /etc/apt/sources.list.d/gierens.list > /dev/null
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
PACKAGES+=' eza bat ripgrep neovim'

# just command runner
wget -qO - 'https://proget.makedeb.org/debian-feeds/prebuilt-mpr.pub' | \
gpg --dearmor | sudo tee /usr/share/keyrings/prebuilt-mpr-archive-keyring.gpg > /dev/null && \
echo \
"deb [arch=all,$(dpkg --print-architecture) signed-by=/usr/share/keyrings/prebuilt-mpr-archive-keyring.gpg] \
https://proget.makedeb.org prebuilt-mpr $(lsb_release -cs)" | \
sudo tee /etc/apt/sources.list.d/prebuilt-mpr.list  > /dev/null && \
PACKAGES+=' just'

# github cli
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] \
https://cli.github.com/packages stable main" | \
sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
PACKAGES+=' gh'

# powershell
wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb" && \
sudo dpkg -i packages-microsoft-prod.deb && \
rm packages-microsoft-prod.deb && \
PACKAGES+=' powershell'

# update distro & install packages
sudo nala update && \
sudo nala upgrade -y && \
sudo nala install -y $PACKAGES

# oh my posh / aliae
curl -fsSL https://ohmyposh.dev/install.sh | bash -s -- -d $HOME/.local/bin && \
curl -fsSL https://aliae.dev/install.sh | bash -s -- -d $HOME/.local/bin

# node, yarn, pnpm, bun
curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash -s && \
printf '\n' >> $HOME/.bashrc && \
export NVM_DIR="$HOME/.nvm" && \
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" && \
nvm install node --lts && \
corepack enable && \
pnpm setup && \
export PNPM_HOME="/home/cethien/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac && \
pnpm install -g bun

# go
curl -fsSL https://s.id/golang-linux | bash -s && \
rm -rf go*.tar.gz && \
printf '\n
export GOROOT="$HOME/go"
export GOPATH="$HOME/go/packages"
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
\n' >> $HOME/.bashrc && \
export GOROOT="$HOME/go" && \
export GOPATH="$HOME/go/packages" && \
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin && \
go install -v golang.org/x/tools/gopls@latest && \
go install -v github.com/ramya-rao-a/go-outline@latest && \
go install -v github.com/go-delve/delve/cmd/dlv@latest && \
go install -v honnef.co/go/tools/cmd/staticcheck@latest

# dotnet
curl -fsSL https://dot.net/v1/dotnet-install.sh | bash -s -- --channel STS && \
curl -fsSL https://dot.net/v1/dotnet-install.sh | bash -s -- --channel LTS && \
printf 'export DOTNET_ROOT=$HOME/.dotnet
export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools
\n' >> $HOME/.bashrc

if [[ "$(< /proc/sys/kernel/osrelease)" == *WSL* ]]; then
    # wsl
    echo 'wsl setup'
    WIN_USER_DIR=/mnt/c/Users/$(cmd.exe /c "echo %USERNAME%" | sed -e 's/\r//g') && \

    ln -s $WIN_USER_DIR/.gitconfig $HOME/.gitconfig && \

    POSH_THEMES_PATH="$WIN_USER_DIR/AppData/Local/Programs/oh-my-posh/themes" && \
    ln -s $WIN_USER_DIR/.aliae.yaml $HOME/.aliae.yaml

    mkdir $HOME/.ssh && \
    cp $WIN_USER_DIR/.ssh/id_* $HOME/.ssh && \
    chmod 700 $HOME/.ssh && \
    chmod 600 $HOME/.ssh/id_* && \
    chmod 644 $HOME/.ssh/id_*.pub && \
    ln -s $WIN_USER_DIR/.ssh/known_hosts $HOME/.ssh/known_hosts

    ln -s $WIN_USER_DIR/Documents/PowerShell/ $HOME/.config/powershell/

    ln -s $WIN_USER_DIR/AppData/Local/nvim $HOME/.config/nvim

    # remove sudo pw prompt
    echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$USER > /dev/null
    continue
else
    # native Linux
    echo 'linux setup'

    ssh-keygen -q -b 2048 -t ed25519 -f $HOME/.ssh/id_ed25519 -N '' -q

    git config --global user.name $USER && \
    git config --global core.eol lf && \
    git config --global init.defaultBranch main && \
    git config --global core.autocrlf input && \
    git config --global alias.ignore = "!gi() { curl -sL https://www.toptal.com/developers/gitignore/api/$@ ;}; gi"

    POSH_THEMES_PATH=$HOME/.cache/oh-my-posh/themes
    continue
fi

# bat needs this when installed with apt
ln -s /usr/bin/batcat ~/.local/bin/bat

printf "export POSH_THEMES_PATH=\"$POSH_THEMES_PATH\"
\n" >> $HOME/.bashrc
printf 'eval "$(aliae init bash)"
\n' >> $HOME/.bashrc

git init
git remote add origin https://github.com/cethien/ubuntu-home.git
git fetch
git reset --hard origin/main
git pull origin main

sudo reboot