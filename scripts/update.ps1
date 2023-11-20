$actions = @()

$actions += '. "$env:USERPROFILE/scripts/update-winget.ps1"'
$actions += '. "$env:USERPROFILE/scripts/update-spicetify.ps1"'

$actions | Foreach-Object -ThrottleLimit 5 -Parallel {
    $a = $PSItem
    $a | Invoke-Expression
}
