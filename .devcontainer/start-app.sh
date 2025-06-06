#!/bin/bash

# Laravel Swoole Container Startup Script
# This script prepares the Laravel application and starts all services

# Change to application directory
cd /var/www/html

# Check if we're in a Docker-enabled environment (Coder)
if [ -f "/.dockerenv" ]; then
    echo "🐳 Docker-in-Docker environment detected - ensuring Docker daemon is running"
    # Start Docker daemon in background if it's not running already
    if ! pgrep dockerd > /dev/null; then
        echo "Starting Docker daemon in background"
        dockerd > /var/log/dockerd.log 2>&1 &
        # Wait for Docker to start
        echo "Waiting for Docker daemon to become available..."
        timeout=10
        counter=0
        while ! docker info >/dev/null 2>&1; do
            if [ "$counter" -gt "$timeout" ]; then
                echo "WARNING: Docker daemon not ready, but continuing..."
                break
            fi
            echo "Waiting for Docker daemon... ($counter/$timeout)"
            counter=$((counter + 1))
            sleep 1
        done
    fi
    echo "🐳 Docker is available!"
fi

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

# Ensure Composer dependencies are installed and complete
echo "📦 Checking Composer dependencies..."
if [ ! -f "vendor/autoload.php" ] || [ ! -d "vendor/symfony/deprecation-contracts" ]; then
    echo "📦 Installing or repairing Composer dependencies..."
    # Set memory limit to -1 to avoid memory issues
    COMPOSER_MEMORY_LIMIT=-1 composer install --no-interaction --no-progress --prefer-dist
else
    echo "✅ Composer dependencies look complete"
fi

# Generate key if not already set
if [ ! -f ".env" ]; then
    cp .env.example .env
    php artisan key:generate
fi

# Create storage link if it doesn't exist
if [ ! -L "public/storage" ]; then
    echo "🔗 Creating storage symlink..."
    php artisan storage:link
fi

# Set proper permissions only on directories that need them
echo "🔒 Setting file permissions..."
# Skip .git directory to avoid permission errors
find storage bootstrap/cache -type d -exec chmod 755 {} \;
find storage/logs -type d -exec chmod 775 {} \;
find storage -type f -exec chmod 644 {} \;
touch storage/logs/laravel.log
chmod 664 storage/logs/laravel.log

echo "🔧 Ensuring write permissions on critical directories..."

php artisan queue:restart

# Start supervisord with the configuration
exec /usr/bin/supervisord -n -c /etc/supervisord.conf