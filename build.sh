#!/bin/bash
set -e
set -x

WORKDIR=/tmp
BUILD_NO=${BUILD_NO:=$(date '+%Y%m%d-%H%M%S')}
BUILD_DEST=/builds/$BUILD_NO
mkdir -p $BUILD_DEST

echo "npm     : " `npm --version`
echo "node.js : " `node --version | awk '{print substr($0,2)}'`
echo "git     : " `git --version  | awk -F ' ' '{print $3}'`

GITHUB_USER="amarkwalder"
GITHUB_REPO="hexo-site-github-pages"

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

ls -la ${BUILD_DEST}
cat ${BUILD_DEST}/${GITHUB_REPO}.sha256
