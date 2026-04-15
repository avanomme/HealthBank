# HealthBank FastAPI Backend - Production Dockerfile

# Use slim Python image for smaller size
FROM python:3.11-slim AS base

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Create non-root user for security
RUN groupadd --gid 1000 appgroup && \
    useradd --uid 1000 --gid appgroup --shell /bin/bash --create-home appuser

WORKDIR /code

# Install system dependencies (mysql-client provides mysqldump for manual DB backups)
RUN apt-get update \
 && apt-get install -y --no-install-recommends default-mysql-client \
 && rm -rf /var/lib/apt/lists/*

# Install dependencies first (better caching)
COPY ./backend/requirements.txt /code/requirements.txt
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --upgrade -r /code/requirements.txt

# Copy application code
COPY ./backend/app /code/app
COPY ./database/init/01_create_database.sql /code/app/create_database.sql
COPY ./database/init/02_survey_seed_data.sql /code/app/survey_seed_data.sql
COPY ./database/migrations /code/app/migrations

# Change ownership to non-root user
RUN chown -R appuser:appgroup /code

# Create backup directory structure with world-writable permissions.
# Docker initializes empty named volumes from the image, so these permissions
# are inherited when the db_backups volume is first created.
RUN mkdir -p /backups/daily /backups/weekly /backups/monthly /backups/manual \
 && chmod -R 777 /backups

# Switch to non-root user
USER appuser

# Expose port
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:80/health')" || exit 1

# Run with uvicorn for production (more control than fastapi run)
CMD ["python", "-m", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80", "--workers", "2"]
