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

alias cm='cd ~/catkin_ws && catkin_make'

# Main server
alias mainserver-suspend="ssh mainservercontroller@100.64.70.128 'mainserver-suspend'"
alias mainserver-wake="ssh mainservercontroller@100.64.70.128 'mainserver-wake'"
alias mainserver-ssh="ssh roksmainserver@193.77.150.218 -L 8080:localhost:8080 -L 7878:localhost:7878 -L 9696:localhost:9696 -L 8686:localhost:8686 -L 8989:localhost:8989"

# Terminal
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

# Trash-put - rm to trash
if command -v trash-put &> /dev/null; then
  alias rm='trash-put'
  alias rip="rm -rf" # explicit force delete
else
  echo "Trash not found"
fi

# Rsync - better copy
if command -v rsync &> /dev/null; then
  alias cp='rsync -avh --progress --partial --append-verify'
else
  echo "Rsync not found"
fi

# Eza - better ls
if command -v eza &> /dev/null; then
  alias ls='eza'
else
  echo "Eza not found"
fi

# Xclip - coppy to clipboard
if command -v xclip &> /dev/null; then
  alias xc="xclip -selection clipboard"
else
  echo "Xclip not found"
fi
