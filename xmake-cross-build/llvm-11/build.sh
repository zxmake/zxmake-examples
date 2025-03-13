#!/bin/bash

set -e

xmake f --yes --project_name=xmake-cross-build/llvm-11 --verbose
xmake build --yes --verbose --diagnosis --rebuild xmake-cross-build.llvm-11.main
