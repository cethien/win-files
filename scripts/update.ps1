$cliArgs = $args -split " "

if ($cliArgs[0].Length -eq 0) {
    . "$env:USERPROFILE\scripts\update-winget.ps1"
    exit 0
}