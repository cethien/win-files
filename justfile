alias u := update
alias r := reload
alias ug := update-go

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

# reloads the terminal profile
@reload:
	source ~/.bashrc
