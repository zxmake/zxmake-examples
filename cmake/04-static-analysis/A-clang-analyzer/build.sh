#!/bin/bash

set -e

rm build -rf
mkdir build
cd build

# https://stackoverflow.com/questions/68172416/scan-build-not-working-reporting-removing-directory-xxx-because-it-contains-no
# sudo apt install clang-tools
#
# 注意使用 pip3 install scan-build 使用的 scan-build 会报错 because it contains no report.
scan-build --use-cc=/usr/bin/clang --use-c++=/usr/bin/clang++ -o ./scanbuildout cmake ..
scan-build --use-cc=/usr/bin/clang --use-c++=/usr/bin/clang++ -o ./scanbuildout make

# 还是报错: Removing directory 'scanbuildout/2025-03-14-090544-1932485-1' because it contains no reports.
# FIXME: 后续再研究
cd -
