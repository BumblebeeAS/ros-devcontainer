#!/bin/sh
docker pull ghcr.io/ngxingyu/select-index:latest
docker run -ti --rm -v $(pwd):/work ghcr.io/ngxingyu/select-index:latest