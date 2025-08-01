#!/usr/bin/env bash

set -euo pipefail

CONFIG_FILE="/home/remote-backup/backup/backup.conf"
CLIENT="$1"
ARCHIVE="$2"
DESTDIR="${3:-/}"

function notify_slack {
  local msg="$1"
  local webhook
  webhook=$(crudini --get "$CONFIG_FILE" global slack_webhook_url 2>/dev/null || echo "")
  [[ -n "$webhook" ]] && \
    curl -s -X POST --data "{\"text\": \"$msg\"}" "$webhook" >/dev/null || true
}

SSH_HOST=$(crudini --get "$CONFIG_FILE" "$CLIENT" ssh_host)
SOCKET_REMOTE=$(crudini --get "$CONFIG_FILE" "$CLIENT" socket_remote)
SOCKET_LOCAL=$(crudini --get "$CONFIG_FILE" "$CLIENT" socket_local)
BORG=$(crudini --get "$CONFIG_FILE" "$CLIENT" borg_binary)
SOCAT=$(crudini --get "$CONFIG_FILE" "$CLIENT" socat_binary)
PASSCMD=$(crudini --get "$CONFIG_FILE" "$CLIENT" passcommand)
REPO=$(crudini --get "$CONFIG_FILE" "$CLIENT" repo)

REMOTE_CMD=$(cat <<EOF
mkdir -p "$DESTDIR" && \
cd "$DESTDIR" && \
sudo -E BORG_PASSCOMMAND='$PASSCMD' \
$BORG --rsh="sh -c 'exec $SOCAT STDIO UNIX-CONNECT:$SOCKET_REMOTE'" \
extract --progress ${REPO}::${ARCHIVE}
EOF
)


SSH_CMD=(
  ssh -o BatchMode=yes -R "${SOCKET_REMOTE}:${SOCKET_LOCAL}" "$SSH_HOST"
  "$REMOTE_CMD"
)

if ! "${SSH_CMD[@]}"; then
  notify_slack "❌ Restore *${CLIENT}* :: *${ARCHIVE}* failed to ${DESTDIR}"
  exit 1
else
  notify_slack "✅ Restore *${CLIENT}* :: *${ARCHIVE}* completed to ${DESTDIR}"
fi

exit 0