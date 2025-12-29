# When capslock is pressed it will work as escape,
# when it is pressed with another key it will work as control.

# Rebind capslock to control
setxkbmap -option ctrl:nocaps

# Rebind capslock to escape
xcape -e 'Control_L=Escape'

# Makes sure that caps lock is off when you start your session.
xset -q | grep -q "Caps Lock:   on" && xdotool key Caps_Lock
