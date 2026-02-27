#!/bin/sh

# Capture screenshot
scrot -o /tmp/screenshot.png
# Blur screenshot
magick /tmp/screenshot.png -blur 0x5 /tmp/screenshot.png
# Mute
amixer set Master mute > /dev/null
# Lock
i3lock -i /tmp/screenshot.png
