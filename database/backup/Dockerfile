# HealthBank database backup cron container
# Uses the official MySQL image (already has mysqldump) and adds cron + gzip.
FROM mysql:8.0

# mysql:8.0 is Oracle Linux 8 — use microdnf (not apt-get)
RUN microdnf install -y cronie gzip \
 && microdnf clean all

COPY backup.sh     /backup.sh
COPY entrypoint.sh /entrypoint.sh
COPY crontab       /etc/cron.d/db-backup

RUN chmod +x /backup.sh /entrypoint.sh \
 && chmod 0644 /etc/cron.d/db-backup \
 && touch /var/log/backup.log

VOLUME ["/backups"]

ENTRYPOINT ["/entrypoint.sh"]
