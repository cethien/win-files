## Creates a zip of a folder. Useful for e.g. Portable apps
#Requires -Version 5.1

$name = $(Split-Path -Path $pwd -Leaf)
$tmp = "$env:TMP/$name"
$zip = "$env:TMP/$name.zip"
$ignore = "$pwd/.backupignore"
$dest = "gdrive:/backups"

$exclude = @()
if (Test-Path $ignore) {
    $exclude = Get-Content $ignore
}

Write-Host -NoNewline "organizing data for backup... "
if (Test-Path $tmp) {
    Remove-Item $tmp -Recurse -Force
}
mkdir $tmp > $null
Copy-Item -Recurse -Path "$pwd/*" -Destination $tmp

$exclude | ForEach-Object {
    Remove-Item "$tmp/$_" -Recurse -Force
}
Write-Host "done!"

Write-Host -NoNewline "compress and backup... "
compress-archive -force -CompressionLevel Fastest "$tmp/*" "$zip"
rclone sync $zip $dest
Write-Host "done!"

Write-Host -NoNewline "deleting temp folder... "
Remove-Item -r -force $tmp
Write-Host "done!"
