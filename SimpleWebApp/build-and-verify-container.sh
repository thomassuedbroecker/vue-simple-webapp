#!/bin/bash

# **************** Global variables
export ROOT_PATH=$(pwd)
export CONTAINER_NAME=webapp-verification
export IMAGE_NAME=webapp-local-verification:v1
export CONTAINER_RUNTIME=podman

# **************** Verify container
echo "************************************"
echo " Verify container locally"
echo "************************************"

echo "************************************"
echo " Build simple webapp example"
echo "************************************"

$CONTAINER_RUNTIME image list
$CONTAINER_RUNTIME container list
$CONTAINER_RUNTIME container stop -f $CONTAINER_NAME
$CONTAINER_RUNTIME container rm -f $CONTAINER_NAME
$CONTAINER_RUNTIME image rm -f $IMAGE_NAME

$CONTAINER_RUNTIME build -t $IMAGE_NAME -f Dockerfile .

echo "************************************"
echo " List containers"
echo "************************************"

$CONTAINER_RUNTIME container list

echo "************************************"
echo " Run simple webapp example container"
echo "************************************"

$CONTAINER_RUNTIME run --name=$CONTAINER_NAME \
           -it \
           -e ASSISTANT_INTEGRATION_ID="fb6dac0e-7249-4461-bf19-798d3b68505b" \
           -e ASSISTANT_REGION="us-south" \
           -e ASSISTANT_SERVICE_INSTANCE_ID="07061aa9-b6d8-427d-af36-947da5f8a12e" \
           -p 8080:8080 \
           $IMAGE_NAME

# $CONTAINER_RUNTIME port --all 