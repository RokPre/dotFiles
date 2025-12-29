#!/bin/bash

# Check if picom is installed
command -v picom >/dev/null || exit

# Check if picom is already running
pgrep -x picom >/dev/null && exit

# Start picom
picom --config ~/.config/picom/unfocused.conf &
