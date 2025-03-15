#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="${SCRIPT_DIR}/build"

rm "${BUILD_DIR}" -rf
mkdir "${BUILD_DIR}"
cd "${BUILD_DIR}"
cmake .. -G Ninja
# sudo apt install ninja-build
ninja -v
ls
./hello_cmake
cd -
