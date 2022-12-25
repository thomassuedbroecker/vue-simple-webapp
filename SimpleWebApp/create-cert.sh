#!/bin/bash

# **************** Global variables

source ./.env

# **********************************************************************************
# Functions definition
# **********************************************************************************

function creatCert () {
    echo "Domain name: $CERT_DOMAIN"
    sudo certbot certonly \
    --manual \
    --preferred-challenges=dns \
    --email=$CERT_EMAIL \
    --https://acme-staging-v02.api.letsencrypt.org/directory \
    --agree-tos \
    -d $CERT_DOMAIN   
}

function insertCertSource () {
    echo "Insert SOURCE_CERTIFICATE"
    read SOURCE_CERTIFICATE
    echo "Value: $SOURCE_CERTIFICATE"
    echo ""
    echo "Insert SOURCE_KEY"
    read SOURCE_KEY
    echo "Value: $SOURCE_KEY"
    echo ""
}

function copyCert () {
    mkdir $(pwd)/tls-cert
    mkdir $(pwd)/tls-cert/letsencrypt

    DESTINATION_CERTIFICATE=$(pwd)/tls-cert/letsencrypt/fullchain.crt
    DESTINATION_KEY=$(pwd)/tls-cert/letsencrypt/privkey.key

    sudo cp $SOURCE_CERTIFICATE $DESTINATION_CERTIFICATE
    sudo cp $SOURCE_KEY $DESTINATION_KEY

    sudo chmod 777 $DESTINATION_CERTIFICATE
    sudo chmod 777 $DESTINATION_KEY
}

function displayCert () {
    echo "Publci cert:"
    cat $DESTINATION_CERTIFICATE
    echo "Private key:"
    cat $DESTINATION_KEY
}

# **********************************************************************************
# Execution
# **********************************************************************************

creatCert

insertCertSource

copyCert

displayCert 

