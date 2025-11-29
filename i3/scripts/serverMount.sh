#!/usr/bin/bash
# The connection is configured in ~/.ssh/config
if ! mountpoint -q "$HOME/cloud"; then
  if ssh -o ConnectTimeout=3 -o BatchMode=yes -i "$HOME/.ssh/id_ed25519" roksmainserver "echo ok" >/dev/null 2>&1; then
    sshfs roksmainserver:/mnt/sdb/cloud "$HOME/cloud" -o reconnect
  fi
fi
