# VaultKeepR Node installer (Windows) — official Kubo binary + local node config.
# Options: -Lan (bind to all interfaces, for phone access), -SwarmKey (private network)
param([switch]$Lan, [switch]$SwarmKey)
$ErrorActionPreference = 'Stop'
$KuboVersion = if ($env:KUBO_VERSION) { $env:KUBO_VERSION } else { 'v0.43.1' }
$NodeDir = if ($env:VK_NODE_DIR) { $env:VK_NODE_DIR } else { Join-Path $HOME '.vaultkeepr-node' }

$asset = switch ($env:PROCESSOR_ARCHITECTURE) {
  'AMD64' { "kubo_$($KuboVersion)_windows-amd64.zip" }
  'ARM64' { "kubo_$($KuboVersion)_windows-arm64.zip" }
  default { throw "unsupported: $($env:PROCESSOR_ARCHITECTURE)" }
}
$dl = "https://github.com/ipfs/kubo/releases/download/$KuboVersion"

New-Item -ItemType Directory -Force -Path "$NodeDir\bin" | Out-Null
if (-not (Test-Path "$NodeDir\bin\ipfs.exe")) {
  $tmp = New-Item -ItemType Directory -Force -Path (Join-Path $env:TEMP ([guid]::NewGuid()))
  Write-Host "downloading $asset ..."
  Invoke-WebRequest -Uri "$dl/$asset" -OutFile "$tmp\$asset"
  Invoke-WebRequest -Uri "$dl/$asset.sha512" -OutFile "$tmp\$asset.sha512"
  $want = (Get-Content "$tmp\$asset.sha512" | Select-Object -First 1) -split '\s+'
  $got = (Get-FileHash "$tmp\$asset" -Algorithm SHA512).Hash.ToLower()
  if ($got -ne $want[0].ToLower()) { throw 'sha512 mismatch' }
  Expand-Archive "$tmp\$asset" -DestinationPath $tmp
  Copy-Item "$tmp\kubo\ipfs.exe" "$NodeDir\bin\ipfs.exe" -Force
  Remove-Item -Recurse -Force $tmp
}
$ipfs = { & "$NodeDir\bin\ipfs.exe" @args }
$env:IPFS_PATH = $NodeDir

if (-not (Test-Path "$NodeDir\config")) { & $ipfs init | Out-Null }

$bind = if ($Lan) { '0.0.0.0' } else { '127.0.0.1' }
& $ipfs config Addresses.API "/ip4/$bind/tcp/5001"
& $ipfs config Addresses.Gateway "/ip4/$bind/tcp/8080"
& $ipfs config Ipns.RepublishPeriod 2h0m0s

$token = -join ((1..64) | ForEach-Object { '{0:x}' -f (Get-Random -Max 16) })
$auth = @{ vaultkeeper = @{ AuthSecret = "bearer:$token"; AllowedPaths = @('/api/v0') } } | ConvertTo-Json -Compress
& $ipfs config --json API.Authorizations $auth

if ($SwarmKey -and -not (Test-Path "$NodeDir\swarm.key")) {
  $hex = -join ((1..64) | ForEach-Object { '{0:x}' -f (Get-Random -Max 16) })
  "/key/swarm/psk/1.0.0/`n/base16/`n$hex" | Set-Content "$NodeDir\swarm.key"
  & $ipfs bootstrap rm --all | Out-Null
}
# Private networks must not fetch the public mainnet AutoConf (startup fails otherwise).
if (Test-Path "$NodeDir\swarm.key") { & $ipfs config --json AutoConf.Enabled false }

$host_ = if ($Lan) { (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -notmatch '^(127|169\.)' } | Select-Object -First 1).IPAddress } else { '127.0.0.1' }
@{ rpcUrl = "http://${host_}:5001"; token = $token; gatewayUrl = "http://${host_}:8080" } |
  ConvertTo-Json | Set-Content "$NodeDir\vaultkeepr-node.json"
Write-Host "installed -> $NodeDir\bin\ipfs.exe"
Write-Host "config for the app: $NodeDir\vaultkeepr-node.json"
Write-Host "next: .\start.ps1"