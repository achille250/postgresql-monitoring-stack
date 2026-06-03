#!/bin/bash
# pgBadger automated log sync and report generation (sanitized template)
# Configure variables for your environment before scheduling in cron.

set -euo pipefail

REMOTE_USER="pgbadger"
REMOTE_HOST="CHANGE_ME_PRIMARY_HOST"
REMOTE_PORT="22"
INSTANCE="postgres_primary"
REMOTE_LOG_DIR="/var/log/postgresql"
LOCAL_LOG_DIR="/var/log/pgbadger/${INSTANCE}"
REPORT_DIR="/var/www/html/pgbadger/${INSTANCE}"

mkdir -p "${LOCAL_LOG_DIR}" "${REPORT_DIR}"

echo "Fixing read permissions on remote logs (last 7 days)..."
for i in $(seq 0 6); do
  DATE=$(date -d "-${i} day" +%Y-%m-%d)
  ssh -p "${REMOTE_PORT}" "${REMOTE_USER}@${REMOTE_HOST}" \
    "sudo find ${REMOTE_LOG_DIR} -name 'postgresql-${DATE}_*.log' -exec chmod o+r {} +" 2>/dev/null || true
done

echo "Syncing logs..."
for i in $(seq 0 6); do
  DATE=$(date -d "-${i} day" +%Y-%m-%d)
  rsync -az -e "ssh -p ${REMOTE_PORT}" \
    "${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_LOG_DIR}/postgresql-${DATE}_*.log" \
    "${LOCAL_LOG_DIR}/" 2>/dev/null || true
done

find "${LOCAL_LOG_DIR}" -type f -name 'postgresql-*.log' -mtime +7 -delete

pgbadger -f stderr "${LOCAL_LOG_DIR}"/*.log \
  -o "${REPORT_DIR}/report_$(date +%F).html" \
  --exclude-application-name pg_dump

echo "Report: ${REPORT_DIR}/report_$(date +%F).html"
