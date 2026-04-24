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

    php -d memory_limit=512M bin/console asset:install --no-interaction
    php -d memory_limit=512M bin/console build:theme --no-interaction || true

    echo ">>> Shopware Dateien installiert."
fi

php-fpm