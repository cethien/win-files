alias u := update
alias r := reload

set windows-powershell := true

[private]
default:
	@just --list

# update your apps
update:
	. "$env:USERPROFILE/scripts/update.ps1"

# reloads env + profile
reload:
	$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User"); & $profile

# pushes commited changes to remote
push:
	git push -u origin main

# gets latest home directory
pull:
	git pull
