#!/bin/sh
# docker pull devrt/ros-index
docker run -ti --rm -v $(pwd):/work ros-index:latest
