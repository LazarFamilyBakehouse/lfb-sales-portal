# LFB Leads Portal - Auto-Push Watcher
# Checks this folder every 15 seconds. If any file changed, it commits and pushes to GitHub.
# Installed by SETUP_AUTOPUSH.bat. Log: %TEMP%\lfb_autopush.log

$repo = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $repo
$log = Join-Path $env:TEMP "lfb_autopush.log"
Add-Content $log ("{0} watcher started in {1}" -f (Get-Date -Format "MM/dd/yyyy HH:mm:ss"), $repo)

while ($true) {
    try {
        Set-Location $repo
        $status = git status --porcelain 2>$null
        if ($status) {
            $ts = Get-Date -Format "MM/dd/yyyy HH:mm:ss"
            git add -A 2>&1 | Out-Null
            git commit -m "Leads portal auto-update - $ts" 2>&1 | Out-Null
            git push origin HEAD:main 2>&1 | Out-Null
            if ($LASTEXITCODE -ne 0) {
                git pull --rebase --autostash 2>&1 | Out-Null
                git push origin HEAD:main 2>&1 | Out-Null
            }
            Add-Content $log ("{0} push finished, exit code {1}" -f $ts, $LASTEXITCODE)
        }
    } catch {
        Add-Content $log ("{0} error: {1}" -f (Get-Date -Format "MM/dd/yyyy HH:mm:ss"), $_.Exception.Message)
    }
    Start-Sleep -Seconds 15
}
