# Laravel DevContainer with Swoole/Octane

This DevContainer configuration provides a complete Laravel development environment with Swoole/Octane, optimized for local development and seamless VS Code integration.

## 🚀 Features

### Core Services
- **Laravel 11** with **Swoole/Octane** for high-performance PHP
- **PostgreSQL 16** database
- **Redis 7** for caching and queues
- **Memcached** for session storage
- **Nginx** as reverse proxy
- **Mailpit** for email testing
- **Meilisearch** for full-text search

### Development Tools
- **Git & GitHub CLI** pre-installed
- **Docker & Docker Compose** for container management
- **VS Code extensions** optimized for Laravel development
- **Xdebug** ready for debugging
- **Supervisor** for process management

### DevContainer Benefits
- **Consistent Environment**: Same setup across all development machines
- **Zero Configuration**: Everything pre-configured and ready to use
- **Docker-in-Docker**: Full Docker support within the container
- **VS Code Integration**: Seamless editor experience with extensions
- **Database Tools**: Pre-configured database connections

## 🏁 Quick Start

### Option 1: VS Code DevContainer (Recommended)

1. **Prerequisites**:
   - [VS Code](https://code.visualstudio.com/)
   - [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
   - [Docker Desktop](https://www.docker.com/products/docker-desktop/)

2. **Open in DevContainer**:
   ```bash
   # Clone and open in VS Code
   git clone <your-repo-url>
   cd dockerized-laravel-swoole
   code .
   
   # VS Code will prompt to "Reopen in Container" - click Yes
   # Or use Command Palette: "Dev Containers: Reopen in Container"
   ```

3. **Wait for Setup**: The container will build and install dependencies automatically.

### Option 2: Manual Docker Setup

```bash
# Navigate to the project
cd dockerized-laravel-swoole

# Build and start services
docker-compose -f .devcontainer/docker-compose.yaml up -d

# Access the container
docker exec -it laravel_app_dev bash

# Set up shell aliases (optional)
./setup-docker-aliases.sh
```

## 📁 File Structure

```
.devcontainer/
├── devcontainer.json          # DevContainer configuration
├── docker-compose.yaml        # Development services
├── Dockerfile                 # Development container
├── nginx.conf                 # Nginx configuration
├── supervisord.conf           # Process management
├── php.ini                    # PHP configuration
├── healthcheck.sh            # Health monitoring
└── README.md                 # This file
```

## 🌐 Service Access

After the container starts, access services at:

| Service        | URL                   | Description                |
| -------------- | --------------------- | -------------------------- |
| Laravel App    | http://localhost      | Main application via Nginx |
| Laravel Direct | http://localhost:8000 | Direct Octane access       |
| Mailpit        | http://localhost:8025 | Email testing interface    |
| Meilisearch    | http://localhost:7700 | Search admin interface     |
| WebSockets     | ws://localhost:8080   | Laravel Reverb WebSockets  |
| PostgreSQL     | localhost:5432        | Database connection        |
| Redis          | localhost:6379        | Cache/queue connection     |

### Database Connection (VS Code SQLTools)

A pre-configured PostgreSQL connection is available in VS Code:
- **Name**: Laravel PostgreSQL
- **Host**: postgres (or localhost from host)
- **Port**: 5432
- **Database**: laravel
- **Username**: laravel
- **Password**: password

## 🛠️ Development Workflow

### Running Artisan Commands

**Inside DevContainer**:
```bash
# Direct execution
php artisan migrate
php artisan make:model Product

# Using helper script
./artisan.sh migrate
./artisan.sh make:controller ProductController
```

**From Host Machine** (after setting up aliases):
```bash
# Using shell functions (run ./setup-docker-aliases.sh first)
dartisan migrate
dartisan make:model Product
dartisan queue:work

# Using helper script
./artisan.sh migrate
```

### Installing Dependencies

```bash
# PHP dependencies
composer install
composer require spatie/laravel-permission

# Node.js dependencies (if needed)
npm install
npm run dev
```

### Database Operations

```bash
# Run migrations
php artisan migrate

# Seed database
php artisan db:seed

# Fresh migration with seeding
php artisan migrate:fresh --seed
```

### Queue and Job Processing

```bash
# Process jobs (already running via Supervisor)
php artisan queue:work

# Check queue status
php artisan queue:monitor
```

## 🔧 Configuration

### PHP Configuration

Custom PHP settings in `.devcontainer/php.ini`:
- Memory limit: 512M
- Upload limits: 100M
- Timezone: UTC
- Error reporting configured for development

### Nginx Configuration

- Reverse proxy to Laravel Octane
- Static file serving
- WebSocket support for Reverb
- Gzip compression enabled

### Supervisor Configuration

Automatically manages:
- Laravel Octane server
- Queue workers
- WebSocket server (Reverb)
- Task scheduler

## 🐛 Debugging

### Xdebug Setup

Xdebug is pre-configured and ready to use:

1. **VS Code**: Set breakpoints and press F5 to start debugging
2. **Browser**: Install Xdebug helper extension
3. **CLI**: Use `php -dxdebug.start_with_request=yes artisan ...`

### Log Access

```bash
# Laravel logs
tail -f storage/logs/laravel.log

# Swoole logs
tail -f storage/logs/swoole_http.log

# Nginx logs
docker logs laravel_nginx_dev

# Container logs
docker logs laravel_app_dev
```

## 🚨 Troubleshooting

### Container Won't Start

```bash
# Check container status
docker-compose -f .devcontainer/docker-compose.yaml ps

# View container logs
docker-compose -f .devcontainer/docker-compose.yaml logs app

# Rebuild containers
docker-compose -f .devcontainer/docker-compose.yaml build --no-cache
```

### Database Connection Issues

```bash
# Check PostgreSQL status
docker-compose -f .devcontainer/docker-compose.yaml exec postgres pg_isready

# Reset database
docker-compose -f .devcontainer/docker-compose.yaml exec app php artisan migrate:fresh
```

### Permission Issues

```bash
# Fix Laravel permissions
docker-compose -f .devcontainer/docker-compose.yaml exec app chown -R www-data:www-data storage bootstrap/cache
```

### Port Conflicts

If ports are already in use:

1. Stop conflicting services
2. Or modify ports in `docker-compose.yaml`
3. Update port forwarding in `devcontainer.json`

## 🔄 Updates and Maintenance

### Updating Dependencies

```bash
# Update Composer packages
composer update

# Update Node.js packages
npm update

# Update Docker images
docker-compose -f .devcontainer/docker-compose.yaml pull
docker-compose -f .devcontainer/docker-compose.yaml build --no-cache
```

### Container Cleanup

```bash
# Remove containers and volumes
docker-compose -f .devcontainer/docker-compose.yaml down -v

# Clean up Docker system
docker system prune -a
```

## 📚 Additional Resources

- [Laravel Octane Documentation](https://laravel.com/docs/octane)
- [Swoole Documentation](https://www.swoole.co.uk/docs/)
- [VS Code Dev Containers](https://code.visualstudio.com/docs/devcontainers/containers)
- [Docker Compose Reference](https://docs.docker.com/compose/)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test in the development container
5. Submit a pull request

## 📄 License

This DevContainer configuration is open-source software licensed under the [MIT license](https://opensource.org/licenses/MIT).
