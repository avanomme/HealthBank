#!/bin/sh
# HealthBank Database Backup Script
# Called by cron with BACKUP_TYPE=daily|weekly|monthly or directly for manual backups.
set -e

BACKUP_TYPE="${BACKUP_TYPE:-daily}"
DAILY_DIR="/backups/daily"
WEEKLY_DIR="/backups/weekly"
MONTHLY_DIR="/backups/monthly"
MANUAL_DIR="/backups/manual"

mkdir -p "$DAILY_DIR" "$WEEKLY_DIR" "$MONTHLY_DIR" "$MANUAL_DIR"
chmod 777 "$DAILY_DIR" "$WEEKLY_DIR" "$MONTHLY_DIR" "$MANUAL_DIR"

case "$BACKUP_TYPE" in
  daily)   OUT_DIR="$DAILY_DIR";   KEEP=7  ;;
  weekly)  OUT_DIR="$WEEKLY_DIR";  KEEP=4  ;;
  monthly) OUT_DIR="$MONTHLY_DIR"; KEEP=3  ;;
  manual)  OUT_DIR="$MANUAL_DIR";  KEEP=10 ;;
  *)
    echo "ERROR: Unknown BACKUP_TYPE='$BACKUP_TYPE'. Use daily|weekly|monthly|manual."
    exit 1
    ;;
esac

DB="${MYSQL_DATABASE:-healthdatabase}"
TS=$(date +%F_%H%M%S)
OUT="${OUT_DIR}/${DB}_${TS}.sql.gz"

echo "[$(date)] Creating $BACKUP_TYPE backup: $OUT"

MYSQL_PWD="$MYSQL_PASSWORD" mysqldump \
  -h "${MYSQL_HOST:-mysql}" \
  -u"$MYSQL_USER" \
  --ssl-mode=DISABLED \
  --databases "$DB" \
  --single-transaction \
  --routines \
  --triggers \
  --events \
  --set-gtid-purged=OFF \
  --no-tablespaces \
  | gzip > "$OUT"

chmod 644 "$OUT"
SIZE=$(du -sh "$OUT" | cut -f1)
echo "[$(date)] Backup complete: $OUT ($SIZE)"

# ── Audit log ────────────────────────────────────────────────────────────────
# Write a backup_scheduled entry directly to AuditEvent so cron backups
# appear in the admin audit log alongside manual and download actions.
FNAME=$(basename "$OUT")
mysql -h "${MYSQL_HOST:-mysql}" -u"$MYSQL_USER" --skip-ssl \
  -e "INSERT INTO AuditEvent (ActorType, Action, ResourceType, ResourceID, Status, HttpMethod, Path, MetadataJSON)
      VALUES ('system', 'backup_scheduled', 'backup', '$FNAME', 'success', 'CRON', '/cron/backup',
              JSON_OBJECT('backup_type', '$BACKUP_TYPE', 'size', '$SIZE', 'file', '${OUT_DIR##*/backups/}/$FNAME'))" \
  "$DB" 2>/dev/null || echo "[$(date)] Warning: could not write audit log entry"

# Retention: remove oldest files beyond KEEP limit
ls -t "${OUT_DIR}"/*.sql.gz 2>/dev/null | tail -n +$((KEEP + 1)) | while read -r f; do
  echo "[$(date)] Removing old backup: $f"
  rm -f "$f"
done
