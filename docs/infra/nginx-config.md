<!-- Created with the Assistance of Claude Code -->
# Nginx Configuration

## Overview

Nginx serves as the reverse proxy and static file server for HealthBank. It serves the Flutter web build and proxies API requests to the FastAPI backend.

## File Location

`nginx/nginx.conf`

## Key Configuration

### API Proxy (`/api/`)

All requests to `/api/*` are forwarded to the FastAPI backend container (`api:80`).

```nginx
location /api/ {
    proxy_pass http://api:80;
    proxy_http_version 1.1;
    proxy_set_header Host $http_host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}
```

**Important:** Backend JSON error responses (401, 403, 404, 500) pass through to the frontend unchanged. This allows the frontend Dio error interceptor to parse the JSON error body and handle errors appropriately (e.g., redirecting to login on 401).

### Rate Limiting

| Zone | Rate | Burst | Purpose |
|------|------|-------|---------|
| `api_limit` | 10 req/s | 20 | API endpoints |
| `general_limit` | 30 req/s | 50 (static), 30 (SPA) | Static assets and page loads |

### Static Assets

- **Immutable assets** (JS, CSS, images, fonts, WASM): cached for 1 year
- **HTML files**: no-cache (allows updates)
- **Service worker**: no-cache

### Security Headers

- `X-Frame-Options: SAMEORIGIN`
- `X-Content-Type-Options: nosniff`
- `X-XSS-Protection: 1; mode=block`
- `Referrer-Policy: strict-origin-when-cross-origin`
- `Content-Security-Policy`: restricts sources to self, with exceptions for inline scripts/styles

### SPA Fallback

All unmatched routes fall back to `index.html` so Flutter handles client-side routing:

```nginx
location / {
    try_files $uri $uri/ /index.html;
}
```

### Health Check

`GET /health` returns `200 "healthy\n"` for load balancer checks.

## Change Log

| Date | Change | Reason |
|------|--------|--------|
| 2026-02-06 | Removed `proxy_intercept_errors on` from `/api/` block | Was replacing backend JSON error responses (401, 403) with nginx HTML error pages, breaking frontend error handling. The frontend needs raw JSON error bodies to parse error messages and handle 401 session expiry. |
