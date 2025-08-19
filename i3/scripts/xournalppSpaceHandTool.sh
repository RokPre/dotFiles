#!/bin/bash

DEVICE="/dev/input/event3"
SPACE_KEY="KEY_SPACE"
STATE=0

get_active_app() {
  xdotool getwindowfocus getwindowname 2>/dev/null
}

evtest "$DEVICE" | while read -r line; do
  echo "$line" | grep -q "$SPACE_KEY" || continue

  if echo "$line" | grep -q "value 1"; then
    if [[ "$STATE" == "0" ]] && [[ "$(get_active_app | tr '[:upper:]' '[:lower:]')" == *xournal++* ]]; then
      xdotool keydown ctrl+shift+a
      STATE=1
    fi
  elif echo "$line" | grep -q "value 0"; then
    if [[ "$STATE" == "1" ]]; then
      xdotool keyup ctrl+shift+a
      xdotool key ctrl+shift+p
      STATE=0
    fi
  fi
done

