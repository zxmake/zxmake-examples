#!/bin/bash

set -e

function info() {
  (>&2 printf "[\e[34m\e[1mINFO\e[0m] $*\n")
}

function error() {
  (>&2 printf "[\033[0;31mERROR\e[0m] $*\n")
}

function warning() {
  (>&2 printf "[\033[0;33mWARNING\e[0m] $*\n")
}

function ok() {
  (>&2 printf "[\e[32m\e[1m OK \e[0m] $*\n")
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "${SCRIPT_DIR}"

# --toolchain=aarch64-clang: 指定 toolchain, 只能在最外层 includes
# --verbose: 详细信息
# --diagnosis: 调试信息
# --arch=armv8-a: 指定 arch, 这样产出物就会在 build/linux/armv8-a/release 目录下, 不会放在 build/linux/x86_64 下迷惑人
xmake f --yes --toolchain=aarch64-clang --arch=armv8-a
xmake b --yes --verbose --diagnosis --rebuild --all

cd -
