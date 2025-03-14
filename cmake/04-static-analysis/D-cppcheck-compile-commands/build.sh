#!/bin/bash

set -e

mkdir -p build
cd build
cmake -DCPPCHECK_ERROR_EXITCODE_ARG="" ..
make cppcheck-analysis
cd -
