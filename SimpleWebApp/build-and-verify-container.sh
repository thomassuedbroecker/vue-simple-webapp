#!/bin/bash
source ./.env

# **************** Global variables
export ROOT_PATH=$(pwd)
export CONTAINER_NAME=webapp-verification
export IMAGE_NAME=webapp-local-verification:v1
export CONTAINER_RUNTIME=docker

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
           -e ASSISTANT_INTEGRATION_ID="${ASSISTANT_INTEGRATION_ID}" \
           -e ASSISTANT_REGION="${ASSISTANT_REGION}" \
           -e ASSISTANT_SERVICE_INSTANCE_ID="${ASSISTANT_SERVICE_INSTANCE_ID}" \
           -p 8080:8080 \
           $IMAGE_NAME

# $CONTAINER_RUNTIME port --all 