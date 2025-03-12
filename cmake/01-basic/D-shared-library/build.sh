#!/bin/bash

set -e

rm build -rf
mkdir build
cd build
cmake ..
make
cd -

./build/hello_binary
