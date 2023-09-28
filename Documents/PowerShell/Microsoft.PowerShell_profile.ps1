# Shows navigable menu of all options when hitting Tab
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
# Autocompletion for arrow keys
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

Function Compress-ArchiveNanaZip() {
    [alias("zip")]
    param(
        [string]$Archive,
        [string[]]$Files
    )
    nanazip a $Archive $File
}

Function Expand-ArchiveNanaZip() {
    [alias("unzip")]
    param(
        [string]$File
    )
    nanazip x $File
}

aliae init pwsh | Invoke-Expression
