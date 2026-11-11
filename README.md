<div align="center">
  <img src="https://vaultkeepr.xyz/logos/vaultkeepr-shield-og.png" alt="VaultKeepR" width="96" />

  # VaultKeepR Node

  One-script installer for a personal IPFS node — self-hosted sync for [VaultKeepR](https://vaultkeepr.xyz), the zero-knowledge password manager.

  [**vaultkeepr.xyz**](https://vaultkeepr.xyz/)

  [X @Vaultkeepr_xyz](https://x.com/vaultkeepr_xyz) · [LinkedIn](https://www.linkedin.com/company/vaultkeepr/) · [Farcaster](https://farcaster.xyz/vaultkeepr.eth) · [Mastodon](https://infosec.exchange/@vaultkeepr) · [X @0xJust1](https://x.com/0xJust1)

  [![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](./LICENSE)
  [![Release](https://img.shields.io/github/v/release/VaultKeepR/vaultkeepr-node?color=363636)](https://github.com/VaultKeepR/vaultkeepr-node/releases)
  [![Kubo](https://img.shields.io/badge/Kubo-v0.43.1-65C2CB?logo=ipfs&logoColor=white)](https://github.com/ipfs/kubo)
  [![Platforms](https://img.shields.io/badge/platforms-Linux%20%7C%20macOS%20%7C%20Windows-3178c6)](#scripts)
</div>

**English** · [Français](#vaultkeepr-node-français)

## What this repository is

Four short scripts that install, start, stop, and uninstall an IPFS node on your own machine, preconfigured for VaultKeepR's personal sync mode:

- **Official [Kubo](https://github.com/ipfs/kubo) binary** — the reference IPFS implementation, never a fork. Downloaded from its GitHub releases, SHA-512 verified.
- **Loopback by default, token-gated** — RPC and gateway bind `127.0.0.1`; every RPC call requires a Bearer token scoped to `/api/v0`.
- **Zero-knowledge stays zero** — the node only ever receives and serves your encrypted vault JSON. Not the master password, not the encryption key, not a single secret.
- **Free, no account, no premium** — self-hosting is a standard feature of VaultKeepR, not a paid one.

## Quick start

**Linux / macOS:**

```bash
curl -fsSL https://github.com/VaultKeepR/vaultkeepr-node/releases/latest/download/install.sh -o install.sh
bash install.sh && bash start.sh
```

**Windows (PowerShell):**

```powershell
Invoke-WebRequest https://github.com/VaultKeepR/vaultkeepr-node/releases/latest/download/install.ps1 -OutFile install.ps1
.\install.ps1; .\start.ps1
```

The installer writes `vaultkeepr-node.json` — the connection file containing the RPC URL, the token, and the gateway URL. Paste it into **Settings → Advanced → Personal IPFS node** in any VaultKeepR app, press **Test**, **Save**, done.

## Scripts

| Script | `.sh` (Linux/macOS) | `.ps1` (Windows) | What it does |
|---|---|---|---|
| Install | `install.sh` | `install.ps1` | Download + verify Kubo, write config, generate the token |
| Start | `start.sh` | `start.ps1` | Start the daemon (background, logs to `daemon.log`) |
| Stop | `stop.sh` | `stop.ps1` | Stop the daemon |
| Uninstall | `uninstall.sh` | `uninstall.ps1` | Remove binary, config, datastore |

Options:

| Option | Effect |
|---|---|
| `--lan` / `-Lan` | Bind RPC + gateway to your LAN, so a phone or second machine can reach the node |
| `--swarm-key <file>` / `-SwarmKey <file>` | Join a private IPFS swarm instead of the public network (AutoConf disabled, required by Kubo ≥ 0.43) |

## How sync behaves

- **Publish** goes straight to your node: add (≈0.2 s), then IPNS publish (first one ≈30–60 s, then a few seconds).
- **Reads** resolve your IPNS name through your node first, then fall back to public IPFS gateways if your node is off.
- **Node off:** publish fails with a clear message, your local vault is untouched, nothing is lost.
- The IPNS key is named `vaultkeepr-vault` and reused across devices — one address, all your machines.

## Documentation

- [SELF-HOSTING.md](./SELF-HOSTING.md) — operational guide (paths, ports, config, logs)
- [docs.vaultkeepr.xyz/guides/self-hosting](https://docs.vaultkeepr.xyz/guides/self-hosting) — user guide (EN / FR)

## Security

- Treat `vaultkeepr-node.json` like a password: whoever holds the token can publish to your node.
- The token is generated at install time, stored in the node config with `0600` permissions, never printed.
- Everything the scripts do is readable in this repository — no telemetry, no phone-home, no binary blob beyond Kubo itself.

## License

MIT — see [LICENSE](./LICENSE). VaultKeepR is a product of [vaultkeepr.xyz](https://vaultkeepr.xyz).

---

# VaultKeepR Node (Français)

Installeur en un script pour un nœud IPFS personnel — synchronisation auto-hébergée pour [VaultKeepR](https://vaultkeepr.xyz), le gestionnaire de mots de passe zero-knowledge.

[Revenir en anglais](#what-this-repository-is)

## Ce qu'est ce dépôt

Quatre scripts courts qui installent, démarrent, arrêtent et désinstallent un nœud IPFS sur votre propre machine, préconfiguré pour le mode de synchronisation personnel de VaultKeepR :

- **Binaire [Kubo](https://github.com/ipfs/kubo) officiel** — l'implémentation IPFS de référence, jamais un fork. Téléchargé depuis ses releases GitHub, vérifié par SHA-512.
- **Loopback par défaut, protégé par token** — le RPC et la passerelle écoutent sur `127.0.0.1` ; chaque appel RPC exige un Bearer token restreint à `/api/v0`.
- **Le zero-knowledge reste zero** — le nœud ne reçoit et ne sert que le JSON chiffré de votre coffre. Jamais le mot de passe maître, jamais la clé de chiffrement, jamais un seul secret.
- **Gratuit, sans compte, sans premium** — l'auto-hébergement est une fonctionnalité standard de VaultKeepR, pas une option payante.

## Démarrage rapide

**Linux / macOS :**

```bash
curl -fsSL https://github.com/VaultKeepR/vaultkeepr-node/releases/latest/download/install.sh -o install.sh
bash install.sh && bash start.sh
```

**Windows (PowerShell) :**

```powershell
Invoke-WebRequest https://github.com/VaultKeepR/vaultkeepr-node/releases/latest/download/install.ps1 -OutFile install.ps1
.\install.ps1; .\start.ps1
```

L'installeur écrit `vaultkeepr-node.json` — le fichier de connexion contenant l'URL RPC, le token et l'URL de la passerelle. Collez-le dans **Réglages → Avancé → Nœud IPFS perso** dans n'importe quelle application VaultKeepR, appuyez sur **Tester**, **Enregistrer**, c'est fait.

## Scripts

| Script | `.sh` (Linux/macOS) | `.ps1` (Windows) | Ce qu'il fait |
|---|---|---|---|
| Installer | `install.sh` | `install.ps1` | Télécharge et vérifie Kubo, écrit la config, génère le token |
| Démarrer | `start.sh` | `start.ps1` | Démarre le daemon (en tâche de fond, journal dans `daemon.log`) |
| Arrêter | `stop.sh` | `stop.ps1` | Arrête le daemon |
| Désinstaller | `uninstall.sh` | `uninstall.ps1` | Supprime le binaire, la config et le datastore |

Options :

| Option | Effet |
|---|---|
| `--lan` / `-Lan` | Le RPC et la passerelle écoutent sur votre LAN, pour qu'un téléphone ou une seconde machine joigne le nœud |
| `--swarm-key <fichier>` / `-SwarmKey <fichier>` | Rejoint un swarm IPFS privé au lieu du réseau public (AutoConf désactivé, requis par Kubo ≥ 0.43) |

## Comportement de la synchronisation

- La **publication** va droit sur votre nœud : add (≈0,2 s), puis publish IPNS (le premier ≈30–60 s, les suivants quelques secondes).
- Les **lectures** résolvent votre nom IPNS via votre nœud d'abord, puis retombent sur les passerelles IPFS publiques si votre nœud est éteint.
- **Nœud éteint :** la publication échoue avec un message clair, votre coffre local est intact, rien n'est perdu.
- La clé IPNS s'appelle `vaultkeepr-vault` et se réutilise entre appareils — une seule adresse, toutes vos machines.

## Documentation

- [SELF-HOSTING.md](./SELF-HOSTING.md) — guide opérationnel (chemins, ports, config, journaux), en anglais
- [docs.vaultkeepr.xyz/fr/guides/self-hosting](https://docs.vaultkeepr.xyz/fr/guides/self-hosting) — guide utilisateur en français

## Sécurité

- Traitez `vaultkeepr-node.json` comme un mot de passe : qui tient le token peut publier sur votre nœud.
- Le token est généré à l'installation, stocké dans la config du nœud avec des permissions `0600`, jamais affiché.
- Tout ce que les scripts font est lisible dans ce dépôt — pas de télémétrie, pas d'appel externe, pas de binaire opaque au-delà de Kubo lui-même.

## Licence

MIT — voir [LICENSE](./LICENSE). VaultKeepR est un produit de [vaultkeepr.xyz](https://vaultkeepr.xyz).