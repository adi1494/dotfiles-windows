#Requires -RunAsAdministrator

$fontUri = "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip";
# $fontUri = "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/CascadiaCode.zip"


if ($IsWindows) {
    Write-Host "Detected platform - Windows"
    Write-Host "Installing Modules..."

    $modules = Get-Content -Path './PowerShell/ps-modules.json' | ConvertFrom-Json
    foreach ($i in $modules){
        $name = $i.name
        if (Get-InstalledModule -Name $name -ErrorAction:SilentlyContinue) {
            Write-Host "module $name exists, skipping install"
        } else {
            Write-Host "module $name does not exist, installing..."
            Install-Module -Name $name -Scope CurrentUser -Force
        }
    }
    $scripts = Get-Content -Path './PowerShell/ps-scripts.json' | ConvertFrom-Json
    foreach ($i in $scripts){
        $name = $i.name
        if (Get-InstalledScript -Name $name -ErrorAction:SilentlyContinue) {
            Write-Host "script $name exists, skipping install"
        } else {
            Write-Host "script $name does not exist, installing..."
            Install-Script -Name $name -Force
        }
    }

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
