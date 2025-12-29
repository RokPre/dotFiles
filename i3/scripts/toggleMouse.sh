#!/usr/bin/env bash

enabled=$(xinput list-props "ELAN06FA:00 04F3:327E Touchpad" \
  | grep "Device Enabled" \
  | awk -F: '{print $2}' \
  | tr -d '[:space:]')

if [[ "$enabled" == "1" ]]; then
  xinput disable "ELAN06FA:00 04F3:327E Touchpad"
  xdotool mousemove 0 0
else
  xinput enable "ELAN06FA:00 04F3:327E Touchpad"
fi
