#!/bin/bash
set -e

# setup ros2 environment
source "/opt/ros/$ROS_DISTRO/setup.bash" --
source "/root/vrx_ws/install/setup.bash" --
[ -d "/root/colcon_ws/install/" ] && source "/root/colcon_ws/install/setup.bash" --
exec "$@"
