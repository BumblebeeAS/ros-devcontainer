#!/bin/bash
set -e

# setup ros2 environment
source "/opt/ros/$ROS_DISTRO/setup.bash" --
[ -d "~/catkin_ws/devel/" ] && source "~/catkin_ws/devel/setup.bash" --
exec "$@"
