#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="${SCRIPT_DIR}/build"
cd "${SCRIPT_DIR}"

# rm "${BUILD_DIR}" -rf
# mkdir "${BUILD_DIR}"
# cd "${BUILD_DIR}"

# https://stackoverflow.com/questions/68172416/scan-build-not-working-reporting-removing-directory-xxx-because-it-contains-no
# sudo apt install clang-tools
#
# 注意使用 pip3 install scan-build 使用的 scan-build 会报错 because it contains no report.

# 
# scan-build -v -o ./scanbuildout cmake ..
# scan-build -v -o ./scanbuildout make

# 还是报错: Removing directory 'scanbuildout/2025-03-14-090544-1932485-1' because it contains no reports.
# 这是因为 scan-build 会去篡改 Makefile 中的 $CC 和 $CXX, 但是在我这个 docker 环境中 CMake 生成的 Makefile 没有 $CC 和 $CXX
# 所以我们暂时只能手动执行命令
scan-build -o ./scanbuildout gcc -o main main.cc
cd -
