#!/usr/bin/env bash
#
# Typical usage: ./join.bash <container_name>
#

CONTAINER_ID=$1
COMMAND=$2

xhost +
[[ -n $COMMAND ]] && docker exec --privileged -e DISPLAY=${DISPLAY} -e LINES=`tput lines` -it ${CONTAINER_ID} bash -c "${COMMAND}"
[[ -z $COMMAND ]] && docker exec --privileged -e DISPLAY=${DISPLAY} -e LINES=`tput lines` -it ${CONTAINER_ID} bash
xhost -
