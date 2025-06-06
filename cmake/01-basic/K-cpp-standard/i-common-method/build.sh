#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="${SCRIPT_DIR}/build"

rm "${BUILD_DIR}" -rf
mkdir "${BUILD_DIR}"
cd "${BUILD_DIR}"
cmake ..
make VERBOSE=1
./hello_cpp11
cd -
