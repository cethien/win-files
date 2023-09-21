alias u := update
alias r := reload
set shell := ["pwsh.exe", "-NoProfile", "-c"]

update:
	~/scripts/update.ps1

reload:
	$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User"); & $profile
