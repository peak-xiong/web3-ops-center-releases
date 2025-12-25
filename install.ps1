# Web3 Ops Center Installer for Windows
# Usage: irm https://raw.githubusercontent.com/peak-xiong/web3-ops-center-releases/main/install.ps1 | iex

$ErrorActionPreference = "Stop"

# Configuration
$Repo = "peak-xiong/web3-ops-center-releases"
$AppName = "Web3 Ops Center"

function Write-Banner {
    Write-Host ""
    Write-Host "╔═══════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║       Web3 Ops Center Installer       ║" -ForegroundColor Cyan
    Write-Host "╚═══════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
}

function Write-Step {
    param([string]$Message)
    Write-Host "▶ $Message" -ForegroundColor Green
}

function Write-Error-Message {
    param([string]$Message)
    Write-Host "✖ Error: $Message" -ForegroundColor Red
    exit 1
}

function Write-Success {
    param([string]$Message)
    Write-Host "✔ $Message" -ForegroundColor Green
}

function Write-Warning-Message {
    param([string]$Message)
    Write-Host "⚠ $Message" -ForegroundColor Yellow
}

function Get-Architecture {
    $arch = [System.Environment]::GetEnvironmentVariable("PROCESSOR_ARCHITECTURE")
    if ($arch -eq "AMD64" -or $arch -eq "x64") {
        return "x64"
    } elseif ($arch -eq "ARM64") {
        return "arm64"
    } else {
        return "x64"  # Default to x64
    }
}

function Get-LatestVersion {
    Write-Step "Fetching latest version..."
    
    try {
        $releases = Invoke-RestMethod -Uri "https://api.github.com/repos/$Repo/releases/latest" -UseBasicParsing
        $version = $releases.tag_name
        Write-Success "Latest version: $version"
        return $version
    } catch {
        Write-Warning-Message "Could not fetch latest release, using 'latest'"
        return "latest"
    }
}

function Download-Installer {
    param(
        [string]$Version,
        [string]$Arch
    )
    
    Write-Step "Downloading $AppName..."
    
    # Create temp directory
    $tempDir = Join-Path $env:TEMP "web3-ops-center-install"
    if (Test-Path $tempDir) {
        Remove-Item -Recurse -Force $tempDir
    }
    New-Item -ItemType Directory -Path $tempDir | Out-Null
    
    # Construct download URL - filename: Web3.Ops.Center-Windows-Setup.exe
    $fileName = "Web3.Ops.Center-Windows-Setup.exe"
    if ($Version -eq "latest") {
        $downloadUrl = "https://github.com/$Repo/releases/latest/download/$fileName"
    } else {
        $downloadUrl = "https://github.com/$Repo/releases/download/$Version/$fileName"
    }
    
    $installerPath = Join-Path $tempDir "installer.exe"
    
    Write-Host "  Downloading from: $downloadUrl"
    
    try {
        Invoke-WebRequest -Uri $downloadUrl -OutFile $installerPath -UseBasicParsing
    } catch {
        Write-Error-Message "Failed to download installer. Please check if releases are available at:`n  https://github.com/$Repo/releases"
    }
    
    Write-Success "Downloaded successfully"
    return $installerPath
}

function Install-App {
    param([string]$InstallerPath)
    
    Write-Step "Installing $AppName..."
    
    # Run installer
    $process = Start-Process -FilePath $InstallerPath -ArgumentList "/S" -Wait -PassThru
    
    if ($process.ExitCode -eq 0) {
        Write-Success "Installation complete"
    } else {
        # Try running without silent mode
        Write-Warning-Message "Silent install failed, launching installer..."
        Start-Process -FilePath $InstallerPath -Wait
    }
}

function Cleanup {
    param([string]$TempDir)
    
    if (Test-Path $TempDir) {
        Remove-Item -Recurse -Force $TempDir -ErrorAction SilentlyContinue
    }
}

# Main
function Main {
    Write-Banner
    
    # Check if running as admin (optional, some installers need it)
    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if (-not $isAdmin) {
        Write-Warning-Message "Running without administrator privileges. Some features may require elevation."
    }
    
    $arch = Get-Architecture
    Write-Step "Detected: Windows ($arch)"
    
    $version = Get-LatestVersion
    $installerPath = Download-Installer -Version $version -Arch $arch
    
    try {
        Install-App -InstallerPath $installerPath
    } finally {
        $tempDir = Split-Path $installerPath -Parent
        Cleanup -TempDir $tempDir
    }
    
    Write-Host ""
    Write-Success "$AppName has been installed successfully!"
    Write-Host ""
    Write-Host "  You can now find it in the Start Menu or run from the installation directory."
    Write-Host ""
}

Main
