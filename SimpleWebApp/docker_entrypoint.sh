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
echo "*********************"
./docker-entrypoint.sh
echo "*********************"
set -e

entrypoint_log() {
    if [ -z "${NGINX_ENTRYPOINT_QUIET_LOGS:-}" ]; then
        echo "$@"
    fi
}

if [ "$1" = "nginx" -o "$1" = "nginx-debug" ]; then
    if /usr/bin/find "/docker-entrypoint.d/" -mindepth 1 -maxdepth 1 -type f -print -quit 2>/dev/null | read v; then
        entrypoint_log "$0: /docker-entrypoint.d/ is not empty, will attempt to perform configuration"

        entrypoint_log "$0: Looking for shell scripts in /docker-entrypoint.d/"
        find "/docker-entrypoint.d/" -follow -type f -print | sort -V | while read -r f; do
            case "$f" in
                *.envsh)
                    if [ -x "$f" ]; then
                        entrypoint_log "$0: Sourcing $f";
                        . "$f"
                    else
                        # warn on shell scripts without exec bit
                        entrypoint_log "$0: Ignoring $f, not executable";
                    fi
                    ;;
                *.sh)
                    if [ -x "$f" ]; then
                        entrypoint_log "$0: Launching $f";
                        "$f"
                    else
                        # warn on shell scripts without exec bit
                        entrypoint_log "$0: Ignoring $f, not executable";
                    fi
                    ;;
                *) entrypoint_log "$0: Ignoring $f";;
            esac
        done

        entrypoint_log "$0: Configuration complete; ready for start up"
    else
        entrypoint_log "$0: No files found in /docker-entrypoint.d/, skipping configuration"
    fi
fi

exec "$@"
echo "*********************"
