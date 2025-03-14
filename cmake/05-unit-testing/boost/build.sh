#!/bin/bash

set -e

rm build -rf
mkdir build
cd build
cmake ..
make
make test
cd -
