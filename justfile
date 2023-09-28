alias u := update
alias i := install
alias in := install-noupdate

set windows-powershell := true

[private]
default:
	@just --list

# update your apps
update:
	. "$env:USERPROFILE/scripts/update.ps1"

# install without adding to update file
install-noupdate PACKAGE:
	winget install --source winget --id {{PACKAGE}};

# install a package via winget
install PACKAGE:
	@just install-noupdate {{PACKAGE}}
	echo "{{PACKAGE}}\n" >> .wingetupdate