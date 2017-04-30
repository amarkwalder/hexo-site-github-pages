#!/bin/bash
set -e

if [ -z "${GITHUB_USER}" ]; then
  echo "ABORT: env GITHUB_USER is missing"
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

if [ -z "${TRAVIS_BUILD_NUMBER}" ]; then
  echo "ABORT: env TRAVIS_BUILD_NUMBER is missing"
  exit 1
fi

if [ -z "${TRAVIS_REPO_SLUG}" ]; then
  echo "ABORT: env TRAVIS_REPO_SLUG is missing"
  exit 1
fi

if [ -z "${TRAVIS_BUILD_ID}" ]; then
  echo "ABORT: env TRAVIS_BUILD_ID is missing"
  exit 1
fi

GITHUB_RELTEXT="Auto-released by [Travis-CI build #${TRAVIS_BUILD_NUMBER}](https://travis-ci.org/${TRAVIS_REPO_SLUG}/builds/${TRAVIS_BUILD_ID})"

ghr --version
ghr --debug -u "${GITHUB_USER}" -r "${GITHUB_REPO}" -b "${GITHUB_RELTEXT}" "v${BUILD_NO}" /builds/${BUILD_NO}/
