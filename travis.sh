#!/bin/bash

function install() {
  docker-compose build builder
}

function build() {
  docker-compose run builder
}

function deploy() {
  export GIT_TAG=v${BUILD_NO}
  export GIT_RELTEXT="Auto-released by [Travis-CI build #${TRAVIS_BUILD_NUMBER}](https://travis-ci.org/${TRAVIS_REPO_SLUG}/builds/${TRAVIS_BUILD_ID})"
  curl -sSL https://github.com/tcnksm/ghr/releases/download/v0.5.4/ghr_v0.5.4_linux_amd64.zip > ghr.zip
  unzip ghr.zip
  ./ghr --version
  ./ghr --debug -u amarkwalder -b "${GIT_RELTEXT}" ${GIT_TAG} builds/${BUILD_NO}/
}

function usage() {
  echo "Usage: $0 [ install | build | deploy ]"
  exit 1
}

set -e

if [ -z "${TRAVIS_BRANCH}" ]; then
  echo "ABORT: env TRAVIS_BRANCH is missing"
  exit 1
fi

if [ -z "${GITHUB_TOKEN}" ]; then
  echo "ABORT: env GITHUB_TOKEN is missing"
  exit 1
fi

if [ -z "${BUILD_NO}" ]; then
  echo "ABORT: env BUILD_NO is missing"
  exit 1
fi

# verbose logging
set -x

case "${1}" in
  install)  install ;;
  build)    build ;;
  deploy)   deploy ;;
  "" | *)   usage ;;
esac
