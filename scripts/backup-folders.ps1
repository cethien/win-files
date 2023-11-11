param (
    [Parameter(Mandatory)]
    [string[]]
    $Folders
)

$Folders | ForEach-Object -Parallel {
    Set-Location "$env:USERPROFILE/apps/$_" && . "./backup.ps1"
}