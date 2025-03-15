#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="${SCRIPT_DIR}/build"
rm "${BUILD_DIR}" -rf
mkdir "${BUILD_DIR}"
cd "${BUILD_DIR}"

cmake ..
# 格式化源文件
make VERBOSE=1 format

# 检查代码是否符合格式化标准
make VERBOSE=1 format-check

# 检查是否有代码被修改了
# make VERBOSE=1 format-check-changed
cd -
