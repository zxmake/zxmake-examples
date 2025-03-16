#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="${SCRIPT_DIR}/build"

rm "${BUILD_DIR}" -rf
mkdir "${BUILD_DIR}"
cd "${BUILD_DIR}"

# 从 xmake/02-cross-build/g++-aarch64-linux-gnu 项目编译命令里抠出来的
/usr/bin/cmake -DCMAKE_BUILD_TYPE=Release -G "Unix Makefiles" \
    -DCMAKE_AR=/usr/bin/aarch64-linux-gnu-gcc-ar -DCMAKE_STATIC_LINKER_FLAGS= -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=BOTH \
    -DCMAKE_RANLIB=/usr/bin/aarch64-linux-gnu-gcc-ranlib -DCMAKE_SYSTEM_NAME=Linux \
    -DCMAKE_C_COMPILER=/usr/bin/aarch64-linux-gnu-gcc \
    -DCMAKE_CXX_COMPILER=/usr/bin/aarch64-linux-gnu-g++ \
    "-DCMAKE_CXX_LINK_EXECUTABLE=/usr/bin/aarch64-linux-gnu-g++ <FLAGS> <CMAKE_CXX_LINK_FLAGS> <LINK_FLAGS> <OBJECTS> -o <TARGET> <LINK_LIBRARIES>" \
    -DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=BOTH -DCMAKE_OSX_SYSROOT= -DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER \
    -DCMAKE_FIND_USE_CMAKE_SYSTEM_PATH=0 \
    "-DCMAKE_C_FLAGS_RELEASE= -O3 -DNDEBUG" "-DCMAKE_CXX_FLAGS_RELEASE= -O3 -DNDEBUG" -DCMAKE_STATIC_LINKER_FLAGS_RELEASE= \
    -DCMAKE_SHARED_LINKER_FLAGS_RELEASE= -DCMAKE_EXE_LINKER_FLAGS_RELEASE= ..
make

# ./g++-aarch64-linux-gnu

cd -
