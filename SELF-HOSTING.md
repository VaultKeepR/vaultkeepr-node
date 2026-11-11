# Self-hosting VaultKeepR sync on your own IPFS node

VaultKeepR can sync your vault through **your own IPFS node** instead of the
managed cloud — free, no account, your data stays on your machines. The vault
payload is always the encrypted JSON you already have; a node only ever sees
ciphertext.

## 1. Install

Linux / macOS:

```bash
curl -LO https://github.com/VaultKeepR/vaultkeepr-node/releases/latest/download/install.sh
chmod +x install.sh && ./install.sh          # add --lan to also serve your phone, --swarm-key for a private network
./start.sh
```

Windows (PowerShell):

```powershell
Invoke-WebRequest https://github.com/VaultKeepR/vaultkeepr-node/releases/latest/download/install.ps1 -OutFile install.ps1
.\install.ps1        # -Lan to also serve your phone, -SwarmKey for a private network
.\start.ps1
```

The installer downloads the **official Kubo binary** (sha512-verified), runs
`ipfs init`, and configures:

- RPC on `127.0.0.1:5001` and gateway on `127.0.0.1:8080`, both behind a
  random **Bearer token**;
- `Ipns.RepublishPeriod` 2h (keeps your published name alive while offline).

It writes `$HOME/.vaultkeepr-node/vaultkeepr-node.json`:

```json
{ "rpcUrl": "http://127.0.0.1:5001", "token": "<random>", "gatewayUrl": "http://127.0.0.1:8080" }
```

## 2. Connect the app

VaultKeepR settings → « Nœud IPFS perso » → paste the content of
`vaultkeepr-node.json` → « Tester la connexion ». Empty field = managed cloud,
the default. On first sync in personal mode the app generates a dedicated IPNS
key (`vaultkeepr-vault`) on the node and shows you its name — that name **is**
your vault address, keep it noted.

**Phone on the same network:** install with `--lan` (or `-Lan`) on the machine
running the node, then paste the same `vaultkeepr-node.json` in the mobile app —
its `rpcUrl`/`gatewayUrl` point at the machine's LAN address. The token is
required for every RPC call, so LAN exposure is safe.

## 3. Limits, honestly

- **Machine off → no sync.** Publishing fails with an explicit error; your
  local vault is untouched. Another device can still read the last published
  version through **public gateways** (`ipfs.io`, …) — expect 10–30 s and
  occasional rate-limits; the app rotates gateways and retries.
- **First publish is slow** (12–40 s): publishing an IPNS name writes to the
  public DHT. Sync runs in the background, not in your way.
- **Behind NAT: fine.** No port-forwarding needed; publishing and DHT
  resolution work outbound. A node that is never online stops republishing —
  after ~48 h the name gets hard to resolve until the machine syncs again.
- **Uninstalling loses the IPNS name** (it lives in the node keystore). Export
  it first if you care:
  `IPFS_PATH="$HOME/.vaultkeepr-node" ~/.vaultkeepr-node/bin/ipfs key export vaultkeepr-vault`.
- **No CORS setup needed**: the extension uses host permissions (no preflight),
  and the node's auth layer rejects browser pages without the token anyway.

## 4. Uninstall

`./uninstall.sh` / `.\uninstall.ps1` — stops the node and deletes
`~/.vaultkeepr-node` (read the IPNS warning above first).