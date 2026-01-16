#!/usr/bin/env bash

enabled=$(xinput list-props "ELAN06FA:00 04F3:327E Touchpad" \
  | grep "Device Enabled" \
  | awk -F: '{print $2}' \
  | tr -d '[:space:]')

xinput set-prop "ELAN06FA:00 04F3:327E Touchpad" "libinput Natural Scrolling Enabled" 1

if [[ "$enabled" == "1" ]]; then
  xinput disable "ELAN06FA:00 04F3:327E Touchpad"
  xdotool mousemove 0 0
else
  xinput enable "ELAN06FA:00 04F3:327E Touchpad"
fi
