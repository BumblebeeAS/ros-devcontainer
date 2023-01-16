#!/bin/bash
set -e

# setup ros2 environment
source "/opt/ros/$ROS_DISTRO/setup.bash" --
source "/root/vrx_ws/install/setup.bash" --
# source "/root/catkin_ws/install/setup.bash" --
exec "$@"
