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

SDK_ZIP_FILE="${SCRIPT_DIR}/arm-gnu-toolchain-13.3.rel1-x86_64-aarch64-none-linux-gnu.tar.xz"
SDK_DIR="${SCRIPT_DIR}/arm-gnu-toolchain-13.3.rel1-x86_64-aarch64-none-linux-gnu"

if [ -d "${SDK_DIR}" ]; then
    warning "dir [${SDK_DIR}] exists, skip installing"
else
    if [ -f "${SDK_ZIP_FILE}" ]; then
        warning "file [${SDK_ZIP_FILE}] exists. skip downloading"
    else
        info "start downloading ndk zip file [${SDK_ZIP_FILE}]"
        wget "https://developer.arm.com/-/media/Files/downloads/gnu/13.3.rel1/binrel/arm-gnu-toolchain-13.3.rel1-x86_64-aarch64-none-linux-gnu.tar.xz" -O ${SDK_ZIP_FILE}
    fi
    tar -xf ${SDK_ZIP_FILE} -C "${SCRIPT_DIR}"
fi

# --sdk 必须用绝对路径否则 xmake 会报错找不到 aarch64-none-linux-gnu-g++ 等二进制
xmake f --yes -p cross --sdk="${SDK_DIR}" --cross=aarch64-none-linux-gnu- --cuda=/usr/local/cuda
xmake b --verbose --rebuild --all

cd -
