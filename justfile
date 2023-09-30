alias u := update
alias r := reload
alias i := install
alias in := install-noupdate
alias rm := remove

set shell := ["pwsh", "-NoProfile", "-ExecutionPolicy", "Unrestricted", "-Command"]

ufile := "$env:USERPROFILE" / ".wingetupdate"

[private]
@default:
	just --list

# reload profile
@reload:
	& $PROFILE

# update your apps
@update:
	. "$env:USERPROFILE/scripts/update.ps1"

# install without adding to update file
@install-noupdate PACKAGE:
	winget install --source winget -q {{PACKAGE}}

# install a package via winget
@install PACKAGE:
	just install-noupdate {{PACKAGE}}
	"{{PACKAGE}}" >> {{ufile}}
	Set-Content -Path {{ufile}} -Value $(Get-Content {{ufile}}).Trim()

# removes a winget package
@remove PACKAGE:
	winget remove --id {{PACKAGE}}
	Set-Content -Path {{ufile}} -Value (Get-Content -Path {{ufile}} | Select-String -Pattern {{PACKAGE}} -NotMatch)
	Set-Content -Path {{ufile}} -Value $(Get-Content {{ufile}}).Trim()
