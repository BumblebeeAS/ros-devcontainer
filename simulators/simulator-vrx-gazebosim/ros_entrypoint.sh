#!/bin/bash
set -e

# setup ros2 environment
source "/opt/ros/$ROS_DISTRO/setup.bash" --
[ -d "/home/developer/colcon_ws/install/" ] && source "/home/developer/colcon_ws/install/setup.bash" --
exec "$@"
