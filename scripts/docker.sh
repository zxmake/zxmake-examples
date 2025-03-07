#!/bin/bash

set -e

DOCKER_CONTAINER="zmake-examples-container"
DOCKER_HOSTNAME="docker_dev"

PROJECT_BASE_DIR="$(pwd)"
PROJECT_NAME="$(basename ${PROJECT_BASE_DIR})"
DOCKER_IMAGE="${PROJECT_NAME}:latest"


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

function help_info() {
  local bash_name=$(basename "${BASH_SOURCE[0]}")
  echo "Usage: bash docker.sh COMMAND [OPTIONS]"
  echo ""
  echo "A script to build/run/delete docker container easily"
  echo ""
  echo "Commands:"
  echo "  run              Run container."
  echo "  build            Build container."
  echo "  clear            Delete image && container for this project." 
  echo "  help             Print help text."
  echo ""
  echo "[OPTIONS] for docker clear:"
  echo "  --image          Delete docker image."
  echo ""
}

function docker_run() {
  docker exec -it ${DOCKER_CONTAINER} /bin/bash
}

function docker_build() {
  if docker images | awk '{print $1":"$2}' | grep -q ${DOCKER_IMAGE}; then
    info "Docker image ${DOCKER_IMAGE} already exists."
  else
    info "Docker image ${DOCKER_IMAGE} does not exist. Start building..."
    docker build -t ${DOCKER_IMAGE} .
  fi

  if docker ps -a | grep -q "${DOCKER_CONTAINER}"; then
    info "Docker container ${DOCKER_CONTAINER} already exists."
    exit 0
  fi

  info "Docker container ${DOCKER_CONTAINER} does not exist. Starting..."

  general_param="-it -d \
    --privileged \
    --restart always \
    --name ${DOCKER_CONTAINER} \
    -v ${PROJECT_BASE_DIR}:/${PROJECT_NAME} \
    -v ${HOME}/.gitconfig:${docker_home}/.gitconfig\
    -v ${HOME}/.ssh:${docker_home}/.ssh \
    -w /${PROJECT_NAME}"

  info "Starting docker container \"${DOCKER_CONTAINER}\" ..."

  docker run ${general_param} ${DOCKER_IMAGE} /bin/bash

  docker exec ${DOCKER_CONTAINER} /bin/bash
  ok 'Docker environment has already been setted up, you can enter with cmd: "bash scripts/docker.sh run"'
}

function docker_clear() {
  local docker_clear_image=false
  while [ $# -ge 1 ]; do
    case "$1" in
    --image )
      docker_clear_image=true
      shift 1
      ;;
    * )
      error "Invalid param for docker clear"
      echo ""
      help_info
      exit -1
      ;;
    esac
  done

  info "Stoping docker container \"${DOCKER_CONTAINER}\" ..."
  docker container stop ${DOCKER_CONTAINER} 1>/dev/null || warning "No such container: ${DOCKER_CONTAINER}"
  info "Deleting docker container \"${DOCKER_CONTAINER}\" ..."
  docker container rm -f ${DOCKER_CONTAINER} 1>/dev/null || warning "No such container: ${DOCKER_CONTAINER}"

  if ${docker_clear_image}; then
    info "Deleting docker image \"${DOCKER_IMAGE}\" ..."
    docker rmi ${DOCKER_IMAGE}
  fi
}

function main() {
  [ $# -lt 1 ] && {
    echo "Please set param for docker.sh!"
    echo ""
    help_info
    exit -1
  }

  local cmd=$1
  shift 1

  case ${cmd} in
  run )
    docker_run
    ;;
  build )
    docker_build
    ;;
  clear )
    docker_clear $*
    ;;
  help | usage )
    help_info
    ;;
  *)
    help_info
    ;;
  esac
}

main "$@"
