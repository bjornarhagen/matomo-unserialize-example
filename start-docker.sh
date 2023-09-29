#!/bin/bash

# This script builds and runs the Dockerfile.local in this directory.
# Uses podman if available, otherwise falls back to docker.
# ./ is mounted as a volume on /app inside the container, so that changes to the source code are reflected live in the container.

COMMAND_TO_RUN_ON_CONTAINER=""
CONTAINER_NAME="matomo-php-unserialize"

command_exists() {
    type "$1" &>/dev/null
}

if command_exists podman; then
    CONTAINER_TOOL=podman
elif command_exists docker; then
    CONTAINER_TOOL=docker
else
    echo "Could not find podman or docker. Please install one of them and try again."
    exit 1
fi

echo "Using $CONTAINER_TOOL: $(command -v $CONTAINER_TOOL)"
$CONTAINER_TOOL build --pull --rm -f "Dockerfile" -t $CONTAINER_NAME:latest "."
$CONTAINER_TOOL run --rm -it --add-host=host.docker.internal:host-gateway -v $(pwd)/data:/app/data --name $CONTAINER_NAME $CONTAINER_NAME:latest $COMMAND_TO_RUN_ON_CONTAINER
