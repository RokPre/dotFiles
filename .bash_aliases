alias diploma="cd ~/sync/faks3/2.\ Diplomsko\ delo/"
alias diplomaPython="cd ~/sync/faks3/2.\ Diplomsko\ delo/python"
alias diplomaMatlab="cd ~/sync/faks3/2.\ Diplomsko\ delo/matlab"

alias cleanNvim="rm -rf ~/.local/share/nvim ~/.local/share/nvim ~/.cache/nvim"

# Ros
alias ctb="ssh ubuntu@192.168.9.130"
alias teleop="roslaunch turtlebot3_teleop turtlebot3_teleop_key.launch"
alias navigation="roslaunch turtlebot3_navigation turtlebot3_navigation.launch map_file:=$HOME/map.yaml"
alias slam="roslaunch turtlebot3_slam turtlebot3_slam.launch"
alias saveMap="rosrun map_server map_saver -f ~/sync/2.\ Diplomsko\ delo/ros/map.yaml"

alias mainserver-suspend="ssh mainservercontroller@100.64.70.128 'mainserver-suspend'"
alias mainserver-wake="ssh mainservercontroller@100.64.70.128 'mainserver-wake'"

echo "Finished sourcing aliases"
