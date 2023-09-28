param (
    [Parameter(HelpMessage = "customization stuff")]
    [switch]$Customizing,

    [Parameter(HelpMessage = "some stuff on a personal desktop")]
    [switch]$Personal,

    [Parameter(HelpMessage = "generate a new ssh key. uses ssh-keygen")]
    [switch]$Ssh,

    [Parameter(HelpMessage = "development stuff")]
    [switch]$Development,

    [Parameter(HelpMessage = "games & launchers")]
    [switch]$Gaming,

    [Parameter(HelpMessage = "streaming stuff")]
    [switch]$Streaming
)

function WingetInstall {
    param (
        # add winget id here
        [Parameter(Mandatory)]
        [string]$ItemId,

        # tell, if the installation should be interactive
        # dafault: false
        [switch]$Interactive,

        # do not include in update file for "just update"
        # dafault: false
        [switch]$DontIncludeUpdate
    )

    $cmd = "winget install --accept-source-agreements --accept-package-agreements --source winget --id $ItemId"

    if ($Interactive -eq $true) {
        $cmd += " --interactive"
    }

    if ($DontIncludeUpdate -eq $false) {
        Add-Content $env:USERPROFILE/.wingetupdate "$ItemId`n"
    }

    Invoke-Expression $cmd
}

function ReloadEnv {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}

# remove curl alias ­ƒñí
Remove-Item alias:curl

# windows settings
# dark mode ­ƒîÖ
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -Value 0

# task bar
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search -Name SearchBoxTaskbarMode -Value 0 -Type DWord -Force
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds -Name ShellFeedsTaskbarOpenOnHover -Value 0 -Type DWord -Force
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name Hidden -Value 1 -Type DWord -Force
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideIcons -Value 1 -Type DWord -Force
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name OnboardUnpinCortana -Value 1 -Type DWord -Force
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowCortanaButton -Value 0 -Type DWord -Force


# some tools
WingetInstall -ItemId Microsoft.WindowsTerminal

WingetInstall -ItemId Git.Git
WingetInstall -ItemId casey.just
WingetInstall -ItemId Microsoft.PowerToys
WingetInstall -ItemId GeekUninstaller.GeekUninstaller
WingetInstall -ItemId 7zip.7zip
WingetInstall -ItemId Microsoft.PowerShell
WingetInstall -ItemId Neovim.Neovim

if ($Customizing) {
    # oh-my-posh
    WingetInstall -ItemId JanDeDobbeleer.OhMyPosh
    WingetInstall -ItemId JanDeDobbeleer.Aliae
    WingetInstall -ItemId chrisant996.Clink

    oh-my-posh font install CodeNewRoman --user
    oh-my-posh font install FiraCode --user

    WingetInstall -ItemId Rainmeter.Rainmeter
    $repo = "Jax-Core/jax-core.github.io"
    $file = "JaxCoreSetup.bat"
    curl -LO "https://github.com/$repo/releases/latest/download/$file"
    Invoke-Expression $file
    Remove-Item -Recurse -Force $file
}

WingetInstall -ItemId -DontIncludeUpdate Google.Chrome

# spotify
WingetInstall -ItemId -DontIncludeUpdate Spotify.Spotify
WingetInstall -ItemId -DontIncludeUpdate Spicetify.Spicetify
ReloadEnv
spicetify config extensions webnowplaying.js
spicetify config custom_apps new-releases
spicetify backup apply

if ($Personal) {
    WingetInstall -ItemId -DontIncludeUpdate Discord.Discord

    WingetInstall -ItemId Google.Drive

    WingetInstall -ItemId Logitech.GHUB
    WingetInstall -ItemId Nvidia.GeForceExperience
    WingetInstall -ItemId Nvidia.Broadcast
}

ssh-keygen -q -b 2048 -t ed25519 -f $env:USERPROFILE/.ssh/id_ed25519 -N '' -q

if ($Development) {
    WingetInstall -Interactive -ItemId Microsoft.VisualStudioCode
    wsl --install Ubuntu
    WingetInstall -Interactive -ItemId Docker.DockerDesktop
}

if ($Gaming) {
    WingetInstall -ItemId -DontIncludeUpdate Valve.Steam

    # Destiny 2
    start steam://install/1085660
    # Retroarch
    start steam://install/1118310
    # WWZ
    start steam://install/699130
    # minecraft
    WingetInstall -ItemId PrismLauncher.PrismLauncher
}

if ($Streaming) {
    WingetInstall -ItemId -DontIncludeUpdate OBSProject.OBSStudio
    WingetInstall -ItemId Iriun.IriunWebcam
    WingetInstall -ItemId Chatty.Chatty
    Start-Process "https://github.com/SAMMISolutions/SAMMI-Official/releases/latest"
}

git init
git remote add origin https://github.com/cethien/win-home.git
git fetch
git reset --hard origin/main
git pull origin main
