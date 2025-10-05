# Diploma
shopt -s cdable_vars
export diploma="$HOME/sync/faks3/2. Diplomsko delo"
alias diplomaPython="cd ~/sync/faks3/2.\ Diplomsko\ delo/python"
alias diplomaMatlab="cd ~/sync/faks3/2.\ Diplomsko\ delo/matlab"

# Nvim
alias nvimClearConfig="rm -rf ~/.local/share/nvim ~/.local/share/nvim ~/.cache/nvim"
alias nvimClean="nvim --clean"
alias v="nvim"

alias nvimLazy='NVIM_APPNAME="nvimLazy" nvim'
alias nvimAstro='NVIM_APPNAME="nvimAstro" nvim'
alias nvimChad='NVIM_APPNAME="nvimChad" nvim'

# Ros
alias teleop="roslaunch turtlebot3_teleop turtlebot3_teleop_key.launch"
alias navigation="roslaunch turtlebot3_navigation turtlebot3_navigation.launch map_file:=$HOME/map.yaml"
alias slam="roslaunch turtlebot3_slam turtlebot3_slam.launch"
alias saveMap="rosrun map_server map_saver -f ~/sync/2.\ Diplomsko\ delo/ros/map.yaml"
alias rosKill="rosnode kill -a && killall -9 rosmaster rosout roslaunch gzserver gzclient"
alias tfTreeView="rosrun tf view_frames && zathura frames.pdf"

# Main server
alias mainserver-suspend="ssh mainservercontroller@100.64.70.128 'mainserver-suspend'"
alias mainserver-wake="ssh mainservercontroller@100.64.70.128 'mainserver-wake'"
alias mainserver-mount="sudo mount -t cifs //100.127.238.46/Cloud ~/cloud/ -o credentials=/home/$USER/offline/credentials/mainServerSmb,uid=1000,gid=1000,iocharset=utf8,vers=3.0"
alias mainserver-unmount='sudo umount ~/cloud || sudo umount -l ~/cloud'
alias mainserver-ssh="ssh roksmainserver@100.127.238.46"
# rsync -avh --progress --partial --append-verify /home/rok/offline/downloads/takeout-20250922T193838Z-1-001.zip ~/cloud/
alias mainserver-rsync=""

# Terminal
alias c="clear"

# Pametna tovarna
export pametnaTovarna="$HOME/catkin_ws/src/pametna_tovarna_pc/"

# Trash
if command -v trash-put &> /dev/null; then
    alias rm='trash-put'
fi

# Copy
if command -v rsync &> /dev/null; then
  alias cp='rsync -avh --progress --partial --append-verify'
fi
