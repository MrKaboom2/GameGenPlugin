# GameGen Plugin Installer
# Run: irm https://raw.githubusercontent.com/MrKaboom2/GameGenPlugin/main/install.ps1 | iex

$ErrorActionPreference = "Stop"

Write-Host "--- GameGen Plugin Installer (v1.1) ---" -ForegroundColor Cyan

# 1. Detect Steam path
$steamPath = Get-ItemProperty -Path "HKCU:\Software\Valve\Steam" -Name "SteamPath" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty SteamPath
if (-not $steamPath) {
    $steamPath = "C:\Program Files (x86)\Steam"
}

$pluginsPath = Join-Path $steamPath "millennium\plugins"
$targetPath = Join-Path $pluginsPath "GameGen"

# 2. Preparation
if (Test-Path $targetPath) {
    Write-Host "Removing existing GameGen installation..." -ForegroundColor Yellow
    Remove-Item -Path $targetPath -Recurse -Force
}

New-Item -ItemType Directory -Force -Path $targetPath | Out-Null

# 3. Download and Extract
$zipUrl = "https://github.com/MrKaboom2/GameGenPlugin/archive/refs/heads/main.zip"
$tempZip = Join-Path $env:TEMP "GameGen.zip"

Write-Host "Downloading GameGen from GitHub..." -ForegroundColor White
Invoke-WebRequest -Uri $zipUrl -OutFile $tempZip

Write-Host "Extracting files..." -ForegroundColor White
Expand-Archive -Path $tempZip -DestinationPath "$env:TEMP\GameGenTemp" -Force

# Move contents (GitHub zips have a nested folder)
$extractedFolder = Get-ChildItem -Path "$env:TEMP\GameGenTemp" -Directory | Select-Object -First 1
Move-Item -Path (Join-Path $extractedFolder.FullName "*") -Destination $targetPath -Force

# 4. Cleanup
Remove-Item -Path $tempZip -Force
Remove-Item -Path "$env:TEMP\GameGenTemp" -Recurse -Force

Write-Host "`nSuccessfully installed GameGen to: $targetPath" -ForegroundColor Green
Write-Host "Please restart Steam to activate the plugin." -ForegroundColor Cyan
