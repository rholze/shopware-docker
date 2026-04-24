# Shopware Docker Setup - Coolify Deployment

## Aktueller Stand (24. April 2026)

### Letzte Probleme

- **CSS fehlt im Installer**: Shop served static files incorrectly
- **Lösung**: Added explicit /media/ and /thumbnail/ paths to nginx config
- Network fixed: Using explicit bridge network
- Healthchecks added to php and nginx

### Historie

1. **nginx Volume Mount**: Coolify mountet Verzeichnis statt Datei
   - Lösung: Eigenes nginx Docker Image mit eingebetteter Config

2. **Network Connection**: "Connection refused" between nginx and php
   - Lösung: Explizites Netzwerk in docker-compose.yml

3. **Berechtigungen**: "Unable to create cache directory"
   - chmod -R 777 var/cache var/log public/thumbnail public/media

### Aktuelle Issues

- CSS/Assets im Web-Installer fehlen
- Shop via /installer aufrufbar aber ohne Styling