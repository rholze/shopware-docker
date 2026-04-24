#!/bin/bash

if [ ! -f /var/www/html/bin/console ] || [ "$FORCE_INSTALL" = "1" ]; then
    echo ">>> Installiere Shopware..."

    rm -rf /var/www/html/*

    composer create-project shopware/production /var/www/html

    cd /var/www/html

    php bin/console system:install \
        --create-database \
        --basic-setup \
        --shop-name="Mein Shop" \
        --shop-email="admin@example.com" \
        --admin-email="admin@example.com" \
        --admin-password="shopware" \
        --admin-firstname="Admin" \
        --admin-lastname="User" \
        --shop-locale="de-DE" \
        --shop-currency="EUR" \
        --no-interaction

    echo ">>> Konfiguriere Redis..."

    echo "SHOPWARE_CACHE_BACKEND=redis" >> .env
    echo "SHOPWARE_CACHE_BACKEND_OPTIONS=redis://redis:6379" >> .env
    echo "SHOPWARE_SESSION_STORAGE=redis" >> .env

    php bin/console cache:clear
fi

php-fpm