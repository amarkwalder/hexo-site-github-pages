#!/bin/bash
set -e

if [ -z "${WORKDIR}" ]; then
  echo "ABORT: env WORKDIR is missing"
  exit 1
fi

if [ -z "${GITHUB_USER}" ]; then
  echo "ABORT: env GITHUB_USER is missing"
  exit 1
fi

if [ -z "${GITHUB_REPO}" ]; then
  echo "ABORT: env GITHUB_REPO is missing"
  exit 1
fi

if [ -z "${BUILD_NO}" ]; then
  echo "ABORT: env BUILD_NO is missing"
  exit 1
fi

WORKDIR=${WORKDIR:-/tmp/${GITHUB_USER}/${GITHUB_REPO}}
BUILDS_DIR=${WORKDIR}/builds
SOURCE_DIR=${WORKDIR}

echo "npm     : " `npm --version`
echo "node.js : " `node --version | awk '{print substr($0,2)}'`
echo "git     : " `git --version  | awk -F ' ' '{print $3}'`

echo ls -la ${SOURCE_DIR}
ls -la ${SOURCE_DIR}

if [ ! -d "${SOURCE_DIR}" ]; then
  mkdir -p ${SOURCE_DIR}
  git clone https://github.com/${GITHUB_USER}/${GITHUB_REPO}.git ${SOURCE_DIR}
fi

cd ${SOURCE_DIR}
npm install
hexo generate

BUILD_DEST=${BUILDS_DIR}/${BUILD_NO}
mkdir -p ${BUILD_DEST}

cd ${SOURCE_DIR}/public
tar -cvzf ${BUILD_DEST}/${GITHUB_REPO}.tar.gz *

cd ${BUILD_DEST}
sha256sum ${GITHUB_REPO}.tar.gz > ${GITHUB_REPO}.sha256

cd ${SOURCE_DIR}/public
mkdir -p ${BUILD_DEST}/${GITHUB_REPO}
cp -r ${SOURCE_DIR}/public/* ${BUILD_DEST}/${GITHUB_REPO}/
