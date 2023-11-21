alias r := reload
alias u := update
alias ug := update-go
alias ud := update-dotnet

set shell := ["bash", "-c"]

[private]
@default:
	just --list

# update your packages
@update:
	$HOME/scripts/update.sh

# update go
@update-go:
	$HOME/scripts/update-go.sh

# update dotnet
@update-dotnet:
	$HOME/scripts/update-dotnet.sh

# reloads the terminal profile
@reload:
	source ~/.bashrc
