#!/bin/bash

if [ ! -f /var/www/html/platforms.php ] || [ "$FORCE_INSTALL" = "1" ]; then
    echo ">>> Installiere Shopware..."

    rm -rf /var/www/html/*
    rm -rf /var/www/html/.*

    composer create-project shopware/production /var/www/html --no-interaction

    cd /var/www/html

    php -d memory_limit=512M bin/console system:install \
        --drop-database \
        --create-database \
        --basic-setup \
        --shop-name="Mein Shop" \
        --shop-email="admin@example.com" \
        --shop-locale="de-DE" \
        --shop-currency="EUR" \
        --skip-assets-install \
        --no-interaction

    php -d memory_limit=512M bin/console assets:install

    echo ">>> Konfiguriere Redis..."

    echo "SHOPWARE_CACHE_BACKEND=redis" >> .env
    echo "SHOPWARE_CACHE_BACKEND_OPTIONS=redis://redis:6379" >> .env
    echo "SHOPWARE_SESSION_STORAGE=redis" >> .env

    php -d memory_limit=512M bin/console cache:clear
fi

php-fpm