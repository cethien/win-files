# Shows navigable menu of all options when hitting Tab
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
# Autocompletion for arrow keys
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

Function Compress-Archive7Zip() {
    [alias("zip")]
    param(
        [string]$Archive,
        [string[]]$Files
    )
    7z a $Archive $File
}

Function Expand-Archive7Zip() {
    [alias("unzip")]
    param(
        [string]$File
    )
    7z x $File
}

aliae init pwsh | Invoke-Expression
