#!/bin/sh

for dist in melodic noetic
do
    docker pull ros:$dist
    docker build --build-arg BASE_IMAGE=ros:$dist -f Dockerfile -t ngxingyu/ros-devcontainer:$dist-desktop .
done