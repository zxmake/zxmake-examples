#!/bin/bash

set -e

rm build -rf
mkdir build
cd build
scan-build -o ./scanbuildout cmake ..
ls -l
scan-build -o ./scanbuildout make
cd -
