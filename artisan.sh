#!/bin/bash

# Laravel Artisan Helper Script for Docker
# Usage: ./artisan.sh [artisan-command] [arguments]
# Example: ./artisan.sh make:controller UserController
# Example: ./artisan.sh migrate --seed

set -e

# Check if docker-compose is available
if ! command -v docker-compose &> /dev/null; then
    echo "Error: docker-compose is not installed or not in PATH"
    exit 1
fi

# Navigate to the .devcontainer directory
cd "$(dirname "$0")/.devcontainer"

# Check if containers are running
if ! docker-compose ps --services --filter "status=running" | grep -q "app"; then
    echo "Error: Laravel app container is not running. Please start with 'docker-compose up -d'"
    exit 1
fi

# Execute the artisan command
echo "Executing: php artisan $*"
docker-compose exec app php artisan "$@"
