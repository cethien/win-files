$cliArgs = $args -split " "

if ($cliArgs[0].Length -eq 0) {
    "package not provided"
    exit 0
}

$package = $cliArgs[0]
winget install --source winget --id $package && "`n$package" >> $HOME/.wingetupdate