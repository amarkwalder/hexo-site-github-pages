#!/bin/bash
set -x

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

function build() {
  docker-compose run builder
}

function deploy() {
  docker-compose run deployer
}

function usage() {
  echo "Usage: $0 [ install | build | deploy ]"
  exit 1
}

BASEDIR=$(dirname "$0")
cd ${BASEDIR}

case "${1}" in
  install)  install ;;
  build)    build ;;
  deploy)   deploy ;;
  "" | *)   usage ;;
esac
