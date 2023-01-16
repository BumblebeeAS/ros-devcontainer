#!/bin/sh
# docker pull devrt/simulator-index
docker pull ghcr.io/ngxingyu/select-index:latest
docker run -ti --rm -v $(pwd):/work ghcr.io/ngxingyu/select-index:latest

# docker run -ti --rm -v $(pwd):/work select-index:latest
