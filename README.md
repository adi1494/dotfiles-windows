# dotfiles

## Prerequisites
- cross-platform powershell (v7.1+). [powershell docs](https://aka.ms/powershell)
- git (to clone repo). [git-scm](https://git-scm.com/downloads)

## Steps
- Clone repo in home directory, and navigate to the folder
```
cd ~
git clone "https://github.com/adi1494/dotfiles.git"
cd dotfiles
```
- Run ```config.ps1```. This installs modules, packages, scripts and creates config symlinks. (currently only on windows)
```
./config.ps1
```
