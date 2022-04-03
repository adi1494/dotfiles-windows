#Requires -RunAsAdministrator

$fontUri = "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip";
# $fontUri = "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/CascadiaCode.zip"


if ($IsWindows) {
    Write-Host "Detected platform - Windows"
    Write-Host "Installing Modules..."
    [string[]]$items = Get-Content -Path './ps-modules.txt'
    foreach ($i in $items) {
        if (Get-InstalledModule -Name $i -ErrorAction:SilentlyContinue) {
            Write-Host "module $i exists, skipping install"
        }
        else {
            Write-Host "module $i does not exist, installing..."
            Install-Module -Name $i -Scope CurrentUser -Force
        }
    }

    Write-Host "Installing Scripts..."
    [string[]]$items = Get-Content -Path './ps-scripts.txt'
    foreach ($i in $items) {
        if (Get-InstalledScript -Name $i -ErrorAction:SilentlyContinue) {
            Write-Host "script $i exists, skipping install"
        }
        else {
            Write-Host "script $i does not exist, installing..."
            Install-Script -Name $i -Force
        }
    }

    Install-Script -Name pwshfetch-test-1

    Write-Host "Installing Fonts..."
    Invoke-WebRequest -Uri $fontUri -OutFile "./dlfont.zip"
    Expand-Archive -LiteralPath "./dlfont.zip" -DestinationPath "./tempfonts" -Force
    $fonts = Get-ChildItem "./tempfonts"
    foreach ($f in $fonts){
        $fontFile = $f.Name
        $destPath = Join-Path -Path "C:\Windows\Fonts" -ChildPath $fontFile
        $sourcePath = Join-Path -Path ".\tempfonts" -ChildPath $fontFile
        if (!(Test-Path -Path $destPath -PathType Leaf)) {
            Write-Host "$fontFile not installed, installing..."
            Copy-Item $sourcePath -Destination $destPath
        }
        else {
            Write-Host "$fontFile already installed, skipping install"
        }
    }
    Write-Host "cleaning up stuff..."
    Remove-Item dlfont.zip
    Remove-Item tempfonts -Recurse -Force


    Write-Host "Devicename Specific Dotfiles Setup"
    $hname = $env:computername | Select-Object
    Write-Host "Creating symbolic links on $hname..."
    $gitconfigTarget = ""
    if ($hname -eq "POTATOLAPTOP") {
        $gitconfigTarget = "dotfiles/.gitconfig-pl"
    }

    New-Item -ItemType SymbolicLink -Path "~/Documents/PowerShell" -Target "../dotfiles/PowerShell" -Force
    
    New-Item -ItemType SymbolicLink -Path "~/.gitconfig" -Target $gitconfigTarget -Force
    if (Test-Path -Path "~/dotfiles/.gitconfig-work" -PathType Leaf) {
        Write-Host "work gitconfig already exists"
    }
    else {
        Write-Host "work gitconfig not found"
        New-Item -Path '~/dotfiles/.gitconfig-work' -ItemType File
    }

    Write-Host "done."
}

if ($IsLinux) {
    Write-Host "linux"
}

if ($IsMacOs) {
    Write-Host "macos"
}
