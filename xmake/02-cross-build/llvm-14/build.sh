#!/bin/bash

set -e

xmake f --yes --project_name=xmake/02-cross-build/llvm-14 --verbose
xmake build --yes --verbose --diagnosis --rebuild xmake.02-cross-build.llvm-14.main
