# 🏠 Windows Home Directory

i'm a nerd :nerd_face:

## Setup

`stupidly long cuz i want to use arguments`

```powershell
# pwsh >= 7 needed
winget add -s winget --id Microsoft.PowerShell
&pwsh -NoProfile -ExecutionPolicy unrestricted -Command "&([scriptblock]::Create((Invoke-WebRequest -UseBasicParsing 'https://raw.githubusercontent.com/Cethien/setups/main/setup-windows.ps1'))) <parameters>"
```

| Parameter    | Description                             |
| ------------ | --------------------------------------- |
| -Customizing | customization stuff                     |
| -Personal    | some stuff on a personal desktop        |
| -Ssh         | generate a new ssh key. uses ssh-keygen |
| -Development | development stuff                       |
| -Gaming      | games & launchers                       |
| -Streaming   | streaming stuff                         |

## Create folder backup

useful script for backing up folders

1. create a environment variable `BACKUP`
2. create script for backing up:

```powershell
iwr https://raw.githubusercontent.com/cethien/scripts/main/create-backup.ps1 | iex
```

3. (optional): create `.backupignore` file:

```plaintext
folder1\
folder2\
config.ini
```
