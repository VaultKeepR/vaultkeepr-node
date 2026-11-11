#!/usr/bin/env bash
# Removes the node AND its keystore. Your vault encryption key stays in the app
# (client-side), but the IPNS name generated on this node is LOST unless you
# exported it first: IPFS_PATH="$NODE_DIR" bin/ipfs key export vaultkeepr-vault
set -euo pipefail
NODE_DIR="${VK_NODE_DIR:-$HOME/.vaultkeepr-node}"
if [[ $# != 1 || $1 != --yes ]]; then
  echo "this deletes $NODE_DIR including any IPNS key in its keystore."
  read -r -p "type 'yes' to confirm: " A
  [[ $A == yes ]] || exit 1
fi
"$(dirname "$0")/stop.sh" || true
rm -rf "$NODE_DIR"
echo "uninstalled"