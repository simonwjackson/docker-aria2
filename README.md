# docker-aria2

```yaml
---
version: "3.7"

services:
  aria2:
    image: simonwjackson/docker-aria2:latest
    environment:
      - PUID=$PUID
      - PGID=$PGID
      - TZ=$TZ
      - RPC_LISTEN_PORT=6800
      - RPC_SECRET=<your_password>
    networks:
      - traefik
    volumes:
      - /session
      - /cache
      - <path_to_downloads>:/downloads
    restart: unless-stopped 
```
