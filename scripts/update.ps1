Write-Host -ForegroundColor DarkMagenta ">> FETCH PROFILE FROM REMOTE:"
git fetch && git pull

Write-Host -ForegroundColor DarkMagenta ">> UPDATE APPS VIA WINGET:"
. "$env:USERPROFILE/scripts/update-winget.ps1"

Write-Host -ForegroundColor DarkMagenta ">> UPDATE SPICETIFY:"
. "$env:USERPROFILE/scripts/update-spicetify.ps1"
