# Nvim
alias nvimDeleteLocal="rm -rf ~/.local/share/nvim ~/.local/share/nvim ~/.cache/nvim"
alias nvimClean="nvim --clean"
alias v="nvim"

alias nvimLazy='NVIM_APPNAME="nvimLazy" nvim'
alias nvimAstro='NVIM_APPNAME="nvimAstro" nvim'
alias nvimChad='NVIM_APPNAME="nvimChad" nvim'
alias nvimMinMax='NVIM_APPNAME="nvimMinMax" nvim'

# Ros
alias teleop="roslaunch turtlebot3_teleop turtlebot3_teleop_key.launch"
alias navigation="roslaunch turtlebot3_navigation turtlebot3_navigation.launch map_file:=$HOME/map.yaml"
alias slam="roslaunch turtlebot3_slam turtlebot3_slam.launch"
alias saveMap="rosrun map_server map_saver -f ~/sync/2.\ Diplomsko\ delo/ros/map.yaml"
alias rosKill="rosnode kill -a && killall -9 rosmaster rosout roslaunch gzserver gzclient"
alias tfTreeView="rosrun tf view_frames && zathura frames.pdf"
alias turtlebot3Sync="rsync -av --delete ~/catkin_ws/src/pametna_tovarna/ ubuntu@192.168.9.140:~/catkin_ws/src/pametna_tovarna/"
alias rostopic="ros2 topic"
alias rosnode="ros2 node"

alias cm='cd ~/catkin_ws && catkin_make'

# Main server
alias mainserver-suspend="ssh mainservercontroller@100.64.70.128 'mainserver-suspend'"
alias mainserver-wake="ssh mainservercontroller@100.64.70.128 'mainserver-wake'"
alias mainserver-ssh="ssh roksmainserver@193.77.150.218"
alias mainserver-ping="ping 193.77.150.218"

# Tailscale
alias ts="tailscale"
alias tss="tailscale status"

# Other
alias open="xdg-open"

# Tmux
if command -v tmux >/dev/null 2>&1; then
  alias c="clear && tmux clear-history"
else
  alias c="clear"
fi

if [[ -f ~/sync/dotFiles/.bashrc ]]; then
  alias sb='source ~/sync/dotFiles/.bashrc'
else
  alias sb='source ~/.bashrc'
fi

# Zoxide - smarter cd
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init bash)"
  alias cd="z"
else
  echo "Zoxide not found"
fi

# Trash-put - rm to trash
if command -v trash-put &> /dev/null; then
  alias rm='trash-put'
  alias rip="rm -rf" # explicit force delete
else
  echo "Trash not found"
fi

# Rsync - better copy
if command -v rsync &> /dev/null; then
  alias cp='rsync -avhc --progress --partial --append-verify'
else
  echo "Rsync not found"
fi

# Eza - better ls
if command -v eza &> /dev/null; then
  alias ls='eza'
elif command -v lsd &> /dev/null; then
  alias ls='lsd'
else
  echo "Eza or lsd not found"
fi

# Xclip - coppy to clipboard
if command -v xclip &> /dev/null; then
  alias xc="xclip -selection clipboard"
else
  echo "Xclip not found"
fi
