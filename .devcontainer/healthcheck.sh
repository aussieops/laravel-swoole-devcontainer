#!/bin/bash

# Health check script for Docker container
set -e

# Check if Octane is responding
if ! curl -f -s http://localhost:8000/health > /dev/null; then
    echo "❌ Octane is not responding"
    exit 1
fi

# Check if Supervisor is running
if ! pgrep supervisord > /dev/null; then
    echo "❌ Supervisor is not running"
    exit 1
fi

echo "✅ All services are healthy"
exit 0
