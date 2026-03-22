#!/bin/bash

IMAGE_NAME=torch-cuda-uv:latest
CUDA_VERSION=12.8.1
UBUNTU_VERSION=20.04
PYTHON_VERSION=3.10
USER_NAME=${USER:-user}

docker build \
    --tag ${IMAGE_NAME} \
    --build-arg CUDA_VERSION=${CUDA_VERSION} \
    --build-arg UBUNTU_VERSION=${UBUNTU_VERSION} \
    --build-arg PYTHON_VERSION=${PYTHON_VERSION} \
    --build-arg UID=$UID \
    --build-arg USER_NAME=${USER_NAME} \
    .
