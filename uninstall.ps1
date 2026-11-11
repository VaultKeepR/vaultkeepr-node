# Removes the node AND its keystore. The vault encryption key stays in the app
# (client-side), but the IPNS name generated on this node is LOST unless exported first.
param([switch]$Yes)
$ErrorActionPreference = 'Stop'
$NodeDir = if ($env:VK_NODE_DIR) { $env:VK_NODE_DIR } else { Join-Path $HOME '.vaultkeepr-node' }
if (-not $Yes) {
  Write-Host "this deletes $NodeDir including any IPNS key in its keystore."
  $a = Read-Host "type 'yes' to confirm"
  if ($a -ne 'yes') { exit 1 }
}
& "$PSScriptRoot\stop.ps1"
Remove-Item -Recurse -Force $NodeDir
Write-Host 'uninstalled'