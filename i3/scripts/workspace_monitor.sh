#!/bin/bash

# Define workspace names
ws1=$1
ws2=$2
ws3=$3
ws4=$4
ws5=$5

sleep $6

# Get connected outputs
outputs=($(xrandr | awk '/ connected/ {print $1}'))

# Helper function
move_ws_to_output() {
  i3-msg "workspace $1; move workspace to output $2"
}

# Fallback: single-monitor setup
if [ "${#outputs[@]}" -eq 1 ]; then
  move_ws_to_output "$ws1" "${outputs[0]}"
  move_ws_to_output "$ws2" "${outputs[0]}"
  move_ws_to_output "$ws3" "${outputs[0]}"
  move_ws_to_output "$ws4" "${outputs[0]}"
  move_ws_to_output "$ws5" "${outputs[0]}"
elif [ "${#outputs[@]}" -eq 2 ]; then
  # Two-monitor setup (customize as needed)
  move_ws_to_output "$ws3" "${outputs[1]}"
  move_ws_to_output "$ws4" "${outputs[0]}"
  move_ws_to_output "$ws5" "${outputs[1]}"
  move_ws_to_output "$ws1" "${outputs[0]}"
  move_ws_to_output "$ws2" "${outputs[1]}"
elif [ "${#outputs[@]}" -eq 3 ]; then
  # Three-monitor setup (customize as needed)
  move_ws_to_output "$ws1" "${outputs[0]}"
  move_ws_to_output "$ws2" "${outputs[1]}"
  # To make ws3 be on top and actually displayed.
  move_ws_to_output "$ws4" "${outputs[2]}"
  move_ws_to_output "$ws3" "${outputs[2]}"
  move_ws_to_output "$ws5" "${outputs[2]}"
fi

i3-msg "workspace $ws1"
