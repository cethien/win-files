# Shows navigable menu of all options when hitting Tab
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
# Autocompletion for arrow keys
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

# env
$env:Path += ";$env:ProgramFiles\7-Zip"

# Aliases
set-alias vim nvim
set-alias vi nvim

Function 7zipA { 7z a }
set-alias zip 7zipA
Function 7zipX { 7z x }
set-alias unzip 7zipX

aliae init pwsh | Invoke-Expression