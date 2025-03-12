#!/bin/bash

set -e

rm build -rf
mkdir build
cd build
cmake .. -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++
make VERBOSE=1
./hello_cmake
cd -
