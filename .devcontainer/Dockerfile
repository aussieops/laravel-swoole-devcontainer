FROM phpswoole/swoole:php8.4-alpine

# Set working directory
WORKDIR /var/www/html

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

# Create directories
RUN mkdir -p /var/log/supervisor \
    && chown -R www-data:www-data /var/www/html \
    && chown -R www-data:www-data /var/log/supervisor

# Copy configuration files
COPY .devcontainer/supervisord.conf /etc/supervisord.conf
COPY .devcontainer/php.ini /usr/local/etc/php/conf.d/custom.ini
COPY .devcontainer/start-app.sh /usr/local/bin/start-app.sh
COPY .devcontainer/healthcheck.sh /usr/local/bin/healthcheck.sh

# Make scripts executable
RUN chmod +x /usr/local/bin/start-app.sh \
    && chmod +x /usr/local/bin/healthcheck.sh

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

# Install PHP dependencies (only in production, dev will run in postCreateCommand)
ARG ENVIRONMENT=development
RUN rm -rf vendor \
    && if [ "$ENVIRONMENT" = "production" ]; then \
    composer install --no-dev --optimize-autoloader; \
    else \
    composer install --no-scripts; \
    fi

# Generate Laravel app key if not set
RUN php artisan key:generate --ansi

# Expose ports
EXPOSE 8000 8080

# Add health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD /usr/local/bin/healthcheck.sh

# Set entrypoint
ENTRYPOINT ["/usr/local/bin/start-app.sh"]
