#!/bin/bash

set -e

rm build -rf
mkdir build
cd build
cmake ..
make help
make package
ls
cd -
