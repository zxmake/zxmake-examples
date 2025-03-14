#!/bin/bash

set -e

sudo apt install cppcheck

rm build -rf
mkdir build
cd build
cmake ..
# 运行 cppcheck
make analysis
cd -
