#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "${SCRIPT_DIR}"

xmake build --yes --verbose --rebuild cmake.03-code-generation.B-protobuf.main

cd -
