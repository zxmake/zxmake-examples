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

# 普通编译
bazel build //main:hello-world
bazel build //cuda:main

# 交叉编译
bazel build --platforms=//platforms:aarch64_linux //main:hello-world

# bazel build --platforms=//platforms:aarch64_linux \
#   --linkopt="-Wl,-rpath,/usr/local/cuda-11.8/targets/aarch64-linux/lib" \
#   --linkopt="-L/usr/local/cuda-11.8/targets/aarch64-linux/lib" \
#   --@rules_cuda//cuda:copts=-ccbin=/usr/bin/aarch64-linux-gnu-gcc \
#   //cuda:main
#
# 等价于
#
bazel build --platforms=//platforms:aarch64_linux \
  --linkopt="-L/usr/local/cuda-11.8/targets/aarch64-linux/lib" \
  //cuda:main

# 生成 compile_commands.json
# 需要非 root 权限, 没法在 github action 里跑
if [ -z "${GITHUB_ACTIONS+x}" ]; then
    info "not running in github actions"
    bazel run @hedron_compile_commands//:refresh_all
else
    info "running in github actions, skip generating compile_commands.json"
fi

cd -
