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
  docker exec -it --user $(id -u):$(id -g) ${DOCKER_CONTAINER} /bin/bash
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
  local user_id=$(id -u)
  local grp=$(id -g -n)
  local grp_id=$(id -g)
  local local_host=$(hostname)

  local docker_home="/home/$USER"
  if [ "$USER" == "root" ]; then
    docker_home="/root"
    error "Please don't run docker.sh with root account, it is really dangerous!"
    exit -1
  fi

  if [ ! -f "$HOME/.bashrc" ]; then
    touch $HOME/.bashrc
  fi

  general_param="-it -d \
    --privileged \
    --restart always \
    --name ${DOCKER_CONTAINER} \
    -e DISPLAY=${display} \
    -e DOCKER_USER=root \
    -e USER=${USER} \
    -e DOCKER_USER_ID=${user_id} \
    -e DOCKER_GRP=${grp} \
    -e DOCKER_GRP_ID=${grp_id} \
    -e DOCKER_IMG=${DOCKER_IMAGE} \
    -v ${PROJECT_BASE_DIR}:/${PROJECT_NAME} \
    -v ${HOME}/.gitconfig:${docker_home}/.gitconfig\
    -v ${HOME}/.ssh:${docker_home}/.ssh \
    -v ${HOME}/.bashrc:${docker_home}/.bashrc \
    -w /${PROJECT_NAME}"

  info "Starting docker container \"${DOCKER_CONTAINER}\" ..."
  if [ "$(uname)" == "Darwin" ] ;then
    error "No support macOs now!"
    exit -1
  else
    docker run ${general_param} \
        -v /etc/passwd:/etc/passwd:ro \
        -v /etc/shadow:/etc/shadow:ro \
        -v /etc/group:/etc/group:ro \
        -v /etc/localtime:/etc/localtime:ro \
        -v /etc/resolv.conf:/etc/resolv.conf:ro \
        --net host \
        --add-host ${DOCKER_HOSTNAME}:127.0.0.1 \
        --add-host ${local_host}:127.0.0.1 \
        --hostname ${DOCKER_HOSTNAME} \
        --user $(id -u) \
        ${DOCKER_IMAGE} \
        /bin/bash
  fi

  [ "${USER}" != "root" ] && {
    info "add ${USER} in the container with ${HOME}"
    [ "$(uname)" == "Darwin" ] && {
      docker exec ${DOCKER_CONTAINER} bash -c "useradd $USER -m --home /home/$USER || echo $?"
      docker exec ${DOCKER_CONTAINER} bash -c "echo '$USER ALL=NOPASSWD: ALL' >> /etc/sudoers"
      docker exec ${DOCKER_CONTAINER} bash -c "chown -R $USER"
    } || {
      docker exec -u root ${DOCKER_CONTAINER} bash -c "echo '$USER ALL=NOPASSWD: ALL' >> /etc/sudoers"
      docker exec -u root ${DOCKER_CONTAINER} bash -c "chown -R $USER:$USER ${docker_home} || true"
    }
  }

  docker exec ${DOCKER_CONTAINER} /bin/bash -c 'echo DOCKER_IMAGE: ${DOCKER_IMG}'
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
