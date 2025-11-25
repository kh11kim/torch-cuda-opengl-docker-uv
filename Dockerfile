#https://stackoverflow.com/questions/76081863/docker-image-with-cuda-and-ros2-on-ubuntu-22-04

ARG UBUNTU_VERSION=20.04
ARG CUDA_VERSION=12.8.1

FROM nvidia/cuda:${CUDA_VERSION}-cudnn-devel-ubuntu${UBUNTU_VERSION}

ARG PYTHON_VERSION=3.10


# Let us install tzdata painlessly
ENV DEBIAN_FRONTEND=noninteractive

# Needed for string substitution
SHELL ["/bin/bash", "-c"]
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    ccache \
    cmake \
    curl \
    git \
    pkg-config \
    software-properties-common \
    ssh \
    sudo \
    unzip \
    vim \
    wget \ 
    vainfo \
    mesa-va-drivers \
    mesa-utils \
    lzma \
    liblzma-dev \
    libssl-dev \
    build-essential \
    libbz2-dev \ 
    libffi-dev \ 
    libgdbm-dev \
    libncurses5-dev \ 
    libncursesw5-dev \
    libnss3-dev \ 
    libreadline-dev \ 
    libsqlite3-dev \ 
    xz-utils \ 
    zlib1g-dev \
    python3-tk
RUN add-apt-repository ppa:oibaf/graphics-drivers -y
RUN rm -rf /var/lib/apt/lists/*

# opengl
ENV LIBVA_DRIVER_NAME=d3d12
ENV LD_LIBRARY_PATH=/usr/lib/wsl/lib
CMD vainfo --display drm --device /dev/dri/card0

# nvidia-docker2
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics
ENV MESA_D3D12_DEFAULT_ADAPTER_NAME=NVIDIA


# See http://bugs.python.org/issue19846 later
ENV LANG C.UTF-8

ARG UID=
ARG USER_NAME=
# Create a user
RUN adduser $USER_NAME -u $UID --quiet --gecos "" --disabled-password
RUN echo "$USER_NAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USER_NAME
RUN chmod 0440 /etc/sudoers.d/$USER_NAME

# For connecting via ssh
RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config && \
    echo "PermitEmptyPasswords yes" >> /etc/ssh/sshd_config && \
    echo "UsePAM no" >> /etc/ssh/sshd_config

# Login to user
USER $USER_NAME
SHELL ["/bin/bash", "-c"]
WORKDIR "/home/${USER_NAME}"

RUN sudo apt-get update -y
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
