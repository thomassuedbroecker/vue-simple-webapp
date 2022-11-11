#!/bin/bash

########################################
# Create a file based on the environment variables
# given by the dockerc run -e parameter
# - ASSISTANT_INTEGRATION_ID
# - ASSISTANT_REGION
# - ASSISTANT_SERVICE_INSTANCE_ID
########################################
cat <<EOF
window.ASSISTANT_INTEGRATION_ID="${ASSISTANT_INTEGRATION_ID}"
window.ASSISTANT_REGION="${ASSISTANT_REGION}"
window.ASSISTANT_SERVICE_INSTANCE_ID="${ASSISTANT_SERVICE_INSTANCE_ID}"
EOF