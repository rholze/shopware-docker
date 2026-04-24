# Shopware Docker Setup - Coolify Deployment

## Aktueller Stand (24. April 2026)

### Probleme und Lösungen

1. **nginx Volume Mount**: Coolify mountet Verzeichnis statt Datei
   - Lösung: Eigenes nginx Docker Image mit eingebetteter Config

2. **Memory Limit**: PHP 128M reicht nicht für Installation
   - Lösung: Dockerfile setzt memory_limit=512M

3. **Shopware Installation**: Mehrere Iterationen nötig
   - Install.sh erstellt .env mit DATABASE_URL und REDIS_URL
   - --drop-database Flag für saubere Installation
   - --skip-assets-install um Memory zu sparen

4. **500 Error bei /index.php**: PHP antwortet nicht richtig
   - Debug Logging in nginx aktiviert
   - Warte auf bessere Fehlermeldungen

### Dateien

- `docker-compose.yml`: 4 Services (db, redis, php, nginx)
- `Dockerfile`: PHP 8.2-FPM mit Shopware
- `nginx.Dockerfile`: Custom nginx mit Config
- `install.sh`: Installationsskript
- `nginx/default.conf`: nginx Config

### Aktuelle Issues

- nginx gibt 500 bei PHP-Anfragen
- PHP-FPM antwortet nicht auf FastCGI
- Coolify-prefixed Containernamen
- Volumes können nicht gelöscht werden (read-only in Coolify)