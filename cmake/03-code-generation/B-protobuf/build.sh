#!/bin/bash

set -e

rm build -rf
mkdir build
cd build
cmake ..
ls -l
make VERBOSE =1
cd -

# ./build/protobuf_example test.db
