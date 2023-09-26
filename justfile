alias u := update
alias r := reload
alias s := sync

set shell := ["pwsh.exe", "-NoLogo", "-NoProfile", "-Command"]

[private]
default:
	@just --list

# update your stuff
update:
	. "$env:USERPROFILE/scripts/update.ps1"

# reloads env + profile
reload:
	$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User"); & $profile

# sync home directory with remote
sync:
	git push -u origin main && git fetch && git pull
