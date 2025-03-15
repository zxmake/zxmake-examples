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


mapfile -t test_scripts < <(find cmake -type f -name "build.sh")

for test_script in "${test_scripts[@]}"; do
    echo "-----------------------------------------------------------------"
    bash "${test_script}"
    if [[ $? -ne 0 ]]; then
        error "Script failed in [$test_script]"
        exit 1
    fi
    echo "-----------------------------------------------------------------"
done

ok "Run all examples successfully!"
