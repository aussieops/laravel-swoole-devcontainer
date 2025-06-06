# Running Laravel Artisan Commands in Docker

This guide explains all the different ways to execute `php artisan` commands in your Dockerized Laravel application.

## Quick Start

The easiest way is to use the shell functions that have been set up. Run the setup script once:

```bash
./setup-docker-aliases.sh
```

Then you can use these commands from anywhere:

```bash
# Run artisan commands
dartisan migrate
dartisan make:controller UserController
dartisan queue:work

# Short version
la migrate
la make:model Post -m

# Other Docker commands
dcompose up -d
dcompose logs app
dlogs nginx           # Follow nginx logs
dsh app              # Open shell in app container
```

## Method 1: Using Shell Functions (Recommended)

After running the setup script, you get these functions:

- `dartisan [command]` - Run Laravel artisan commands
- `la [command]` - Short alias for dartisan
- `dcompose [command]` - Run docker-compose commands
- `dlogs [service]` - Follow logs for a service
- `dsh [service]` - Open shell in a service

### Examples:
```bash
dartisan --version
dartisan migrate:status
dartisan make:controller ApiController --api
dartisan queue:work --tries=3
la tinker
dcompose restart app
dlogs app
dsh postgres  # Open shell in PostgreSQL container
```

## Method 2: Using the Helper Script

Use the `artisan.sh` script:

```bash
./artisan.sh migrate
./artisan.sh make:model Product -m
./artisan.sh queue:work
```

## Method 3: Manual Docker Commands

If you prefer the manual approach:

```bash
cd .devcontainer
docker-compose exec app php artisan [command]
```

### Examples:
```bash
cd .devcontainer
docker-compose exec app php artisan migrate
docker-compose exec app php artisan make:controller UserController
docker-compose exec app php artisan tinker
```

## Method 4: Opening a Shell Session

For multiple commands or interactive work:

```bash
# Using the function
dsh app

# Or manually
cd .devcontainer
docker-compose exec app sh
```

Once inside the container:
```bash
php artisan migrate
php artisan tinker
composer install
npm install
```

## Common Commands

Here are some frequently used artisan commands:

### Database
```bash
dartisan migrate
dartisan migrate:rollback
dartisan migrate:fresh --seed
dartisan db:seed
```

### Code Generation
```bash
dartisan make:controller UserController
dartisan make:model Post -m  # with migration
dartisan make:middleware Auth
dartisan make:request StoreUserRequest
```

### Cache Management
```bash
dartisan cache:clear
dartisan config:clear
dartisan route:clear
dartisan view:clear
dartisan optimize
```

### Queue Management
```bash
dartisan queue:work
dartisan queue:restart
dartisan queue:failed
```

### Laravel Octane (already managed by Supervisor)
```bash
dartisan octane:status
dartisan octane:reload  # Reload workers
```

### Laravel Reverb (WebSockets)
```bash
dartisan reverb:start  # Start WebSocket server
dartisan reverb:restart
```

## Services Status

Check if all services are running:
```bash
dcompose ps
```

View logs for specific services:
```bash
dlogs app      # Laravel application
dlogs nginx    # Nginx web server
dlogs postgres # PostgreSQL database
dlogs redis    # Redis cache
```

## Troubleshooting

### Container Not Running
If you get an error that the container is not running:
```bash
dcompose up -d
```

### Permission Issues
If you encounter permission issues:
```bash
dsh app
chown -R www-data:www-data storage bootstrap/cache
chmod -R 775 storage bootstrap/cache
```

### Clear All Caches
```bash
dartisan optimize:clear
dartisan cache:clear
dartisan config:clear
dartisan route:clear
dartisan view:clear
```

### Restart Services
```bash
dcompose restart app
dartisan octane:reload
```

## Environment Variables

The application uses these Docker services:
- **Database**: PostgreSQL (laravel_postgres)
- **Cache**: Redis (laravel_redis) 
- **Session Store**: Memcached (laravel_memcached)
- **Search**: Meilisearch (laravel_meilisearch)
- **Mail Testing**: Mailpit (laravel_mailpit)
- **Web Server**: Nginx (laravel_nginx)

All environment variables are configured in `.env` to use the Docker service names.

## Development Workflow

1. Start all services: `dcompose up -d`
2. Run migrations: `dartisan migrate`
3. Start development: Access http://localhost
4. View emails: http://localhost:8025 (Mailpit)
5. Search admin: http://localhost:7700 (Meilisearch)
6. Check logs: `dlogs app`
7. Run tests: `dartisan test`

The Laravel application runs with Octane/Swoole for high performance, with Supervisor managing background processes (queue workers, WebSocket server, scheduler).
