#Requires -Version 5.1

param (
    [Parameter(HelpMessage = "profiles")]
    [string[]]$Profiles
)

$config = Get-Content "$PSScriptRoot/setup.json" | ConvertFrom-Json

$config.actions | ForEach-Object {
    $_.prepare_script | ForEach-Object { Invoke-Expression $_ }

    Invoke-Expression $_.script

    $_.winget_packages | ForEach-Object {
        $cmd = "winget install --accept-source-agreements --accept-package-agreements --source winget --Id $($_.id) $($_.install_flags -join " ")"
        $cmd | Invoke-Expression

        if ($_.exclude_from_updatefile -ne $true) {
            Add-Content $env:USERPROFILE/.wingetupdate "$($_.id)`n"
        }
    }

    $_.pwsh_modules | ForEach-Object {
        Install-Module $_
    }

    Invoke-Expression $_.post_install_script
}