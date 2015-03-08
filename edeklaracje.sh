#!/bin/bash

COOKIE=`xauth list $DISPLAY | sed -r -e 's/^.+MIT/MIT/'`
XSOCK=/tmp/.X11-unix/X0
IMAGE_NAME="edeklaracje"
CONTAINER_NAME="$IMAGE_NAME"

docker build -t $IMAGE_NAME ./
docker run --rm -v $XSOCK:$XSOCK -ti --name $CONTAINER_NAME $IMAGE_NAME "$COOKIE"