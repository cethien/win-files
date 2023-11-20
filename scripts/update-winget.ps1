$file = "$env:USERPROFILE\.wingetupdate"

$tested = Test-Path $file
if ($tested -eq $false) {
    New-Item $file
    Write-Host "no file found. New file been created. Exiting"
    Exit 0
}

$packages = Get-Content $file
if ($packages.Length -eq 0) {
    Write-Host "no packages found. Exiting"
    Exit 0
}

$results = @{
    updated = @()
}

Write-Host "updating winget packages"
$packages | ForEach-Object -Parallel {
    $package = $PSItem
    $output = winget update $package

    if ($output -like "*No available upgrade found*") {
        Write-Host -ForegroundColor Green -NoNewline "no change:`t"; Write-Host $package
    }
    elseif ($output -like "*No installed package found matching input criteria*") {
        Write-Host -ForegroundColor Orange -NoNewline "not found:`t"; Write-Host $package
    }
    else {
        $($using:results).updated += $package
        Write-Host -ForegroundColor Cyan -NoNewline "updated:`t"; Write-Host $package
    }
}
# summary
if ($results.updated.Length -eq 0) {
    Write-Host -ForegroundColor Green "no packages were updated"
    Exit 0
}

Write-Host "`nsummary:"
$output = $results.updated -join "`n`t"
Write-Host "following packages were updated: "
Write-Host -ForegroundColor Cyan "`t$output"
