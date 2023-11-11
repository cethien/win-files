## Creates a zip of a folder. Useful for e.g. Portable apps

# $env:BACKUP is a custom set variable
if (!(Test-Path -Path Env:BACKUP)) {
    Write-Error 'env variable "BACKUP" not set. exiting'
    Exit 1
}

$backup = "$env:BACKUP"
$name = $(Split-Path -Path $pwd -Leaf)
$tmp = "$env:TMP\$name"

$ignore = ""
if (Test-Path $pwd\.backupignore) {
    $ignore = Get-Content $pwd\.backupignore
}

Write-Host -NoNewline "organizing data for backup... "
if (Test-Path $tmp) {
    Remove-Item $tmp -Recurse -Force
}
mkdir $tmp > $null
Copy-Item -r -force "./*" $tmp

if ($ignore -ne "") {
    $ignore | ForEach-Object { Remove-Item "$tmp/$_" -Recurse -Force -ErrorAction SilentlyContinue }
}

Write-Host "done!"

Write-Host -NoNewline "creating archive... "
compress-archive -force "$tmp/*" "$backup/$name.zip"
Write-Host "done!"

Write-Host -NoNewline "deleting temp folder... "
Remove-Item -r -force $tmp
Write-Host "done!"
