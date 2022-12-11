#!/bin/sh

export IMAGE=$(yq '.simulators.[] | select(has("image"))|.image' /index.yaml | fzf --preview "yq '.simulators.[] | select(.image == ."{}")' /index.yaml")
echo "Updating docker-compose.yml to use ${IMAGE} simulation container..."
yq -i '.services.simulator.image = strenv(IMAGE)' /work/docker-compose.yml 
echo "done."
echo "Your simulation environment is ready."
echo "Please enter 'docker-compose up' to launch your environment."
