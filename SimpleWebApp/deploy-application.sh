#!/bin/bash

# CLI Documentation
# ================
# command documentation: https://cloud.ibm.com/docs/codeengine?topic=codeengine-cli#cli-application-create

# **************** Global variables

source ./.env

echo "Name for the project: $MYPROJECT"

export ROOT_FOLDER=$ROOTFOLDER
export PROJECT_NAME=$MYPROJECT
export RESOURCE_GROUP=${RESOURCE_GROUP:-default}
export REGION=${REGION:-us-south}
export REGISTRY="quay.io"
export REPOSITORY=tsuedbroecker

export NAMESPACE=""
export ASSISTANT_EXTENSION_URL=""

export STATUS="Running"

export COMMONTAG="v0.0.1"
export VUE_IMAGE="$REGISTRY/$REPOSITORY/vue-assistant-happybanking:$COMMONTAG"

# **********************************************************************************
# Functions definition
# **********************************************************************************

function loginIBMCloud() {
  ibmcloud login  -sso
  ibmcloud target -r $REGION -g $RESOURCE_GROUP
}

function setupCLIenvCE() {
  echo "**********************************"
  echo " Using following project: $PROJECT_NAME" 
  echo "**********************************"
  
  ibmcloud target -g $RESOURCE_GROUP -r $REGION
  
  echo "Project name: $PROJECT_NAME"
  ibmcloud ce project create --name $PROJECT_NAME
  ibmcloud ce project get --name $PROJECT_NAME
  ibmcloud ce project select -n $PROJECT_NAME
  
  #to use the kubectl commands
  ibmcloud ce project select -n $PROJECT_NAME --kubecfg
  
  NAMESPACE=$(ibmcloud ce project get --name $PROJECT_NAME --output json | grep "namespace" | awk '{print $2;}' | sed 's/"//g' | sed 's/,//g')
  echo "Namespace: $NAMESPACE"
  kubectl get pods -n $NAMESPACE

  ibmcloud ce application get --name assistant-extension
  CHECK=$(ibmcloud ce application list | grep assistant-web-app)
  echo "Check: ($CHECK)"
  if [[ $CHECK != "" ]];
  then
    echo "Error: There is a remaining 'assistant-web-app'."
    echo "Wait until app is deleted inside the $PROJECT_NAME."
    echo "The script exits here!"
    exit 1
  fi
 
}

function createSecrets() {
    
    ibmcloud ce secret create --name assistant.integration-id --from-literal "ASSISTANT_INTEGRATION_ID=$ASSISTANT_INTEGRATION_ID"
    ibmcloud ce secret create --name assistant.region --from-literal "ASSISTANT_REGION=$ASSISTANT_REGION"
    ibmcloud ce secret create --name assistant.service-instance-id --from-literal "ASSISTANT_SERVICE_INSTANCE_ID=$ASSISTANT_SERVICE_INSTANCE_ID"

}

# **** application and microservices ****

function deployExtension(){

    ibmcloud ce application create --name assistant-web-app --image "$VUE_IMAGE" \
                                   --cpu "0.5" \
                                   --memory "1G" \
                                   --env-from-secret assistant.integration-id \
                                   --env-from-secret assistant.region \
                                   --env-from-secret assistant.service-instance-id \
                                   --max-scale 1 \
                                   --min-scale 0 \
                                   --concurrency-target 10 \
                                   --port 8080                                       
    
    ibmcloud ce application get --name assistant-web-app
    
    # Change autoscaling for articles configuration

    kn service update assistant-web-app --annotation-revision autoscaling.knative.dev/scaleToZeroPodRetentionPeriod=5m
    ibmcloud ce application get --name assistant-web-app -o json > temp-assistant-web-app.json
    CURRENT_CONFIG=$(cat ./temp-assistant-web-app.json| jq '.status.latestReadyRevisionName' | sed 's/"//g')
    echo "Current config: $CURRENT_CONFIG"
    rm temp-assistant-web-app.json
    kn revision describe $CURRENT_CONFIG --verbose

    ASSISTANT_WEB_URL=$(ibmcloud ce application get --name assistant-web-app -o url)
}

# **** Kubernetes CLI ****

function kubeDeploymentVerification(){
    echo "************************************"
    echo " pods, deployments and configmaps details "
    echo "************************************"
    
    kubectl get pods -n $NAMESPACE
    kubectl get deployments -n $NAMESPACE
    kubectl get configmaps -n $NAMESPACE
}

function getKubeContainerLogs(){
    echo "************************************"
    echo " assistant-extension log"
    echo "************************************"

    FIND=assistant-extension
    ASSISTANT_EXTENSION_LOG=$(kubectl get pod -n $NAMESPACE | grep $FIND | awk '{print $1}')
    echo $ASSISTANT_EXTENSION_LOG
    kubectl logs $ASSISTANT_EXTENSION
}

# **********************************************************************************
# Execution
# **********************************************************************************

echo "************************************"
echo " Login IBM Cloud"
echo "************************************"

loginIBMCloud

echo "************************************"
echo " CLI config"
echo "************************************"

setupCLIenvCE

echo "************************************"
echo " create secrets"
echo "************************************"

createSecrets

echo "************************************"
echo " assistant extension"
echo "************************************"

deployExtension
ibmcloud ce application events --application assistant-extension

echo "************************************"
echo " Verify deployments"
echo "************************************"

kubeDeploymentVerification

echo "************************************"
echo " Container logs"
echo "************************************"

getKubeContainerLogs

echo "************************************"
echo " URLs"
echo "************************************"
echo " - Extension  : $ASSISTANT_WEB_URL"