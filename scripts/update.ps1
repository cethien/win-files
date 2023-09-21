function RunUpdate {
    $ret = @{
        Latest  = @()
        Missing = @()
        Updated = @()
    }

    Get-Content ~/.wingetupdate | % {
        $id = $_

        $output = winget update $id

        if ($output -like "*No available upgrade found*") {
            $ret.Latest += $id
        }
        elseif ($output -like "*No installed package found matching input criteria*") {
            $ret.Missing += $id
        }
        else {
            $output
            $ret.Updated += $id
        }
    }

    return $ret
}

Write-Host -ForegroundColor DarkMagenta ">> UPDATE APPS VIA WINGET:"
$results = RunUpdate

if ($results.Updated.Length -gt 0) {
    $output = $results.Updated -join "`n`t"
    Write-Host "Following Packages were updated: "
    Write-Host -ForegroundColor Green "`t$output"
}
else {
    Write-Host "No Packages were updated"
}

if ($results.Latest.Length -gt 0) {
    $output = $results.Latest -join "`n`t"
    Write-Host "Following Packages were already on the latest version:"
    Write-Host -ForegroundColor Cyan "`t$output"
}

if ($results.Missing.Length -gt 0) {
    $output = $results.Missing -join "`n`t"
    Write-Host "Following Packages were not found:"
    Write-Host -ForegroundColor Red "`t$output"
}

Write-Host -ForegroundColor DarkMagenta ">> UPDATE SPICETIFY:"
spicetify upgrade backup apply

Write-Host "Done. Press any key to exit"
Read-Host
