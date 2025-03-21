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

bazel build //basic-macros/...

# 生成 compile_commands.json
# 需要非 root 权限, 没法在 github action 里跑
if [ -z "${GITHUB_ACTIONS+x}" ]; then
    info "not running in github actions"
    bazel run @hedron_compile_commands//:refresh_all
else
    info "running in github actions, skip generating compile_commands.json"
fi

cd -
