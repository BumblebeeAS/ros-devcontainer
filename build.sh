#!/usr/bin/env bash
# sudo docker build ./simulator-index/ -f ./simulator-index/Dockerfile -t ngxingyu/simulator-index:latest
# sudo docker build ./ros-index/ -f ./ros-index/Dockerfile -t ngxingyu/ros-index:latest
sudo docker build ./select-index -f ./select-index/Dockerfile -t select-index
# sudo docker build ./ -f ./devcontainers/melodic/Dockerfile.base -t ros-devcontainer:melodic-base
sudo docker build ./ -f ./devcontainers/noetic/Dockerfile.base -t ros-devcontainer:noetic-base
sudo docker build ./ -f ./devcontainers/humble/Dockerfile.base -t ros-devcontainer:humble-base
# sudo docker build ./ -f ./devcontainers/melodic/Dockerfile -t ros-devcontainer:melodic-dev
sudo docker build ./ -f ./devcontainers/noetic/Dockerfile -t ros-devcontainer:noetic-dev
sudo docker build ./ -f ./devcontainers/humble/Dockerfile -t ros-devcontainer:humble-dev

sudo docker build --ssh default=${SSH_AUTH_SOCK} simulators/simulator-uuv/ -f simulators/simulator-uuv/Dockerfile -t simulator_uuv:latest
sudo docker build --ssh default=${SSH_AUTH_SOCK} simulators/simulator-vrx=/ -f simulators/simulator-vrx/Dockerfile -t simulator_vrx:latest
sudo docker build --ssh default=${SSH_AUTH_SOCK} simulators/simulator-vrx-gazebosim/ -f simulators/simulator-vrx-gazebosim/Dockerfile -t simulator_vrx_gazebosim:latest
# export SSH_AUTH_SOCK="/home/phli/.ssh/id_ed25519"
# sudo docker build --ssh default=${SSH_AUTH_SOCK} simulators/simulator-uuv/ -f simulators/simulator-uuv/Dockerfile -t simulator_uuv:latest