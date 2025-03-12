#!/bin/bash

set -e

rm build -rf
mkdir build
cd build
cmake .. -G Ninja
# sudo apt install ninja-build
ninja -v
ls
./hello_cmake
cd -
