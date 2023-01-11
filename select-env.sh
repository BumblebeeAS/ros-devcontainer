#!/bin/sh
# docker pull devrt/simulator-index
docker run -ti --rm -v $(pwd):/work select-index:latest
