# 🏠 Windows Home Directory

i'm a nerd :nerd_face:

## Setup

```powershell
&powershell -NoProfile -ExecutionPolicy unrestricted -Command "&([scriptblock]::Create((Invoke-WebRequest -UseBasicParsing 'https://raw.githubusercontent.com/cethien/win-home/main/setup.ps1'))) <parameters>"
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

(optional): create `.backupignore` file:

```plaintext
folder1\
folder2\
config.ini
```

1. create a environment variable `BACKUP`
2. create script for backing up:

```powershell
iwr https://raw.githubusercontent.com/cethien/scripts/main/create-backup.ps1 | iex
```
