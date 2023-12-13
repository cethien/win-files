#Requires -Version 5.1

param (
    [Parameter(HelpMessage = "profiles")]
    [string[]]$Profiles
)

$actions = $(Get-Content "$PSScriptRoot/setup.json" | ConvertFrom-Json).actions |
Where-Object {
    $($_.Profile -eq $null) -or $($Profiles -match $_.Profile)
}

$actions | Foreach-Object {
    $a = $PSItem

    if ($a.PreScript) {
        $a.PreScript | Invoke-Expression
    }

    if ($a.WingetPackage) {
        $cmd = "winget install --accept-source-agreements --accept-package-agreements --source winget --Package $($a.WingetPackage)"
        if ($a.WingetFlags) {
            $cmd += " $($a.WingetFlags)"
        }

        if ($a.DontIncludeUpdate -eq $null) {
            Add-Content $env:USERPROFILE/.wingetupdate "$($a.WingetPackage)`n"
        }
        $cmd | Invoke-Expression
    }

    if ($a.Script) {
        $a.Script | Invoke-Expression
    }

    Write-Output "`n"
}