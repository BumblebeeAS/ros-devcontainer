#!/usr/bin/env bash
sudo docker build ./simulator-index/ -f ./simulator-index/Dockerfile -t ngxingyu/simulator-index:latest
sudo docker build ./ros-index/ -f ./ros-index/Dockerfile -t ngxingyu/ros-index:latest
sudo docker build ./ -f ./Dockerfile.melodic -t ngxingyu/ros-devcontainer:melodic-desktop
sudo docker build ./ -f ./Dockerfile.noetic -t ngxingyu/ros-devcontainer:noetic-desktop
sudo docker build ./ -f ./Dockerfile.humble -t ngxingyu/ros-devcontainer:humble-desktop
sudo docker build --ssh default=${SSH_AUTH_SOCK} simulators/simulator-uuv/ -f simulators/simulator-uuv/Dockerfile -t ngxingyu/simulator_uuv:latest
sudo docker build --ssh default=${SSH_AUTH_SOCK} simulators/simulator-vrx/ -f simulators/simulator-vrx/Dockerfile -t ngxingyu/simulator_vrx:latest
