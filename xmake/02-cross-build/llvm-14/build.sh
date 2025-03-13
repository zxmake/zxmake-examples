#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "${SCRIPT_DIR}"

xmake f --yes --verbose
xmake build --yes --verbose --diagnosis --rebuild xmake.02-cross-build.llvm-14.main

cd -
