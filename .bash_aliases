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
alias mainserver-mount="sudo mount -t cifs //100.127.238.46/Cloud ~/cloud/ -o credentials=/home/$USER/offline/credentials/mainServerSmb,uid=1000,gid=1000,iocharset=utf8,vers=3.0"
alias mainserver-unmount='sudo umount ~/cloud || sudo umount -l ~/cloud'
alias mainserver-ssh="ssh roksmainserver@100.127.238.46 -L 18384:localhost:8384"
# rsync -avh --progress --partial --append-verify /home/rok/offline/downloads/takeout-20250922T193838Z-1-001.zip ~/cloud/
alias mainserver-rsync=""

# Terminal
alias c="clear"

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
