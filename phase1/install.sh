#!/bin/bash

set -e

php-fpm &

sleep 3

if [ "$FORCE_INSTALL" = "1" ]; then
    echo ">>> Shopware installation..."
    
    rm -rf /var/www/html/*
    rm -rf /var/www/html/.*
    
    composer create-project shopware/production /var/www/html --no-interaction
    
    cd /var/www/html
    
    mkdir -p var/cache var/log public/thumbnail public/media
    chmod -R 777 var/cache var/log public/thumbnail public/media public/robots.txt
    
    php -d memory_limit=512M bin/console asset:install --no-interaction || true
    
    echo ">>> Done."
fi

exec php-fpm