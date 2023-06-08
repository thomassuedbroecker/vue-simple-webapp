#!/bin/bash
source ./.env

# **************** Global variables
export ROOT_PATH=$(pwd)
export IMAGE_NAME=vue-assistant-examplebanking:v0.0.1
export URL=quay.io
export REPOSITORY=tsuedbroecker
export CONTAINER_RUNTIME=docker

$CONTAINER_RUNTIME login $URL
$CONTAINER_RUNTIME build -t "$URL/$REPOSITORY/$IMAGE_NAME" -f Dockerfile .
$CONTAINER_RUNTIME push "$URL/$REPOSITORY/$IMAGE_NAME"