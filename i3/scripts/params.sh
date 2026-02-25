#!/bin/sh

. /etc/os-release

params="$HOME/.config/i3/params"

browser_cmd="$(command -v qutebrowser 2>/dev/null || command -v vivaldi 2>/dev/null || true)"

[ -n "$browser_cmd" ] || { echo "qutebrowser or vivaldi not found in PATH" >&2; exit 1; }

cat > "$params" <<EOF
# Look at scripts/params.sh
exec_always --no-startup-id ~/.config/i3/scripts/params.sh

set \$browser_cmd $browser_cmd

bindsym \$mod+Ctrl+i exec --no-startup-id \$browser_cmd; workspace \$ws2
EOF
