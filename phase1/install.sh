#!/bin/bash

set -e

#!/bin/bash

echo ">>> FORCE_INSTALL start"

php-fpm &

sleep 10

FORCE_INSTALL=1

if [ "$FORCE_INSTALL" = "1" ]; then
    echo ">>> Shopware installation..."
    
    rm -rf /var/www/html/*
    rm -rf /var/www/html/.*
    
    composer create-project shopware/production /var/www/html --no-interaction || true
    
    cd /var/www/html
    
    mkdir -p var/cache var/log public/thumbnail public/media
    chmod -R 777 var/cache var/log public/thumbnail public/media public/robots.txt 2>/dev/null || true
    
    php -d memory_limit=512M bin/console asset:install --no-interaction || true
    
    echo ">>> Done."
fi

exec php-fpm