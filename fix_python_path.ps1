# Fix Python PATH for Anaconda in PowerShell
# Run this script: .\fix_python_path.ps1

Write-Host "🔧 Fixing Python PATH for Anaconda..." -ForegroundColor Green

# Method 1: Initialize Anaconda (Recommended)
Write-Host "`n📦 Initializing Anaconda for PowerShell..." -ForegroundColor Yellow
& "C:\ProgramData\anaconda3\Scripts\conda.exe" init powershell

Write-Host "`n✅ Anaconda initialized!" -ForegroundColor Green
Write-Host "`n⚠️  IMPORTANT: Close and reopen PowerShell for changes to take effect." -ForegroundColor Yellow
Write-Host "   Or run: conda activate base" -ForegroundColor Yellow

# Method 2: Check current PATH order
Write-Host "`n📋 Current PATH order:" -ForegroundColor Cyan
$env:PATH -split ';' | Where-Object { $_ -match 'python|anaconda|conda' } | ForEach-Object { Write-Host "   $_" }

# Method 3: Temporarily fix for current session
Write-Host "`n🔧 Temporarily fixing PATH for current session..." -ForegroundColor Yellow
$anacondaPath = "C:\ProgramData\anaconda3"
$anacondaScripts = "C:\ProgramData\anaconda3\Scripts"
$anacondaLibrary = "C:\ProgramData\anaconda3\Library\bin"

# Remove Windows Store Python from PATH temporarily
$env:PATH = ($env:PATH -split ';' | Where-Object { $_ -notmatch 'WindowsApps' }) -join ';'

# Add Anaconda paths at the beginning
$env:PATH = "$anacondaPath;$anacondaScripts;$anacondaLibrary;" + $env:PATH

Write-Host "✅ PATH updated for current session" -ForegroundColor Green
Write-Host "`n🧪 Testing Python..." -ForegroundColor Cyan
python --version

