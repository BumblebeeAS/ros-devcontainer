#!/bin/bash
set -e

# setup ros2 environment
source "/opt/ros/$ROS_DISTRO/setup.bash" --
[ -d "/home/developer/catkin_ws/devel/" ] && source "/home/developer/catkin_ws/devel/setup.bash" --
exec "$@"
