#Requires -Version 5.1
#Requires -Modules PSToml

param (
    [Parameter(HelpMessage = "profiles")]
    [string[]]$Profiles
)

$actions = $(Get-Content "./setup.toml" | ConvertFrom-Toml).actions |
Where-Object {
    $($_.Profile -eq $null) -or $($Profiles -match $_.Profile)
}

$actions | Foreach-Object -ThrottleLimit 10 -Parallel {
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
        Write-Output $cmd
    }

    if ($a.Script) {
        $a.Script | Invoke-Expression
    }

    Write-Output "`n"
}