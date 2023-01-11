#!/usr/bin/env bash
# sudo docker build ./simulator-index/ -f ./simulator-index/Dockerfile -t ngxingyu/simulator-index:latest
# sudo docker build ./ros-index/ -f ./ros-index/Dockerfile -t ngxingyu/ros-index:latest
sudo docker build ./select-index/ -f ./select-index/Dockerfile -t select-index
# sudo docker build ./ -f ./Dockerfile.melodic -t ngxingyu/ros-devcontainer:melodic-desktop
# sudo docker build ./devcontainers/noetic -f ./devcontainers/noetic/Dockerfile.base -t ros-devcontainer:noetic-base
# sudo docker build ./ -f ./devcontainers/noetic/Dockerfile -t ros-devcontainer:noetic-dev
# sudo docker build ./ -f ./Dockerfile.humble -t ngxingyu/ros-devcontainer:humble-desktop
# sudo docker build --ssh default=${SSH_AUTH_SOCK} simulators/simulator-uuv/ -f simulators/simulator-uuv/Dockerfile -t ngxingyu/simulator_uuv:latest
# export SSH_AUTH_SOCK="/home/phli/.ssh/id_ed25519"
# sudo docker build --ssh default=${SSH_AUTH_SOCK} simulators/simulator-vrx/ -f simulators/simulator-vrx/Dockerfile -t simulator_vrx:latest
