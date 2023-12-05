$cliArgs = $args -split " "

if ($cliArgs[0].Length -eq 0) {
    . "$env:USERPROFILE\scripts\update-winget.ps1"
    exit 0
}

if ($cliArgs[0] -eq "spotify") {
    . "$env:USERPROFILE\scripts\update-spotify.ps1"
    exit 0
}