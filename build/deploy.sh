#!/bin/bash
set -e

if [ -z "${GITHUB_USER}" ]; then
  echo "ABORT: env GITHUB_USER is missing"
  exit 1
fi

if [ -z "${GITHUB_EMAIL}" ]; then
  echo "ABORT: env GITHUB_EMAIL is missing"
  exit 1
fi

if [ -z "${GITHUB_REPO}" ]; then
  echo "ABORT: env GITHUB_REPO is missing"
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

WORKDIR=/tmp
BUILDS_DIR=${WORKDIR}/builds
BUILD_DEST=${BUILDS_DIR}/${BUILD_NO}

if [ -z "${TRAVIS_BUILD_NUMBER}" ] || [ -z "${TRAVIS_REPO_SLUG}" ] || [ -z "${TRAVIS_BUILD_ID}" ] ; then
  GITHUB_RELTEXT="Manually-released"
else
  GITHUB_RELTEXT="Auto-released by [Travis-CI build #${TRAVIS_BUILD_NUMBER}](https://travis-ci.org/${TRAVIS_REPO_SLUG}/builds/${TRAVIS_BUILD_ID})"
fi

cd ${BUILD_DEST}/${GITHUB_REPO}
rm -rf .git
git init
git config user.email "${GITHUB_EMAIL}"
git config user.name "${GITHUB_USER}"
git add --all
git commit -m "${GITHUB_RELTEXT}"
git remote add origin https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/${GITHUB_USER}/${GITHUB_USER}.github.io.git
git push -u origin master --force

ghr --version
ghr --debug -u "${GITHUB_USER}" -r "${GITHUB_REPO}" -b "${GITHUB_RELTEXT}" "v${BUILD_NO}" ${BUILD_DEST}/
