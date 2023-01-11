#!/bin/sh

export IMAGE=$(yq '.ros.[] | select(has("image"))|.image' /ros-index.yaml | fzf)
echo "Updating docker-compose.yml to use ${IMAGE} ros base image ..."
yq -i '.services.workspace.image = "ros-devcontainer:"+strenv(IMAGE)+"-dev"' /work/docker-compose.yml
echo "done."
echo "Your ros environment is ready."

export IMAGE=$(yq '.simulators.[] | select(has("image"))|.image' /simulator-index.yaml | fzf --preview "yq '.simulators.[] | select(.image==\"{}\")' /simulator-index.yaml")
# export IMAGE=$(yq '.simulators.[] | select(has("image"))|.image' /simulator-index.yaml | fzf --preview "yq '.simulators.[] | select(.image == ."{}")' /simulator-index.yaml")
echo "Updating docker-compose.yml to use ${IMAGE} simulation container..."
yq -i '.services.simulator.image = strenv(IMAGE)' /work/docker-compose.yml
echo "done."
echo "Your simulation environment is ready."
echo "Please enter 'docker-compose up' to launch your environment."
