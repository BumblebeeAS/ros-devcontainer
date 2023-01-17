#!/usr/bin/env bash

# sudo docker build ./select-index -f ./select-index/Dockerfile -t select-index

## base ros images used by devcontainer and base simulator images
# sudo docker build ./ -f ./devcontainers/melodic/Dockerfile.base -t ros-devcontainer:melodic-base
# sudo docker build ./ -f ./devcontainers/noetic/Dockerfile.base -t ros-devcontainer:noetic-base
# sudo docker build ./ -f ./devcontainers/humble/Dockerfile.base -t ros-devcontainer:humble-base

# sudo docker build ./ -f ./devcontainers/melodic/Dockerfile -t ros-devcontainer:melodic-dev
# sudo docker build ./ -f ./devcontainers/noetic/Dockerfile -t ros-devcontainer:noetic-dev
# sudo docker build ./ -f ./devcontainers/humble/Dockerfile -t ros-devcontainer:humble-dev


## base simulator images
# sudo docker build simulators/simulator-uuv/ -f simulators/simulator-uuv/Dockerfile.base -t ngxingyu/simulator_uuv_base:latest
# sudo docker build simulators/simulator-vrx/ -f simulators/simul/ator-vrx/Dockerfile.base -t ngxingyu/simulator_vrx_base:latest
# sudo docker build simulators/simulator-vrx-gazebosim/ -f simulators/simulator-vrx-gazebosim/Dockerfile.base -t ngxingyu/simulator_vrx_gazebosim_base:latest

# allow the container to access our github repos
# eval $(ssh-agent -s)
# ssh-add ~/.ssh/YOUR_PRIVATE_KEY_WITH_GITHUB_ACCESS

# sudo docker build --ssh default=${SSH_AUTH_SOCK} simulators/simulator-uuv/ -f simulators/simulator-uuv/Dockerfile -t simulator_uuv:latest
# sudo docker build --ssh default=${SSH_AUTH_SOCK} simulators/simulator-vrx/ -f simulators/simulator-vrx/Dockerfile -t simulator_vrx:latest
# sudo docker build --ssh default=${SSH_AUTH_SOCK} simulators/simulator-vrx-gazebosim/ -f simulators/simulator-vrx-gazebosim/Dockerfile -t simulator_vrx_gazebosim:latest  