#!/usr/bin/env bash
set -euo pipefail
NODE_DIR="${VK_NODE_DIR:-$HOME/.vaultkeepr-node}"
[[ -x "$NODE_DIR/bin/ipfs" ]] || { echo "nothing installed, run ./install.sh"; exit 1; }
PID="$NODE_DIR/pid"
if [[ -f $PID ]] && kill -0 "$(cat "$PID")" 2>/dev/null; then
  echo "already running (pid $(cat "$PID"))"; exit 0
fi
IPFS_PATH="$NODE_DIR" nohup "$NODE_DIR/bin/ipfs" daemon > "$NODE_DIR/daemon.log" 2>&1 &
echo $! > "$PID"
sleep 3
kill -0 "$(cat "$PID")" 2>/dev/null \
  || { echo "daemon died — last log lines:"; tail -20 "$NODE_DIR/daemon.log"; rm -f "$PID"; exit 1; }
echo "started (pid $(cat "$PID")), log: $NODE_DIR/daemon.log"