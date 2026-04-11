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
    | fzf --prompt='Git repo > ' --height=40% --reverse
)" || exit 0

repo_name="$(basename "$repo_path")"

# If it does not find the codex in the path, then revert to backup in the .nvm folder
if ! codex_path="$(command -v codex)"; then
  matches=(/home/*/.nvm/versions/node/v*/bin/codex)

  if [ "${#matches[@]}" -gt 0 ] && [ -x "${matches[0]}" ]; then
    codex_path="${matches[0]}"
  else
    echo "codex not found"
    exit 1
  fi
fi

# exec tmux new-session -c "$repo" 'codex resume' -s "codex-$repo"
exec tmux new-session -A -n "codex" -s "codex-$repo_name" -c "$repo" "$codex_path resume"
