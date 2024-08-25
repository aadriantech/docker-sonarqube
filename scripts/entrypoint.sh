#!/bin/bash

# Load environment variables from the .env file
if [ -f .env ]; then
    echo "[ENTRYPOINT] Load env values..."
    export $(grep -v '^#' .env | xargs)
fi

# Check the PODSLEEP environment variable
if [ "$PODSLEEP" == "yes" ]; then
    echo "[ENTRYPOINT] PODSLEEP is set to yes. The container will sleep indefinitely."
    sleep infinity
else
    echo "[ENTRYPOINT] PODSLEEP is set to no. Starting SonarQube."
    exec /opt/sonarqube/docker/entrypoint.sh "$@"
fi
