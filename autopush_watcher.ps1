# LFB Sales Portal - Auto-Push Watcher
# Watches for file changes and auto-pushes to GitHub
# This runs in the background after SETUP_AUTOPUSH.bat installs it

$repoPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $repoPath

$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $repoPath
$watcher.Filter = "*.*"
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true
$watcher.NotifyFilter = [System.IO.NotifyFilters]::LastWrite -bor [System.IO.NotifyFilters]::FileName

$debounce = $null

$action = {
    if ($debounce) { $debounce.Stop() }
    $debounce = New-Object System.Timers.Timer
    $debounce.Interval = 5000  # 5 second debounce
    $debounce.AutoReset = $false
    $debounce.add_Elapsed({
        Set-Location $repoPath
        git add -A
        $status = git status --porcelain
        if ($status) {
            $timestamp = Get-Date -Format "MM/dd/yyyy HH:mm:ss"
            git commit -m "Sales portal update - $timestamp"
            git push origin HEAD:main
        }
    })
    $debounce.Start()
}

Register-ObjectEvent $watcher Changed -Action $action | Out-Null
Register-ObjectEvent $watcher Created -Action $action | Out-Null
Register-ObjectEvent $watcher Deleted -Action $action | Out-Null
Register-ObjectEvent $watcher Renamed -Action $action | Out-Null

Write-Host "LFB Sales Portal auto-push watcher started."
Write-Host "Watching: $repoPath"
Write-Host "Press Ctrl+C to stop."

while ($true) { Start-Sleep -Seconds 1 }
