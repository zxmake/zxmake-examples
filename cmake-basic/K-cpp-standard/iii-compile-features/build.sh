#!/bin/bash

set -e

rm build -rf
mkdir build
cd build
cmake ..
make VERBOSE=1
./hello_cpp11
cd -
