FROM ubuntu:24.04

# set up the environment
RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list \
    && apt-get clean && apt-get update && apt-get install -y --fix-missing \
    build-essential \
    git \
    iputils-ping \
    sudo \
    curl \
    cmake \
    make \
    clang \
    ccache \
    htop \
    wget \
    vim

# clang 18
# RUN wget -qO- https://apt.llvm.org/llvm.sh | bash -s -- 18 \
#     && update-alternatives --remove clang /usr/bin/clang-14 \
#     && update-alternatives --remove clang++ /usr/bin/clang++-14 \
#     && update-alternatives --install /usr/bin/clang clang /usr/bin/clang-18 1 --slave /usr/bin/clang++ clang++ /usr/bin/clang++-18

# install xmake
ENV XMAKE_COMMIT_VERSION v3.0.5
ENV XMAKE_ROOT y
ENV XMAKE_STATS n
ENV XMAKE_PROGRAM_DIR /usr/local/share/xmake
ENV XMAKE_MAIN_REPO https://user:c91b0446f7a94ef081fd447205f7043e1715238690486@ezone.zelostech.com.cn/ezone/zelos/xmake-repo.git
ENV XMAKE_BINARY_REPO https://user:c91b0446f7a94ef081fd447205f7043e1715238690486@ezone.zelostech.com.cn/ezone/zelos/build-artifacts.git

RUN mkdir /software && cd /software \
    && git clone --recursive https://gitee.com/tomocat/xmake.git \
    && cd xmake \
    && git checkout ${XMAKE_COMMIT_VERSION} \
    && bash scripts/install.sh \
    && xmake --version \
    && cd / && rm -r software

# RUN mkdir /software && cd /software \
#     && wget https://github.com/bazelbuild/bazel/releases/download/8.1.1/bazel-8.1.1-linux-x86_64
