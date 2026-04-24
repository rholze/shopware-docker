FROM php:8.2-fpm

RUN sed -i 's/memory_limit = .*/memory_limit = 512M/' /usr/local/etc/php/conf.d/docker-php-memory-limit.ini || \
    echo 'memory_limit = 512M' > /usr/local/etc/php/conf.d/docker-php-memory-limit.ini

RUN apt-get update && apt-get install -y \
    libicu-dev \
    libzip-dev \
    libpng-dev \
    unzip \
    git \
    curl \
    libonig-dev \
    && docker-php-ext-install \
    pdo_mysql \
    intl \
    zip \
    gd \
    opcache \
    bcmath

# Redis Extension (WICHTIG!)
RUN pecl install redis && docker-php-ext-enable redis

# Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY install.sh /install.sh
RUN chmod +x /install.sh

CMD ["/install.sh"]
