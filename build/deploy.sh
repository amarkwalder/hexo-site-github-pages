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

ghr --version
ghr --debug -u "${GITHUB_USER}" -r "${GITHUB_REPO}" -b "" "v${BUILD_NO}" /builds/${BUILD_NO}/
