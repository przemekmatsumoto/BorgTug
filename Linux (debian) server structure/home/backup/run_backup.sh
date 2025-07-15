#!/usr/bin/env bash
set -euo pipefail

CONFIG_FILE="/home/remote-backup/backup/backup.conf"
CLIENT="$1"
TIMESTAMP=$(date '+%Y-%m-%d_%H:%M')

function notify_slack {
  local msg="$1"
  local webhook
  webhook=$(crudini --get "$CONFIG_FILE" global slack_webhook_url 2>/dev/null || echo "")
  [[ -n "$webhook" ]] && \
    curl -s -X POST --data "{\"text\": \"$msg\"}" "$webhook" >/dev/null || true
}


SSH_HOST=$(crudini --get "$CONFIG_FILE" "$CLIENT" ssh_host)
SOCKET_LOCAL=$(crudini --get "$CONFIG_FILE" "$CLIENT" socket_local)
SOCKET_REMOTE=$(crudini --get "$CONFIG_FILE" "$CLIENT" socket_remote)
BORG=$(crudini --get "$CONFIG_FILE" "$CLIENT" borg_binary)
SOCAT=$(crudini --get "$CONFIG_FILE" "$CLIENT" socat_binary)
PASSCMD=$(crudini --get "$CONFIG_FILE" "$CLIENT" passcommand)
REPO=$(crudini --get "$CONFIG_FILE" "$CLIENT" repo)
DIRS=$(crudini --get "$CONFIG_FILE" "$CLIENT" dirs)

SSH_CMD=(
  ssh -o BatchMode=yes -R "${SOCKET_LOCAL}:${SOCKET_REMOTE}" -t "$SSH_HOST"
  "sudo -E BORG_PASSCOMMAND='$PASSCMD' \
    $BORG --rsh=\"sh -c 'exec $SOCAT STDIO UNIX-CONNECT:$SOCKET_LOCAL'\" \
    create --progress ${REPO}::backup-${TIMESTAMP} $DIRS"
)

if ! "${SSH_CMD[@]}"; then
  MSG="❌ Backup *${CLIENT}* failed at ${TIMESTAMP}. Serwer albo klient spadł z rowerka, trzeba ratować!"
  notify_slack "$MSG"
  exit 1
else
  MSG="✅ Backup *${CLIENT}* succeeded at ${TIMESTAMP}"
  notify_slack "$MSG"
fi

exit 0