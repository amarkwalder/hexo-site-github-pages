#!/bin/bash
set -x

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

set -e

WORKDIR=/tmp
BUILD_DEST=/builds/${BUILD_NO}

mkdir -p ${BUILD_DEST}

echo "npm     : " `npm --version`
echo "node.js : " `node --version | awk '{print substr($0,2)}'`
echo "git     : " `git --version  | awk -F ' ' '{print $3}'`

mkdir -p ${WORKDIR}/source
if [ ! -d "${WORKDIR}/source/${GITHUB_REPO}" ]; then
  git clone https://github.com/${GITHUB_USER}/${GITHUB_REPO}.git ${WORKDIR}/source/${GITHUB_REPO}
fi

cd ${WORKDIR}/source/${GITHUB_REPO}
npm install
hexo generate

cd ${WORKDIR}/source/${GITHUB_REPO}/public
tar -cvzf ${BUILD_DEST}/${GITHUB_REPO}.tar.gz *
cd ${BUILD_DEST}
sha256sum ${GITHUB_REPO}.tar.gz > ${GITHUB_REPO}.sha256
