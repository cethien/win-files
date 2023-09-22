function ExecuteWingetUpdate {
    $results = @{
        Latest  = @()
        Missing = @()
        Updated = @()
    }

    $file = "$env:USERPROFILE\.wingetupdate"

    $tested = Test-Path $file
    if ($tested -eq $false) {
        New-Item $file
    }

    $packages = Get-Content $file
    if ($packages.Length -gt 0) {
        $packages | ForEach-Object {
            $package = $_

            $output = winget update $package

            if ($output -like "*No available upgrade found*") {
                $results.Latest += $package
                Write-Host -NoNewline "skipped:`t"
                Write-Host -ForegroundColor Cyan $package
            }
            elseif ($output -like "*No installed package found matching input criteria*") {
                $results.Missing += $package
                Write-Host -NoNewline "missing:`t"
                Write-Host -ForegroundColor Red $package
            }
            else {
                $results.Updated += $package
                Write-Host -NoNewline "updated:`t"
                Write-Host -ForegroundColor Green $package
            }
        }
    }
    else {
        Write-Host -NoNewline "no packages defined in "
        Write-Host -ForegroundColor Cyan $file
    }

    # summary
    Write-Host "`nsummary:"
    if ($results.Updated.Length -gt 0) {
        $output = $results.Updated -join "`n`t"
        Write-Host "following packages were updated: "
        Write-Host -ForegroundColor Green "`t$output"
    }
    else {
        Write-Host "no packages were updated"
    }

    if ($results.Latest.Length -gt 0) {
        $output = $results.Latest -join "`n`t"
        Write-Host "`nfollowing packages were already on the latest version:"
        Write-Host -ForegroundColor Cyan "`t$output"
    }


    if ($results.Missing.Length -gt 0) {
        $output = $results.Missing -join "`n`t"
        Write-Host "`nfollowing packages were not found:"
        Write-Host -ForegroundColor Red "`t$output"
    }
}

Write-Host -ForegroundColor DarkMagenta ">> FETCH PROFILE FROM REMOTE:"
git fetch && git pull

Write-Host -ForegroundColor DarkMagenta ">> UPDATE APPS VIA WINGET:"
ExecuteWingetUpdate

Write-Host -ForegroundColor DarkMagenta ">> UPDATE SPICETIFY:"
spicetify upgrade backup apply

Write-Host "Done. Press any key to exit"
Read-Host
