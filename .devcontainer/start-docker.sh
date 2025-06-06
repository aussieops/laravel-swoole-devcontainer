#!/bin/bash

# Start Docker daemon for Docker-in-Docker support
echo "Starting Docker daemon for Docker-in-Docker support..."
dockerd > /var/log/dockerd.log 2>&1 &

# Wait for Docker daemon to be available
echo "Waiting for Docker daemon to become available..."
timeout=30
counter=0
while ! docker info >/dev/null 2>&1; do
    if [ "$counter" -gt "$timeout" ]; then
        echo "ERROR: Docker daemon failed to start within $timeout seconds."
        exit 1
    fi
    echo "Waiting for Docker daemon... ($counter/$timeout)"
    counter=$((counter + 1))
    sleep 1
done
echo "Docker daemon started successfully!"
