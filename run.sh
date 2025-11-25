#!/bin/bash

docker run -it \
	--name=khkim-env \
    --gpus=all \
    --ipc=host \
    -v=/tmp/.X11-unix:/tmp/.X11-unix:rw \
	-v=/data1/ws/khkim:/home/$USER \
	-e=DISPLAY=unix$DISPLAY \
    -w=/home/$USER \
    torch-cuda-noconda:latest \
    /bin/bash