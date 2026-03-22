#!/bin/bash

IMAGE_NAME=torch-cuda-uv:latest
CONTAINER_NAME=khkim-env
USER_NAME=${USER:-user}
HOST_ROOT=/data1/ws/khkim
CONTAINER_ROOT=/home/${USER_NAME}

docker run -it \
	--name=${CONTAINER_NAME} \
    --gpus=all \
    --shm-size=16g \
    --ipc=host \
    -v=/tmp/.X11-unix:/tmp/.X11-unix:rw \
	-v=${HOST_ROOT}:${CONTAINER_ROOT} \
	-e=DISPLAY=unix$DISPLAY \
    -e=NVIDIA_DRIVER_CAPABILITIES=all \
    -e=NVIDIA_VISIBLE_DEVICES=all \
    -w=${CONTAINER_ROOT} \
    ${IMAGE_NAME} \
    /bin/bash
