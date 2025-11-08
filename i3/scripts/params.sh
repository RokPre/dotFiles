#!/bin/sh

. /etc/os-release

params=~/.config/i3/params

case "$ID" in
  ubuntu)
    nvim_bin="/opt/nvim-linux-x86_64/bin/nvim"
    browser_cmd="/usr/bin/vivaldi"
    ;;
  arch)
    nvim_bin="/usr/bin/nvim"
    browser_cmd="/usr/bin/qutebrowser"
    ;;
  *)
    nvim_bin="$(command -v nvim)"
    browser_cmd="$(command -v qutebrowser)"
    ;;
esac

# overwrite the params file each time (not append!)
cat > "$params" <<EOF
# Look at scripts/params.sh
exec_always --no-startup-id ~/.config/i3/scripts/params.sh

set \$nvim_bin $nvim_bin
set \$browser_cmd $browser_cmd

bindsym \$mod+Ctrl+n exec --no-startup-id /usr/bin/neovide --neovim-bin $nvim_bin; workspace \$ws1
bindsym \$mod+Ctrl+i exec --no-startup-id sh -c '$browser_cmd'; workspace \$ws2
EOF
