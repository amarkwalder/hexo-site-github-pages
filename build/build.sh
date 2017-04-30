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

WORKDIR=${WORKDIR:-/tmp}
BUILDS_DIR=${WORKDIR}/builds
SOURCE_DIR=${WORKDIR}/source

echo "npm     : " `npm --version`
echo "node.js : " `node --version | awk '{print substr($0,2)}'`
echo "git     : " `git --version  | awk -F ' ' '{print $3}'`

mkdir -p ${SOURCE_DIR}
if [ ! -d "${SOURCE_DIR}/${GITHUB_USER}/${GITHUB_REPO}" ]; then
  git clone https://github.com/${GITHUB_USER}/${GITHUB_REPO}.git ${SOURCE_DIR}/${GITHUB_USER}/${GITHUB_REPO}
fi

cd ${SOURCE_DIR}/${GITHUB_USER}/${GITHUB_REPO}
npm install
hexo generate

BUILD_DEST=${BUILDS_DIR}/${BUILD_NO}
mkdir -p ${BUILD_DEST}

cd ${SOURCE_DIR}/${GITHUB_USER}/${GITHUB_REPO}/public
tar -cvzf ${BUILD_DEST}/${GITHUB_REPO}.tar.gz *

cd ${BUILD_DEST}
sha256sum ${GITHUB_REPO}.tar.gz > ${GITHUB_REPO}.sha256

cd ${SOURCE_DIR}/${GITHUB_USER}/${GITHUB_REPO}/public
mkdir -p ${BUILD_DEST}/${GITHUB_REPO}
cp -r ${SOURCE_DIR}/${GITHUB_USER}/${GITHUB_REPO}/public/* ${BUILD_DEST}/${GITHUB_REPO}/
