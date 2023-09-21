alias u := update
alias r := reload
set shell := ["pwsh.exe", "-c"]

update:
	Get-Content ~/.wingetupdate | % { winget update $_ > $null }

reload:
	$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User"); & $profile
