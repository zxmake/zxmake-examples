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

xmake f --yes --verbose --diagnosis -p cross --sdk=/usr --cuda=/usr/local/cuda --cross=aarch64-linux-gnu- --cu=/usr/local/cuda/bin/nvcc
xmake b --yes --verbose --diagnosis --rebuild g++-aarch64-linux-gnu
