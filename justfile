alias u := update
alias r := reload
alias s := sync

set shell := ["pwsh.exe", "-NoProfile", "-c"]

# update machine via script
update:
	. "$env:USERPROFILE/scripts/update.ps1"

# reloads env + profile
reload:
	$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User"); & $profile

# sync home directory with remote
sync:
	git fetch && git pull
