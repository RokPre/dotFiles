#!/bin/bash

step=1000
backlight="/sys/class/backlight/intel_backlight"
curr=$(cat "$backlight/brightness")
max=$(cat "$backlight/max_brightness")

if [ "$1" = "up" ]; then
    new=$((curr + step))
    echo up
elif [ "$1" = "down" ]; then
    new=$((curr - step))
    echo down
else
    exit 1
fi

echo "$new" | sudo tee "$backlight/brightness" > /dev/null
