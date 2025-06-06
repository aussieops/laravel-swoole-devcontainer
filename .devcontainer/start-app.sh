#!/bin/bash

# Laravel Swoole Container Startup Script
# This script prepares the Laravel application and starts all services

set -e

echo "🚀 Starting Laravel Swoole Application..."

# Change to application directory
cd /var/www/html

# Wait for database to be ready
echo "⏳ Waiting for database connection..."
max_tries=30
count=0
until php -r "try { new PDO('pgsql:host=postgres;dbname=${DB_DATABASE:-laravel}', '${DB_USERNAME:-laravel}', '${DB_PASSWORD:-password}'); echo 'connected'; } catch(PDOException \$e) { exit(1); }" &>/dev/null; do
    echo "   Database service not ready, waiting 2 seconds..."
    sleep 2
    count=$((count+1))
    if [ "$count" -ge "$max_tries" ]; then
        echo "❌ Could not connect to database after $max_tries attempts. Continuing anyway..."
        break
    fi
done
echo "✅ Database service is up"

# Run Laravel setup commands
echo "🔧 Setting up Laravel application..."

# Skip cache clearing and dependency installation to reduce memory usage
echo "📦 Using PHP dependencies installed during build..."

# Skip key generation as it's already handled in the Dockerfile
echo "🔑 Using application key generated during build..."

# Skip automatic migrations to reduce memory usage and give developers control
echo "⏭️  Skipping migrations - developers should run 'php artisan migrate' manually when needed"

# Skip optimization commands to reduce memory usage
echo "⚡ Skipping optimization to conserve memory..."

# Create storage link if it doesn't exist
if [ ! -L "public/storage" ]; then
    echo "🔗 Creating storage symlink..."
    php artisan storage:link
fi

# Set proper permissions
echo "🔒 Setting file permissions..."
chown -R www-data:www-data /var/www/html
chmod -R 755 storage bootstrap/cache
chmod -R 775 storage/logs

# Start supervisor to manage all services
echo "🎯 Starting services with Supervisor..."
echo "   - Laravel Octane (Swoole) on port 8000"
echo "   - Queue Workers"
echo "   - WebSocket Server (Reverb) on port 8080"
echo "   - Task Scheduler"

# Start supervisord with the configuration
exec /usr/bin/supervisord -c /etc/supervisord.conf