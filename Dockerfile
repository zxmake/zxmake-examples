FROM nvcr.io/nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04

# set up the environment
RUN sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list \
    && apt-get clean && apt-get update && apt-get install -y --fix-missing \
    build-essential \
    git \
    iputils-ping \
    sudo \
    curl \
    cmake \
    make \
    clang \
    htop \
    wget \
    vim

# clang 18
# RUN wget -qO- https://apt.llvm.org/llvm.sh | bash -s -- 18 \
#     && update-alternatives --remove clang /usr/bin/clang-14 \
#     && update-alternatives --remove clang++ /usr/bin/clang++-14 \
#     && update-alternatives --install /usr/bin/clang clang /usr/bin/clang-18 1 --slave /usr/bin/clang++ clang++ /usr/bin/clang++-18

# install xmake
ENV XMAKE_COMMIT_VERSION=v3.0.5
ENV XMAKE_ROOT=y
ENV XMAKE_STATS=n
ENV XMAKE_PROGRAM_DIR=/usr/local/share/xmake
ENV XMAKE_MAIN_REPO=https://github.com/zxmake/zxmake-repo.git
ENV XMAKE_BINARY_REPO=https://github.com/zxmake/zxmake-build-artifacts.git

RUN mkdir /software && cd /software \
    && git clone --recursive https://github.com/TOMO-CAT/xmake.git \
    && cd xmake \
    && git checkout ${XMAKE_COMMIT_VERSION} \
    && bash scripts/install.sh \
    && xmake --version \
    && cd / && rm -r software

# RUN mkdir /software && cd /software \
#     && wget https://github.com/bazelbuild/bazel/releases/download/8.1.1/bazel-8.1.1-linux-x86_64 \
#     && chmod +x bazel-8.1.1-linux-x86_64 \
#     && mv bazel-8.1.1-linux-x86_64 /usr/local/bin/bazel \
#     && bazel --version \
#     && cd / && rm -r software
ADD docker/bazel-8.1.1-linux-x86_64 /usr/local/bin/bazel

# RUN mkdir /software && cd /software \
#     && wget https://github.com/bazelbuild/buildtools/releases/download/6.0.1/buildifier-linux-amd64 \
#     && chmod +x buildifier-linux-amd64 \
#     && mv buildifier-linux-amd64 /usr/local/bin/buildifier \
#     && buildifier --version \
#     && cd / && rm -r software
ADD docker/buildifier-linux-amd64 /usr/local/bin/buildifier

# install zig
# https://github.com/ziglang/docker-zig
# https://github.com/antonputra/tutorials/blob/main/lessons/208/http.zig/Dockerfile
#
# 下载页面: https://ziglang.org/download/
ENV ZIG_VER=0.14.0
RUN mkdir /software && cd /software \
    && curl https://ziglang.org/builds/zig-linux-$(uname -m)-${ZIG_VER}.tar.xz -o zig-linux.tar.xz \
    && tar xf zig-linux.tar.xz \
    && mv zig-linux-$(uname -m)-${ZIG_VER}/ /opt/zig \
    && cd / && rm -r software
ENV PATH=/opt/zig:$PATH

RUN apt-get install -y --fix-missing \
    clangd \
    ccache \
    clang-format \
    file \
    g++-aarch64-linux-gnu \
    qemu-user-static \
    unzip \
    libboost-all-dev \
    ninja-build \
    python3-dev \
    protobuf-compiler \
    binutils-dev \
    git-lfs \
    python3-pip \
    cppcheck \
    clang-tools \
    llvm

# 需要设置 QEMU_LD_PREFIX, 否则会报错:
# qemu-aarch64-static: Could not open '/lib/ld-linux-aarch64.so.1': No such file or directory
ENV QEMU_LD_PREFIX=/usr/aarch64-linux-gnu

# docker 只能从当前目录获取文件, 不能从宿主机其他目录获取, 所以需要先拷贝到 docker/ 目录下
# COPY docker/.ssh /root/.ssh
# COPY docker/.gitconfig /root/.gitconfig

RUN git config --global --add safe.directory '*'

# cuda 交叉编译环境
# wget https://developer.download.nvidia.cn/compute/cuda/repos/ubuntu2004/cross-linux-aarch64/cuda-driver-cross-aarch64-11-8_11.8.89-1_all.deb
# wget https://developer.download.nvidia.cn/compute/cuda/repos/ubuntu2004/cross-linux-aarch64/cuda-cccl-cross-aarch64-11-8_11.8.89-1_all.deb
# wget https://developer.download.nvidia.cn/compute/cuda/repos/ubuntu2004/cross-linux-aarch64/cuda-cudart-cross-aarch64-11-8_11.8.89-1_all.deb
COPY docker/cuda-cccl-cross-aarch64-11-8_11.8.89-1_all.deb /software/
COPY docker/cuda-cudart-cross-aarch64-11-8_11.8.89-1_all.deb /software/
COPY docker/cuda-driver-cross-aarch64-11-8_11.8.89-1_all.deb /software/
RUN cd /software && \
    dpkg -i cuda-driver-cross-aarch64-11-8_11.8.89-1_all.deb && \
    apt install -y cuda-driver-cross-aarch64-11-8 && \
    dpkg -i cuda-cccl-cross-aarch64-11-8_11.8.89-1_all.deb && \
    apt install -y cuda-cccl-cross-aarch64-11-8 && \
    dpkg -i cuda-cudart-cross-aarch64-11-8_11.8.89-1_all.deb && \
    apt install -y cuda-cudart-cross-aarch64-11-8

ARG USER_NAME=visitor
RUN useradd -m ${USER_NAME}
# 免密执行 sudo 权限
RUN echo "${USER_NAME} ALL=NOPASSWD: ALL" >> /etc/sudoers
USER ${USER_NAME}
