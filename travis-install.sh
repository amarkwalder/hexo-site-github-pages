#!/bin/bash
set -e

# This script is meant to run on Travis-CI only
if [ -z "$TRAVIS_BRANCH" ]; then
  echo "ABORTING: this script runs on Travis-CI only"
  exit 1
fi
# Check essential envs
if [ -z "$GITHUB_TOKEN" ]; then
  echo "ABORTING: env GITHUB_TOKEN is missing"
  exit 1
fi

# verbose logging
set -x

# run build
docker-compose build builder
