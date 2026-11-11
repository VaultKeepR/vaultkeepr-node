$ErrorActionPreference = 'Stop'
$NodeDir = if ($env:VK_NODE_DIR) { $env:VK_NODE_DIR } else { Join-Path $HOME '.vaultkeepr-node' }
if (-not (Test-Path "$NodeDir\bin\ipfs.exe")) { throw 'nothing installed, run .\install.ps1' }
$pidFile = "$NodeDir\pid"
if ((Test-Path $pidFile) -and (Get-Process -Id (Get-Content $pidFile) -ErrorAction SilentlyContinue)) {
  Write-Host "already running (pid $(Get-Content $pidFile))"; exit 0
}
$env:IPFS_PATH = $NodeDir
$p = Start-Process -FilePath "$NodeDir\bin\ipfs.exe" -ArgumentList 'daemon' `
  -RedirectStandardOutput "$NodeDir\daemon.log" -RedirectStandardError "$NodeDir\daemon.err.log" -PassThru -WindowStyle Hidden
$p.Id | Set-Content $pidFile
Start-Sleep 3
if ($p.HasExited) { Get-Content "$NodeDir\daemon.err.log" -Tail 20; throw 'daemon died' }
Write-Host "started (pid $($p.Id)), log: $NodeDir\daemon.log"