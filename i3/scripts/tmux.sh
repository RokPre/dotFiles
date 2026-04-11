#!/usr/bin/env bash

set -euo pipefail

roots=(
  "$HOME/sync"
  "$HOME/offline"
)

repo_path="$(
  find "${roots[@]}" -maxdepth 4 -type d -name .git 2>/dev/null \
    | sed 's#/.git$##' \
    | sort -u \
    | fzf --prompt='Git repo > ' --height=40% --reverse
)" || exit 0

repo_name="$(basename "$repo_path")"

exec tmux new-session -A -s "$repo_name" -n "$repo_name" -c "$repo_path"
