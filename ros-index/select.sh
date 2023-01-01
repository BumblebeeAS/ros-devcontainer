#!/bin/sh

export IMAGE=$(yq '.ros.[] | select(has("image"))|.image' /index.yaml | fzf)
echo "Updating docker-compose.yml to use ${IMAGE} ros base image ..."
yq -i '.services.workspace.image = "ros-devcontainer:"+strenv(IMAGE)+"-dev"' /work/docker-compose.yml
echo "done."
echo "Your ros environment is ready."
echo "Please enter 'docker-compose up' to launch your environment."
