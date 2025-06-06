FROM phpswoole/swoole:php8.4-alpine

# Install system dependencies and development tools
RUN apk add --no-cache \
    supervisor \
    curl \
    zip \
    unzip \
    git \
    github-cli \
    bash \
    postgresql-dev \
    libmemcached-dev \
    cyrus-sasl-dev \
    libzip-dev \
    icu-dev \
    oniguruma-dev \
    docker \
    docker-compose \
    openssh-client \
    nano \
    vim \
    && apk add --no-cache --virtual .build-deps \
    autoconf \
    g++ \
    make \
    && docker-php-ext-install \
    pdo_pgsql \
    zip \
    intl \
    bcmath \
    pcntl \
    && pecl install memcached redis \
    && docker-php-ext-enable memcached redis \
    && apk del .build-deps

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory
WORKDIR /var/www/html

# Add user for laravel application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Create directories
RUN mkdir -p /var/log/supervisor \
    && chown -R www-data:www-data /var/www/html \
    && chown -R www-data:www-data /var/log/supervisor

# Copy configuration files
COPY .devcontainer/supervisord.conf /etc/supervisord.conf
COPY .devcontainer/php.ini /usr/local/etc/php/conf.d/custom.ini
COPY .devcontainer/start-app.sh /usr/local/bin/start-app.sh

# Make scripts executable
RUN chmod +x /usr/local/bin/start-app.sh

# Copy application code
COPY . .

# Ensure Laravel directories exist and set permissions in one step
RUN mkdir -p storage/app/public \
    storage/framework/cache \
    storage/framework/sessions \
    storage/framework/views \
    storage/logs \
    bootstrap/cache \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 755 storage bootstrap/cache

# Configure git to trust the directory regardless of ownership
RUN git config --global --add safe.directory /var/www/html

# Expose ports
EXPOSE 8000 8080

# Set entrypoint
ENTRYPOINT ["/usr/local/bin/start-app.sh"]
