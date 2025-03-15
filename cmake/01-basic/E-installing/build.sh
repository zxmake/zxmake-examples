#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="${SCRIPT_DIR}/build"

rm "${BUILD_DIR}" -rf
mkdir "${BUILD_DIR}"
cd "${BUILD_DIR}"
cmake .. -DCMAKE_INSTALL_PREFIX=./release
make
make install

# 读取安装文件列表
cat install_manifest.txt
echo ""

# 运行二进制
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:release/lib release/bin/cmake_examples_inst_bin

cd -
