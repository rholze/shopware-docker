#!/bin/bash

if [ ! -f /var/www/html/platforms.php ] || [ "$FORCE_INSTALL" = "1" ]; then
    echo ">>> Installiere Shopware Dateien..."

    rm -rf /var/www/html/*
    rm -rf /var/www/html/.*

    composer create-project shopware/production /var/www/html --no-interaction

    cd /var/www/html

    mkdir -p var/cache var/log
    chmod -R 777 var/cache var/log public/thumbnail public/media public/robots.txt
    chown -R www-data:www-data /var/www/html

    rm -f .env
    touch .env
    echo "APP_URL=https://shopware.myhobby-ki.de" >> .env
    echo "APP_ENV=prod" >> .env
    echo "DATABASE_URL=mysql://shopware:shopware@db:3306/shopware" >> .env
    echo "REDIS_URL=redis://redis:6379" >> .env

    php -d memory_limit=512M bin/console asset:install --no-interaction
    php -d memory_limit=512M bin/console build:theme --no-interaction || true

    echo ">>> Shopware Dateien installiert."
fi

php-fpm