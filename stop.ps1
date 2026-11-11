$ErrorActionPreference = 'Stop'
$NodeDir = if ($env:VK_NODE_DIR) { $env:VK_NODE_DIR } else { Join-Path $HOME '.vaultkeepr-node' }
$pidFile = "$NodeDir\pid"
if (-not (Test-Path $pidFile)) { Write-Host 'not running'; exit 0 }
$p = Get-Process -Id (Get-Content $pidFile) -ErrorAction SilentlyContinue
if ($p) { Stop-Process -Id $p.Id -Force; Write-Host 'stopped' } else { Write-Host 'not running' }
Remove-Item $pidFile -ErrorAction SilentlyContinue