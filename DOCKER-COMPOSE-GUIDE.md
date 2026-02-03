# Docker Compose Configuration Guide

This project has three Docker Compose files for different environments.

## Files Overview

| File | Purpose | Command |
|------|---------|---------|
| `docker-compose.yml` | **Development** (default) | `docker compose up` |
| `docker-compose.dev.yml` | Development (explicit) | `docker compose -f docker-compose.dev.yml up` |
| `docker-compose.prod.yml` | **Production** | `docker compose -f docker-compose.prod.yml up` |

## Key Differences

### Development (`docker-compose.yml` / `docker-compose.dev.yml`)

**Optimized for local development:**
- ✅ Uses Django's `runserver` (hot-reload on code changes)
- ✅ Mounts code directory for live editing
- ✅ Exposes PostgreSQL on port 5432 (for DB clients like pgAdmin)
- ✅ Uses `.env` for both web and db services
- ✅ `restart: on-failure` (won't restart if you stop it)
- ✅ Single Gunicorn worker

**Environment files:**
- Web service: `.env`
- DB service: `.env`

### Production (`docker-compose.prod.yml`)

**Optimized for production deployment:**
- ✅ Uses Gunicorn with 3 workers (better performance)
- ✅ No code mounting (uses built image)
- ✅ PostgreSQL NOT exposed externally (security)
- ✅ Uses `.env` for web, `.prod-env` for db (separation)
- ✅ `restart: always` (auto-restart on failure)
- ✅ Longer health check intervals (less overhead)

**Environment files:**
- Web service: `.env`
- DB service: `.prod-env`

## Usage

### Local Development

```bash
# Start development environment
docker compose up

# Or explicitly use dev file
docker compose -f docker-compose.dev.yml up

# Run in background
docker compose up -d

# View logs
docker compose logs -f

# Stop
docker compose down
```

### Production (EC2)

```bash
# Start production environment
docker compose -f docker-compose.prod.yml up -d

# View logs
docker compose -f docker-compose.prod.yml logs -f

# Restart after code changes
docker compose -f docker-compose.prod.yml build web
docker compose -f docker-compose.prod.yml up -d

# Stop
docker compose -f docker-compose.prod.yml down
```

## Environment File Setup

### Development `.env`

```bash
SECRET_KEY_DJANGO=dev-secret-key-not-for-production
DEBUG=1
DJANGO_ALLOWED_HOSTS=localhost 127.0.0.1
CSRF_TRUSTED_ORIGINS=http://localhost http://127.0.0.1

POSTGRES_NAME=easymeals
POSTGRES_USER=easymeals_user
POSTGRES_PASSWORD=local_dev_password

ADMIN_ROUTE=admin
DJANGO_SUPERUSER_USERNAME=admin
DJANGO_SUPERUSER_EMAIL=admin@example.com
DJANGO_SUPERUSER_PASSWORD=admin123

# Test reCAPTCHA keys (always pass)
RECAPTCHA_PUBLIC_KEY=6LeIxAcTAAAAAJcZVRqyHh71UMIEGNQ_MXjiZKhI
RECAPTCHA_PRIVATE_KEY=6LeIxAcTAAAAAGG-vFI1TnRWxMZNFuojJ4WifJWe
```

### Production `.env`

```bash
SECRET_KEY_DJANGO=GENERATE_STRONG_SECRET_KEY_HERE
DEBUG=0
DJANGO_ALLOWED_HOSTS=yourdomain.com www.yourdomain.com
CSRF_TRUSTED_ORIGINS=https://yourdomain.com https://www.yourdomain.com

POSTGRES_NAME=easymeals
POSTGRES_USER=easymeals_user
POSTGRES_PASSWORD=STRONG_PRODUCTION_PASSWORD

ADMIN_ROUTE=secret-admin-path-xyz
DJANGO_SUPERUSER_USERNAME=admin
DJANGO_SUPERUSER_EMAIL=your-email@example.com
DJANGO_SUPERUSER_PASSWORD=STRONG_ADMIN_PASSWORD

# Real reCAPTCHA keys from Google
RECAPTCHA_PUBLIC_KEY=your_real_site_key
RECAPTCHA_PRIVATE_KEY=your_real_secret_key
```

### Production `.prod-env`

```bash
POSTGRES_NAME=easymeals
POSTGRES_USER=easymeals_user
POSTGRES_PASSWORD=SAME_AS_IN_ENV_FILE
```

## Hot-Reload in Development

When using `docker-compose.yml` (dev mode):

1. **Python code changes**: Django's `runserver` auto-reloads
2. **Template changes**: Refresh browser (no restart needed)
3. **Static files**: Run `docker compose exec web python manage.py collectstatic`
4. **Model changes**: Run `docker compose exec web python manage.py makemigrations && docker compose exec web python manage.py migrate`
5. **Requirements changes**: Rebuild: `docker compose build web && docker compose up -d`

## Connecting to PostgreSQL (Dev Only)

In development, PostgreSQL is exposed on `localhost:5432`:

```bash
# Using psql
psql -h localhost -U easymeals_user -d easymeals

# Using pgAdmin or other GUI tools
Host: localhost
Port: 5432
Database: easymeals
Username: easymeals_user
Password: (from .env)
```

**Security Note**: This is disabled in production for security.

## Troubleshooting

### "Port already in use" error

```bash
# Check what's using the port
sudo lsof -i :80    # nginx
sudo lsof -i :5432  # postgres

# Stop conflicting services or change ports in docker-compose.yml
```

### Database connection refused

```bash
# Check if db is healthy
docker compose ps

# View db logs
docker compose logs db

# Reset database
docker compose down -v
docker compose up
```

### Code changes not reflecting

```bash
# Development: Should auto-reload, check logs
docker compose logs web

# Production: Need to rebuild
docker compose -f docker-compose.prod.yml build web
docker compose -f docker-compose.prod.yml up -d
```

## Best Practices

1. **Never commit `.env` or `.prod-env`** - they're in `.gitignore`
2. **Use dev mode locally** - faster iteration
3. **Test with prod mode before deploying** - catch issues early
4. **Keep `.prod-env` separate** - different DB credentials
5. **Use strong passwords in production** - generate with `openssl rand -base64 32`

## Quick Reference

```bash
# Development
docker compose up -d
docker compose logs -f web
docker compose exec web python manage.py shell
docker compose down

# Production
docker compose -f docker-compose.prod.yml up -d
docker compose -f docker-compose.prod.yml logs -f web
docker compose -f docker-compose.prod.yml exec web python manage.py shell
docker compose -f docker-compose.prod.yml down
```
