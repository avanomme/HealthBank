# HealthBank Deployment Guide

## Overview

HealthBank uses Docker Compose to orchestrate four services:

| Service | Container | Purpose |
|---------|-----------|---------|
| mysql | hdbtestdb | MySQL 8.0 database |
| api | hdb-api | FastAPI backend |
| frontend | hdb-frontend-build | Flutter web build (one-shot) |
| nginx | hdb-nginx | Web server & reverse proxy |

## Architecture

```
                    ┌─────────────────┐
                    │   Port 3000     │
                    │   (HTTP/HTTPS)  │
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
                    │      Nginx      │
                    │  (hdb-nginx)    │
                    └────────┬────────┘
                             │
              ┌──────────────┼──────────────┐
              │              │              │
     Static Files      /api/* proxy         │
              │              │              │
    ┌─────────▼─────┐  ┌─────▼─────┐        │
    │ frontend_build│  │  FastAPI  │        │
    │    volume     │  │ (hdb-api) │        │
    └───────────────┘  └─────┬─────┘        │
                             │              │
                    ┌────────▼────────┐     │
                    │     MySQL       │     │
                    │  (hdbtestdb)    │     │
                    └─────────────────┘     │
```

## Quick Start

```bash
# Build and start all services
docker compose up --build

# Or run in background
docker compose up --build -d

# View logs
docker compose logs -f

# Stop all services
docker compose down
```

## Service Details

### Frontend Build (One-Shot)

The frontend container builds the Flutter web app and copies it to a shared volume, then exits. This is a one-shot build process:

1. Flutter compiles Dart to JavaScript
2. Build output copied to `frontend_build` volume
3. Container exits with status 0
4. Nginx serves the static files from the volume

**To rebuild frontend after code changes:**
```bash
docker compose up --build frontend
```

### Nginx Configuration

Nginx serves as:
- Static file server for Flutter web app
- Reverse proxy for API requests (`/api/*` → backend)
- Rate limiter (10 req/sec for API, 30 req/sec for general)
- Security headers provider

Configuration file: `nginx/nginx.conf`

### Health Checks

All services have health checks:

| Service | Endpoint | Interval |
|---------|----------|----------|
| mysql | mysqladmin ping | 10s |
| api | GET /health | 30s |
| nginx | wget localhost:80 | 30s |

### Startup Order

Docker Compose ensures proper startup order:

1. **mysql** starts first, waits until healthy
2. **api** starts after mysql is healthy
3. **frontend** builds (can run parallel with api)
4. **nginx** starts after frontend completes AND api is healthy

## Ports

| Port | Service | Purpose |
|------|---------|---------|
| 3000 | nginx | Web app (HTTP) |
| 443 | nginx | Web app (HTTPS, when configured) |
| 8000 | api | Direct API access (dev only) |
| 3307 | mysql | Direct DB access (dev only) |

## Volumes

| Volume | Purpose |
|--------|---------|
| mysql_data | Persistent database storage |
| frontend_build | Shared Flutter build output |

## SSL/HTTPS Setup

1. Place certificates in `nginx/ssl/`:
   - `fullchain.pem` - Certificate chain
   - `privkey.pem` - Private key

2. Uncomment HTTPS server block in `nginx/nginx.conf`

3. Rebuild nginx:
   ```bash
   docker compose up --build nginx
   ```

## Troubleshooting

### Frontend build fails
```bash
# Check build logs
docker compose logs frontend

# Rebuild from scratch
docker compose build --no-cache frontend
```

### Nginx shows 502 Bad Gateway
```bash
# Check if API is running
docker compose ps api
docker compose logs api

# Verify health check
curl http://localhost:8000/health
```

### Database connection issues
```bash
# Check MySQL status
docker compose logs mysql

# Connect to MySQL directly
docker compose exec mysql mysql -u myuser -p healthdatabase
```

### Clear everything and start fresh
```bash
docker compose down -v  # -v removes volumes
docker compose up --build
```

## Production Checklist

- [ ] Change default passwords in docker-compose.yml
- [ ] Configure SSL certificates
- [ ] Update nginx server_name from localhost
- [ ] Review rate limiting settings
- [ ] Set up log rotation
- [ ] Configure backup for mysql_data volume
- [ ] Update CORS origins in API if needed
