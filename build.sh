#!/bin/bash

docker build \
    --tag torch-cuda-noconda:latest \
    --build-arg CUDA_VERSION=12.8.1 \
    --build-arg PYTHON_VERSION=3.10 \
    --build-arg OS=ubuntu20.04 \
    --build-arg UID=$UID \
    --build-arg USER_NAME=user \
    .
    