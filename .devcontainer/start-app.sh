#!/bin/bash

# Laravel Swoole Container Startup Script
# This script prepares the Laravel application and starts all services

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

if [ ! -d "vendor" ]; then
    composer install --no-interaction --no-progress --prefer-dist
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

# Set proper permissions
echo "🔒 Setting file permissions..."
chown -R www-data:www-data /var/www/html
chmod -R 755 storage bootstrap/cache
chmod -R 775 storage/logs

php artisan queue:restart

# Start supervisord with the configuration
exec /usr/bin/supervisord -n -c /etc/supervisord.conf