#!/bin/bash

set -e

bash xmake/01-basic/B-cuda-target/build.sh
bash xmake/02-cross-build/aarch64-none-linux-gnu/build.sh
bash xmake/02-cross-build/arm-none-linux-gnueabihf/build.sh
bash xmake/02-cross-build/clang-sysroot-target/build.sh
bash xmake/02-cross-build/g++-aarch64-linux-gnu/build.sh
bash xmake/02-cross-build/llvm-14/build.sh
bash xmake/02-cross-build/zig/build.sh
bash xmake/02-cross-build/muslcc/build.sh
