#!/bin/sh

export ROS_IMAGE=$(yq '.ros.[] | select(has("image"))|.image' /ros-index.yaml | fzf)
echo "Updating docker-compose.yml to use ${ROS_IMAGE} ros base image ..."
yq -i '.services.workspace.image = strenv(ROS_IMAGE)' /work/docker-compose.yml
echo "done."
echo "Your ros environment is ready."

export SIM_IMAGE=$(yq '.simulators.[] | select(has("image"))|.image' /simulator-index.yaml | fzf --preview "yq '.simulators.[] | select(.image==\"{}\")' /simulator-index.yaml")
echo "Updating docker-compose.yml to use ${SIM_IMAGE} simulation container..."
yq -i '.services.simulator.image = strenv(SIM_IMAGE)' /work/docker-compose.yml
export VOLUME="./.volumes/${ROS_IMAGE}:/workspace"
yq -i '.services.workspace.volumes.[] |= strenv(VOLUME)' /work/docker-compose.yml
echo "done."
echo "Your simulation environment is ready."
echo "Please enter 'docker-compose up' to launch your environment."
