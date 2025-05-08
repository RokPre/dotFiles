#!/bin/bash
/usr/bin/xrandr --auto
/usr/bin/xrandr --output HDMI-1 --above eDP-1 --rotate normal
/usr/bin/xrandr --output DP-1 --right-of HDMI-1 --rotate right

