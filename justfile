alias u := update
alias r := reload

set shell := ["bash", "-c"]

[private]
default:
	@just --list

# update your packages
update:
	sudo nala update && sudo nala upgrade -y

# reloads the terminal profile
reload:
	source ~/.bashrc
