#!/usr/bin/env bash

echo -e "Building d405:lastest \nWARNING: this script must be run from the root of the repo not from within the .docker folder"

docker build --pull --rm -f ./.docker/Dockerfile  -t d405:latest .