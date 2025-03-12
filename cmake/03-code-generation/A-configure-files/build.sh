#!/bin/bash

set -e

rm build -rf
mkdir build
cd build
cmake ..
ls -l
make
cd -

./build/cf_example
