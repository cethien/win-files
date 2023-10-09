alias u := update
alias r := reload

set shell := ["bash", "-c"]

[private]
@default:
	just --list

# update your packages
@update:
	$HOME/scripts/update.sh

# reloads the terminal profile
@reload:
	source ~/.bashrc
