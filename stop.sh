#!/usr/bin/env bash
set -euo pipefail
NODE_DIR="${VK_NODE_DIR:-$HOME/.vaultkeepr-node}"
PID="$NODE_DIR/pid"
[[ -f $PID ]] || { echo "not running"; exit 0; }
kill "$(cat "$PID")" 2>/dev/null || true
for _ in $(seq 1 20); do kill -0 "$(cat "$PID")" 2>/dev/null || break; sleep 0.5; done
kill -0 "$(cat "$PID")" 2>/dev/null && kill -9 "$(cat "$PID")"
rm -f "$PID"
echo "stopped"