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

Function 7zipA($file) { 7z a $file  }
set-alias zip 7zipA
Function 7zipX($file) { 7z x $file }
set-alias unzip 7zipX

aliae init pwsh | Invoke-Expression
