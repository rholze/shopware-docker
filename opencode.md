# Shopware Docker + Coolify Setup

## Ziel

Kleiner anfangen und Schritt für Schritt erweitern.

## Phase 1: Minimal (nginx + php + db)

### docker-compose.yml
```yaml
version: '3.8'

services:
  db:
    image: mariadb:10.11
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: shopware
      MYSQL_USER: shopware
      MYSQL_PASSWORD: shopware
    volumes:
      - db_data:/var/lib/mysql

  php:
    build:
      context: .
      dockerfile: php.Dockerfile
    restart: unless-stopped
    expose:
      - "9000"
    volumes:
      - shopware_data:/var/www/html
    environment:
      APP_ENV: prod
      APP_URL: https://shopware.myhobby-ki.de
      PHP_MEMORY_LIMIT: 512M

  nginx:
    image: nginx:latest
    restart: unless-stopped
    volumes:
      - shopware_data:/var/www/html
      - ./nginx/default.conf:/etc/nginx/conf.d/default.conf
    depends_on:
      - php

volumes:
  db_data:
  shopware_data:
```

### nginx/default.conf
```nginx
server {
    listen 80;
    server_name _;
    root /var/www/html/public;
    index index.php index.html;

    location / {
        try_files $uri /index.php$is_args$args;
    }

    location ~ \.php$ {
        fastcgi_pass php:9000;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }
}
```

### php.Dockerfile
```dockerfile
FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    libicu-dev libzip-dev libpng-dev unzip git curl libonig-dev && \
    docker-php-ext-install pdo_mysql intl zip gd opcache bcmath

RUN pecl install redis && docker-php-ext-enable redis
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY install.sh /install.sh
RUN chmod +x /install.sh

CMD ["/install.sh"]
```

### install.sh
```bash
#!/bin/bash

php-fpm &

if [ ! -f /var/www/html/platforms.php ] || [ "$FORCE_INSTALL" = "1" ]; then
    rm -rf /var/www/html/*
    composer create-project shopware/production /var/www/html --no-interaction
    
    cd /var/www/html
    mkdir -p var/cache var/log public/thumbnail public/media
    chmod -R 777 var/cache var/log public/thumbnail public/media
    
    php -d memory_limit=512M bin/console asset:install --no-interaction
fi

exec php-fpm
```

## Phase 2: + Redis (optional)
```yaml
  redis:
    image: redis:7
```

## Phase 3: + Worker (optional)
```yaml
  worker:
    build: .
    command: php bin/console messenger:consume async --time-limit=3600
```

## Coolify Einstellungen

### Umgebungsvariablen
- `FORCE_INSTALL=1` (für Neuinstallation)
- `APP_URL=https://shopware.myhobby-ki.de`

### Ports
- nginx: 80
- db: 3306
- redis: 6379

## Bekannte Probleme

1. **502 Bad Gateway**: PHP Container nicht erreichbar
   - Ursache: Coolify ändert Containernamen
   - Lösung: Explizites Netzwerk oder warten bis php-fpm startet

2. **Mixed Content**: Shop liefert HTTP statt HTTPS
   - Lösung: APP_URL setzen

3. **Keine Schreibrechte**: public/ nicht beschreibbar
   - Lösung: chmod -R 777 public/

4. **Memory exhausted**: PHP Memory zu klein
   - Lösung: PHP_MEMORY_LIMIT=512M

5. **nginx Volume Mount**: Coolify mountet Verzeichnis statt Datei
   - Lösung: Eigenes nginx Dockerfile mit eingebetteter Config

## Befehle

```bash
# Neuinstall erzwingen
FORCE_INSTALL=1 docker compose up -d --build

# Logs ansehen
docker compose logs -f php
docker compose logs -f nginx
docker compose logs -f db

# Container neu starten
docker compose restart php
```