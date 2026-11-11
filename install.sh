#!/usr/bin/env bash
# VaultKeepR Node installer — downloads the official Kubo binary and configures a local node.
# Options: --lan (bind RPC+gateway to all interfaces, for phone access)
#          --swarm-key (private network, removes public bootstrap)
# Env: KUBO_VERSION (default v0.43.1), VK_NODE_DIR (default ~/.vaultkeepr-node)
set -euo pipefail

KUBO_VERSION="${KUBO_VERSION:-v0.43.1}"
NODE_DIR="${VK_NODE_DIR:-$HOME/.vaultkeepr-node}"
LAN=0; SWARM=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --lan) LAN=1 ;;
    --swarm-key) SWARM=1 ;;
    *) echo "usage: install.sh [--lan] [--swarm-key]" >&2; exit 2 ;;
  esac
  shift
done

case "$(uname -s)/$(uname -m)" in
  Linux/x86_64)  ASSET="kubo_${KUBO_VERSION}_linux-amd64.tar.gz" ;;
  Linux/aarch64) ASSET="kubo_${KUBO_VERSION}_linux-arm64.tar.gz" ;;
  Darwin/arm64)  ASSET="kubo_${KUBO_VERSION}_darwin-arm64.tar.gz" ;;
  Darwin/x86_64) ASSET="kubo_${KUBO_VERSION}_darwin-amd64.tar.gz" ;;
  *) echo "unsupported platform: $(uname -s)/$(uname -m)" >&2; exit 1 ;;
esac

DL="https://github.com/ipfs/kubo/releases/download/$KUBO_VERSION"
# Primary source is GitHub releases; dist.ipfs.tech also hosts them.

mkdir -p "$NODE_DIR/bin"
if [[ ! -x "$NODE_DIR/bin/ipfs" ]]; then
  TMP="$(mktemp -d)"
  echo "downloading $ASSET ..."
  curl -fL --retry 3 -o "$TMP/$ASSET" "$DL/$ASSET"
  curl -fL --retry 3 -o "$TMP/$ASSET.sha512" "$DL/$ASSET.sha512"
  ( cd "$TMP" \
    && if command -v sha512sum >/dev/null; then sha512sum -c "$ASSET.sha512";
       else shasum -a 512 -c "$ASSET.sha512"; fi )
  tar xzf "$TMP/$ASSET" -C "$NODE_DIR/bin" --strip-components=1
  rm -rf "$TMP"
fi
IPFS() { IPFS_PATH="$NODE_DIR" "$NODE_DIR/bin/ipfs" "$@"; }

if [[ ! -f "$NODE_DIR/config" ]]; then IPFS init >/dev/null; fi

BIND=127.0.0.1
[[ $LAN == 1 ]] && BIND=0.0.0.0
IPFS config Addresses.API "/ip4/$BIND/tcp/5001"
IPFS config Addresses.Gateway "/ip4/$BIND/tcp/8080"
IPFS config Ipns.RepublishPeriod 2h0m0s

TOKEN="$(openssl rand -hex 32)"
IPFS config --json API.Authorizations \
  "{\"vaultkeeper\":{\"AuthSecret\":\"bearer:$TOKEN\",\"AllowedPaths\":[\"/api/v0\"]}}"

if [[ $SWARM == 1 && ! -f "$NODE_DIR/swarm.key" ]]; then
  printf '/key/swarm/psk/1.0.0/\n/base16/\n%s\n' "$(openssl rand -hex 32)" > "$NODE_DIR/swarm.key"
  IPFS bootstrap rm --all >/dev/null
fi
# Private networks must not fetch the public mainnet AutoConf (startup fails otherwise).
if [[ -f "$NODE_DIR/swarm.key" ]]; then IPFS config --json AutoConf.Enabled false; fi

# URL the client apps should use: LAN address with --lan, loopback otherwise.
HOST=127.0.0.1
if [[ $LAN == 1 ]]; then
  if [[ $(uname -s) == Darwin ]]; then HOST="$(ipconfig getifaddr en0 || echo 127.0.0.1)"
  else HOST="$(ip -4 route get 1.1.1.1 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i=="src"){print $(i+1); exit}}')"; fi
  [[ -n $HOST ]] || HOST=127.0.0.1
fi
cat > "$NODE_DIR/vaultkeepr-node.json" <<EOF
{
  "rpcUrl": "http://$HOST:5001",
  "token": "$TOKEN",
  "gatewayUrl": "http://$HOST:8080"
}
EOF
chmod 600 "$NODE_DIR/vaultkeepr-node.json" "$NODE_DIR/config"

echo "installed: kubo $KUBO_VERSION -> $NODE_DIR/bin/ipfs"
echo "config for the app: $NODE_DIR/vaultkeepr-node.json"
[[ $SWARM == 1 ]] && echo "private swarm network: enabled (public bootstrap removed)"
echo "next: ./start.sh"