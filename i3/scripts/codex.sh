#!/usr/bin/env bash

set -euo pipefail

roots=(
  "$HOME/sync"
  "$HOME/offline"
)

repo="$(
  find "${roots[@]}" -maxdepth 4 -type d -name .git 2>/dev/null \
    | sed 's#/.git$##' \
    | sort -u \
    | fzf --prompt='Codex repo > ' --height=40% --reverse
)" || exit 0

cd "$repo"
exec codex
