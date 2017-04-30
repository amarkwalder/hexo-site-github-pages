#!/bin/bash

if [ -z "${WORKDIR}" ]; then
  echo "ABORT: env WORKDIR is missing"
  exit 1
fi

function install() {
  docker-compose pull builder
  if [ ${?} != 0 ]; then
    docker-compose build builder
  fi
  docker-compose pull deployer
  if [ ${?} != 0 ]; then
    docker-compose build deployer
  fi
}

function push() {
  docker-compose build builder
  docker-compose push builder

  docker-compose build deployer
  docker-compose push deployer
}

function build() {
  docker-compose run builder
}

function deploy() {
  docker-compose run deployer
}

function usage() {
  echo "Usage: $0 [ install | push | build | deploy ]"
  exit 1
}

BASEDIR=$(dirname "$0")
cd ${BASEDIR}

case "${1}" in
  install)  install ;;
  push)     push ;;
  build)    build ;;
  deploy)   deploy ;;
  "" | *)   usage ;;
esac
