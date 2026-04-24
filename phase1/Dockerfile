FROM php:8.2-fpm-alpine

RUN apk add --no-cache \
    libicu-dev libzip libpng-dev unzip git curl lib-onig-dev mysql-client

RUN docker-php-ext-install pdo_mysql intl zip gd opcache bcmath

RUN pecl install redis && docker-php-ext-enable redis

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY install.sh /install.sh
RUN chmod +x /install.sh

CMD ["/install.sh"]