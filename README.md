<div align="center">
  <img src="https://vaultkeepr.xyz/logos/vaultkeepr-shield-og.png" alt="VaultKeepR" width="96" />

  # VaultKeepR Node

  One-script installer for a personal IPFS node, for self-hosted sync with [VaultKeepR](https://vaultkeepr.xyz), a zero-knowledge password manager.

  [**vaultkeepr.xyz**](https://vaultkeepr.xyz/)

  [X @Vaultkeepr_xyz](https://x.com/vaultkeepr_xyz) · [LinkedIn](https://www.linkedin.com/company/vaultkeepr/) · [Farcaster](https://farcaster.xyz/vaultkeepr.eth) · [Mastodon](https://infosec.exchange/@vaultkeepr) · [X @0xJust1](https://x.com/0xJust1)

  [![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](./LICENSE)
  [![Release](https://img.shields.io/github/v/release/VaultKeepR/vaultkeepr-node?color=363636)](https://github.com/VaultKeepR/vaultkeepr-node/releases)
  [![Kubo](https://img.shields.io/badge/Kubo-v0.43.1-65C2CB?logo=ipfs&logoColor=white)](https://github.com/ipfs/kubo)
  [![Platforms](https://img.shields.io/badge/platforms-Linux%20%7C%20macOS%20%7C%20Windows-3178c6)](#scripts)
</div>

**English** · [Français](#vaultkeepr-node-français)

## What this repository is

Four short scripts that install, start, stop, and uninstall an IPFS node on your own machine, preconfigured for VaultKeepR's personal sync mode.

The install script downloads the official [Kubo](https://github.com/ipfs/kubo) binary, the reference IPFS implementation, from its GitHub releases and verifies the SHA-512 checksum. The node listens on `127.0.0.1` only, and every RPC call requires a Bearer token limited to `/api/v0`.

Your vault stays encrypted end to end: the node only ever receives and serves the encrypted JSON, never a password or a key. Self-hosting is free, needs no account, and is not a premium feature.

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

The installer writes `vaultkeepr-node.json` next to the scripts: the connection file with the RPC URL, the token, and the gateway URL. In any VaultKeepR app, open Settings, Advanced, Personal IPFS node, paste that file, then Test and Save.

## Scripts

| | `.sh` (Linux, macOS) | `.ps1` (Windows) | |
|---|---|---|---|
| Install | `install.sh` | `install.ps1` | Downloads and verifies Kubo, writes the config, generates the token |
| Start | `start.sh` | `start.ps1` | Starts the daemon in the background, logs to `daemon.log` |
| Stop | `stop.sh` | `stop.ps1` | Stops the daemon |
| Uninstall | `uninstall.sh` | `uninstall.ps1` | Removes the binary, the config, and the datastore |

Options:

| Option | Effect |
|---|---|
| `--lan` / `-Lan` | The RPC endpoint and gateway listen on your LAN instead of loopback, so a phone or a second machine can reach the node |
| `--swarm-key <file>` / `-SwarmKey <file>` | Joins a private IPFS swarm instead of the public network (AutoConf disabled, required by Kubo 0.43 and later) |

## How sync behaves

Publishing goes to your node. The upload takes about 0.2 s, then the IPNS publish takes 30 to 60 s the first time, and a few seconds after that. Reads resolve your IPNS name through your node first, and fall back to public gateways if the node is down. A failed publish leaves your local vault untouched.

The IPNS key is named `vaultkeepr-vault` and reused on every device, so all your machines follow the same address.

## Documentation

- [SELF-HOSTING.md](./SELF-HOSTING.md), the operational guide (paths, ports, config, logs)
- [docs.vaultkeepr.xyz/guides/self-hosting](https://docs.vaultkeepr.xyz/guides/self-hosting), the user guide, [also in French](https://docs.vaultkeepr.xyz/fr/guides/self-hosting)

## Security

Treat `vaultkeepr-node.json` like a password: whoever has the token can publish to your node. The token is generated at install time, stored in the node config with `0600` permissions, and never printed. Everything the scripts do is readable in this repository: no telemetry, no phone-home, no binary beyond Kubo itself.

## License

MIT, see [LICENSE](./LICENSE). VaultKeepR is a product of [vaultkeepr.xyz](https://vaultkeepr.xyz).

---

# VaultKeepR Node (français)

[Version anglaise](#what-this-repository-is)

## À quoi sert ce dépôt

Quatre scripts courts pour installer, démarrer, arrêter et désinstaller un nœud IPFS sur votre propre machine, préconfiguré pour la synchronisation « nœud perso » de VaultKeepR.

L'installeur télécharge le binaire officiel [Kubo](https://github.com/ipfs/kubo), l'implémentation IPFS de référence, depuis ses releases GitHub et vérifie la somme SHA-512. Le nœud n'écoute que sur `127.0.0.1`, et chaque appel RPC exige un token Bearer limité à `/api/v0`.

Votre coffre reste chiffré de bout en bout : le nœud ne reçoit et ne sert jamais autre chose que le JSON chiffré, ni mot de passe ni clé. L'auto-hébergement est gratuit, sans compte, et ne fait pas partie des fonctions payantes.

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

L'installeur écrit `vaultkeepr-node.json` à côté des scripts : c'est le fichier de connexion, avec l'URL RPC, le token et l'URL de la passerelle. Dans n'importe quelle app VaultKeepR : Réglages, Avancé, Nœud IPFS perso ; collez le contenu du fichier, puis Testez et Enregistrez.

## Scripts

| | `.sh` (Linux, macOS) | `.ps1` (Windows) | |
|---|---|---|---|
| Installer | `install.sh` | `install.ps1` | Télécharge et vérifie Kubo, écrit la config, génère le token |
| Démarrer | `start.sh` | `start.ps1` | Démarre le daemon en tâche de fond, journal dans `daemon.log` |
| Arrêter | `stop.sh` | `stop.ps1` | Arrête le daemon |
| Désinstaller | `uninstall.sh` | `uninstall.ps1` | Supprime le binaire, la config et le datastore |

Options :

| Option | Effet |
|---|---|
| `--lan` / `-Lan` | Le RPC et la passerelle écoutent sur votre réseau local au lieu de la loopback, pour y brancher un téléphone ou une seconde machine |
| `--swarm-key <fichier>` / `-SwarmKey <fichier>` | Rejoint un swarm IPFS privé au lieu du réseau public (AutoConf désactivé, exigé par Kubo 0.43 et plus) |

## Synchronisation

La publication va sur votre nœud. L'envoi prend environ 0,2 s, puis la publication IPNS prend de 30 à 60 s la première fois, et quelques secondes ensuite. Les lectures résolvent votre nom IPNS via votre nœud en premier, et retombent sur les passerelles publiques si le nœud est éteint. Une publication qui échoue laisse votre coffre local intact.

La clé IPNS s'appelle `vaultkeepr-vault` et se réutilise sur tous les appareils : vos machines partagent la même adresse.

## Documentation

- [SELF-HOSTING.md](./SELF-HOSTING.md), le guide opérationnel (chemins, ports, config, journaux), en anglais
- [docs.vaultkeepr.xyz/fr/guides/self-hosting](https://docs.vaultkeepr.xyz/fr/guides/self-hosting), le guide utilisateur en français

## Sécurité

Traitez `vaultkeepr-node.json` comme un mot de passe : qui a le token peut publier sur votre nœud. Le token est généré à l'installation, stocké dans la config du nœud avec des permissions `0600`, et jamais affiché. Tout ce que les scripts font se lit dans ce dépôt : pas de télémétrie, pas d'appel sortant, aucun binaire au-delà de Kubo lui-même.

## Licence

MIT, voir [LICENSE](./LICENSE). VaultKeepR est un produit de [vaultkeepr.xyz](https://vaultkeepr.xyz).