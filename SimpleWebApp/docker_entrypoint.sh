#!/bin/bash

########################################
# Nativation to verify the nginx folders
########################################
echo ""
echo ""
echo "*********************"
echo "    Navigation"
echo "*********************"
whoami
# nginx stop
echo "*********************"
pwd
echo "*********************"
ls
echo "*********************"
cd /code
ls
echo "********** code ***********"
cd ..
echo "*********************"
more ./generate_env-config.sh

########################################
# Create env-config.js file in the public folder 
# of the ngnix server, based on the environment variables
# given by the docker run -e parameter
# - ASSISTANT_INTEGRATION_ID
# - ASSISTANT_REGION
# - ASSISTANT_SERVICE_INSTANCE_ID
########################################
echo ""
echo ""
echo "*********************"
echo "Get ip address"
echo "*********************"
ip addr show
echo ""
echo ""
echo "*********************"
echo "Create ./code/env-config.js"
echo "*******Does the file exist ?*********"
cd code
ls
echo "*******Delete********"
rm env-config.js
echo "*******Is the file deleted?********"
ls
"/bin/sh" ../generate_env-config.sh > ./env-config.js
echo "*******Is the file generated?******"
ls
########################################
# Create env-config.js file in the public folder 
# of the ngnix server
########################################
echo ""
echo ""
echo "*********************"
echo "Content ./code/env-config.js"
echo "*********************"
cd /code
more ./env-config.js

########################################
# Start ngnix server
# The configuration for the server contains also 
# 'daemon off;'')
# to replace the start command for the
# container image.
# CMD ["nginx", "-g", "daemon off;"]
########################################
echo ""
echo ""
echo "*********************"
echo "Start server"
echo "*********************"
nginx -V
nginx -t
echo "*********************"
cd ..
cat docker-entrypoint.sh