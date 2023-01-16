#!/bin/bash
set -e

# setup ros2 environment
source "/opt/ros/$ROS_DISTRO/setup.bash" --
source "/root/uuv_ws/devel/setup.bash" --
# source "/root/catkin_ws/devel/setup.bash" --
exec "$@"
