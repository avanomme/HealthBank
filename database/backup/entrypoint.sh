#!/bin/sh
# Entrypoint for HealthBank DB backup cron container.
# Exports env vars so cron jobs can read MySQL credentials.
set -e

# Create backup directories with open permissions so the API container
# (running as non-root UID 1000) can also read/write to the shared volume.
mkdir -p /backups/daily /backups/weekly /backups/monthly /backups/manual
chmod -R 777 /backups

# Make env vars available to cron (cron doesn't inherit the shell environment).
printenv | grep -E '^(MYSQL_|BACKUP_)' > /etc/backup.env
chmod 600 /etc/backup.env

echo "[$(date)] HealthBank backup cron started."
echo "[$(date)] Schedule: daily 02:00, weekly Sun 03:00, monthly 1st 04:00"

# Run crond in the foreground so Docker keeps the container alive.
# -n = no-daemon (foreground), works on Oracle Linux (mysql:8.0 base image).
exec crond -n
