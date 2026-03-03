#!/bin/sh

# Mute
amixer set Master mute > /dev/null
# Pause
playerctl pause

# Capture screenshot
scrot -o /tmp/screenshot.png
# Blur screenshot
$(command -v magick || command -v convert) /tmp/screenshot.png -blur 0x5 /tmp/screenshot.png
# Lock
i3lock -n -i /tmp/screenshot.png

# Unmute
amixer set Master unmute > /dev/null
# Resume
playerctl play
