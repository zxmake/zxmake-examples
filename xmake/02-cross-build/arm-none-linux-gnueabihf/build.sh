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

SDK_ZIP_FILE="${SCRIPT_DIR}/arm-gnu-toolchain-13.3.rel1-x86_64-arm-none-linux-gnueabihf.tar.xz"
SDK_DIR="${SCRIPT_DIR}/arm-gnu-toolchain-13.3.rel1-x86_64-arm-none-linux-gnueabihf"

if [ -d "${SDK_DIR}" ]; then
    warning "dir [${SDK_DIR}] exists, remove it"
else
    tar -xvf ${SDK_ZIP_FILE} -C "${SCRIPT_DIR}"
fi

# --sdk 必须用绝对路径否则 xmake 会报错找不到 arm-none-linux-gnueabihf-g++ 等二进制
xmake f --yes --verbose -p cross --sdk="${SDK_DIR}" --project_name=xmake/02-cross-build/arm-none-linux-gnueabihf
xmake b --verbose --rebuild xmake.02-cross-build.arm-none-linux-gnueabihf.main
