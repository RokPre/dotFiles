#!/bin/sh

# Get the active window's geometry
eval $(xdotool getactivewindow getwindowgeometry --shell)

# Calculate target position (window center)
target_x=$((X + WIDTH / 2))
target_y=$((Y + HEIGHT / 2))

# Log the target position
# echo "Moved mouse to $target_x $target_y" >> ~/.config/i3/scripts/mousemove.log

# Get current mouse position
eval $(xdotool getmouselocation --shell)

# Steps for smooth movement
steps=12 # Increase for smoother motion

# Move mouse in small steps with ease-in-out effect
for i in $(seq 0 $steps); do
    # Calculate easing progress (t)
    t=$(echo "$i / $steps" | bc -l)

    # Ease-in-out function
    if [ $(echo "$t < 0.5" | bc) -eq 1 ]; then
        ease_factor=$(echo "2 * $t * $t" | bc -l)  # Ease-in
    else
        ease_factor=$(echo "(-1 + (4 - 2 * $t) * $t)" | bc -l)  # Ease-out
    fi

    # Calculate new position with eased progress
    new_x=$(echo "$X + ($target_x - $X) * $ease_factor" | bc -l)
    new_y=$(echo "$Y + ($target_y - $Y) * $ease_factor" | bc -l)

    # Move the mouse
    xdotool mousemove $(echo "$new_x / 1" | bc) $(echo "$new_y / 1" | bc)  # Round to nearest integer
done

# Ensure the mouse reaches the exact position
xdotool mousemove $target_x $target_y
