# https://stackoverflow.com/questions/76081863/docker-image-with-cuda-and-ros2-on-ubuntu-22-04

ARG UBUNTU_VERSION=20.04
ARG CUDA_VERSION=12.8.1

FROM nvidia/cuda:${CUDA_VERSION}-cudnn-devel-ubuntu${UBUNTU_VERSION}

ARG PYTHON_VERSION=3.10
ARG UID=
ARG USER_NAME=

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8

SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    ccache \
    cmake \
    curl \
    git \
    libbz2-dev \
    libegl1 \
    libffi-dev \
    libgdbm-dev \
    libgl1 \
    libglew-dev \
    libglvnd0 \
    libgles2 \
    liblzma-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libnss3-dev \
    libosmesa6-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    lzma \
    mesa-utils \
    pkg-config \
    python3-tk \
    software-properties-common \
    ssh \
    sudo \
    unzip \
    vainfo \
    vim \
    wget \
    xz-utils \
    zlib1g-dev && \
    rm -rf /var/lib/apt/lists/*

# Default Docker behavior often falls back to CPU rendering.
# These settings make EGL/NVIDIA the default path inside the container.
ENV MUJOCO_GL=egl
ENV PYOPENGL_PLATFORM=egl
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=all
ENV __EGL_VENDOR_LIBRARY_DIRS=/usr/share/glvnd/egl_vendor.d
ENV __GLX_VENDOR_LIBRARY_NAME=nvidia

RUN mkdir -p /usr/share/glvnd/egl_vendor.d && \
    printf '%s\n' \
    '{"file_format_version":"1.0.0","ICD":{"library_path":"libEGL_nvidia.so.0"}}' \
    > /usr/share/glvnd/egl_vendor.d/10_nvidia.json

RUN adduser "${USER_NAME}" -u "${UID}" --quiet --gecos "" --disabled-password && \
    echo "${USER_NAME} ALL=(root) NOPASSWD:ALL" > "/etc/sudoers.d/${USER_NAME}" && \
    chmod 0440 "/etc/sudoers.d/${USER_NAME}"

RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config && \
    echo "PermitEmptyPasswords yes" >> /etc/ssh/sshd_config && \
    echo "UsePAM no" >> /etc/ssh/sshd_config

USER ${USER_NAME}
WORKDIR /home/${USER_NAME}

RUN curl -LsSf https://astral.sh/uv/install.sh | sh
