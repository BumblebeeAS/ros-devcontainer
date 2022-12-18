#!/usr/bin/env bash
sudo docker build --ssh default=${SSH_AUTH_SOCK} simulators/simulator-uuv/ -f simulators/simulator-uuv/Dockerfile
sudo docker build --ssh default=${SSH_AUTH_SOCK} simulators/simulator-vrx/ -f simulators/simulator-vrx/Dockerfile


# docker build ./docker-xserver -f Dockerfile -t ngxingyu/xserver:latest
# DOCKER_BUILDKIT=1 docker build docker-xserver -f Dockerfile -t ngxingyu/xserver:latest --ssh default=$HOME/.ssh/id_ed25516a .
# target "simulator-index" {
#   context = "./simulator-index"
#   dockerfile = "Dockerfile"
#   tags = ["ngxingyu/simulator-index:latest"]
# }
# target "ros-index" {
#   context = "./ros-index"
#   dockerfile = "Dockerfile"
#   tags = ["ngxingyu/ros-index:latest"]
# }

# target "melodic_dev" {
#   context = "./"
#   dockerfile = "Dockerfile.melodic"
#   tags = ["ngxingyu/ros-devcontainer:melodic-desktop"]
# }
# target "noetic_dev" {
#   context = "./"
#   dockerfile = "Dockerfile.noetic"
#   tags = ["ngxingyu/ros-devcontainer:noetic-desktop"]
# }
# target "humble_dev" {
#   context = "./"
#   dockerfile = "Dockerfile.humble"
#   tags = ["ngxingyu/ros-devcontainer:humble-desktop"]
# }
# target "simulator-vrx" {
#   context = "./simulators/simulator-vrx"
#   dockerfile = "Dockerfile"
#   tags = ["ngxingyu/simulator_vrx:latest"]
# }
# target "simulator-uuv" {
#   context = "./simulators/simulator-uuv"
#   dockerfile = "Dockerfile"
#   tags = ["ngxingyu/simulator_uuv:latest"]
# }