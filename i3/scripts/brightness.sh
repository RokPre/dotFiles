#!/bin/bash

if [ "$1" = "up" ]; then
    /usr/bin/brightnessctl set +5%
elif [ "$1" = "down" ]; then
    /usr/bin/brightnessctl set 5%-
fi
