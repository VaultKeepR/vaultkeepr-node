# VaultKeepR Node

Installer bundle for a personal [IPFS](https://ipfs.tech) node (official
[Kubo](https://github.com/ipfs/kubo) binary, never a fork), preconfigured for
VaultKeepR's personal sync mode: local RPC + gateway behind a Bearer token,
IPNS republish every 2h, optional LAN bind and private swarm.

- Guide: [SELF-HOSTING.md](SELF-HOSTING.md)
- Scripts: `install.sh` / `start.sh` / `stop.sh` / `uninstall.sh` (Linux, macOS — `--lan`, `--swarm-key`)
- Windows: same names in `.ps1` (`-Lan`, `-SwarmKey`)

```
curl -LO https://github.com/VaultKeepR/vaultkeepr-node/releases/latest/download/install.sh
chmod +x install.sh && ./install.sh && ./start.sh
```