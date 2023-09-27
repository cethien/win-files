alias u := update
alias r := reload
alias i := install
alias iau := install-autoupdate

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

# install via winget
install PACKAGE:
	winget install --source winget --id {{PACKAGE}};

# add to update file (~/.wingetupdate)
add-to-update PACKAGE:
	echo "{{PACKAGE}}\n" >> .wingetupdate

# install + add to update file
install-autoupdate PACKAGE:
	@just install {{PACKAGE}}
	@just add-to-autoupdate {{PACKAGE}}
