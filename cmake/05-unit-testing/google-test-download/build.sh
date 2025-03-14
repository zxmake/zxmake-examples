#!/bin/bash

set -e

rm build -rf
mkdir build
cd build
cmake ..
make
make test VERBOSE=1
cd -
