# Laravel Docker Artisan Aliases
# Add these to your ~/.bashrc, ~/.zshrc, or equivalent shell configuration file

# Function-based aliases that work from any directory
dartisan() {
    local project_dir="/Users/ahmadalsodani/Herd/dockerized-laravel-swoole/.devcontainer"
    (cd "$project_dir" && docker-compose exec app php artisan "$@")
}

# Alternative shorter name
la() {
    local project_dir="/Users/ahmadalsodani/Herd/dockerized-laravel-swoole/.devcontainer"
    (cd "$project_dir" && docker-compose exec app php artisan "$@")
}

# For other Docker commands
dcompose() {
    local project_dir="/Users/ahmadalsodani/Herd/dockerized-laravel-swoole/.devcontainer"
    (cd "$project_dir" && docker-compose "$@")
}

# Usage examples:
# dartisan migrate
# dartisan make:controller UserController
# dartisan queue:work
# dartisan --version
# 
# Short version:
# la migrate
# la make:model Post -m
#
# Docker compose commands:
# dcompose up -d
# dcompose logs app
# dcompose restart app
