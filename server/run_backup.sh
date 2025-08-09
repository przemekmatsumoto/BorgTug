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
SOCKET_REMOTE=$(crudini --get "$CONFIG_FILE" "$CLIENT" socket_remote)
SOCKET_LOCAL=$(crudini --get "$CONFIG_FILE" "$CLIENT" socket_local)
BORG=$(crudini --get "$CONFIG_FILE" "$CLIENT" borg_binary)
SOCAT=$(crudini --get "$CONFIG_FILE" "$CLIENT" socat_binary)
PASSCMD=$(crudini --get "$CONFIG_FILE" "$CLIENT" passcommand)
REPO=$(crudini --get "$CONFIG_FILE" "$CLIENT" repo)
DIRS=$(crudini --get "$CONFIG_FILE" "$CLIENT" dirs)

USE_DOCKER=$(crudini --get "$CONFIG_FILE" "$CLIENT" use_docker 2>/dev/null || echo "false")

if [ "$USE_DOCKER" = "true" ]; then
    # Parametry specyficzne dla Dockera
    DOCKER_BINARY=$(crudini --get "$CONFIG_FILE" "$CLIENT" docker_binary 2>/dev/null || echo "docker")
    DOCKER_IMAGE=$(crudini --get "$CONFIG_FILE" "$CLIENT" docker_image)
    DOCKER_VOLUMES=$(crudini --get "$CONFIG_FILE" "$CLIENT" docker_volumes)
    DOCKER_USER=$(crudini --get "$CONFIG_FILE" "$CLIENT" docker_user 2>/dev/null || echo "root")
    
    SSH_CMD=(
        ssh
        -o BatchMode=yes
        -tt
        -R "${SOCKET_REMOTE}:${SOCKET_LOCAL}"
        "$SSH_HOST"
        "sudo -E $DOCKER_BINARY run --rm \
            -e BORG_PASSCOMMAND='$PASSCMD' \
            $DOCKER_VOLUMES \
            --user $DOCKER_USER \
            $DOCKER_IMAGE \
            $BORG \
                --rsh=\"sh -c 'exec $SOCAT STDIO UNIX-CONNECT:$SOCKET_REMOTE'\" \
                create --progress ${REPO}::backup-${TIMESTAMP} $DIRS"
    )
else
    SSH_CMD=(
        ssh
        -o BatchMode=yes
        -t
        -R "${SOCKET_REMOTE}:${SOCKET_LOCAL}"
        "$SSH_HOST"
        "sudo -E BORG_PASSCOMMAND='$PASSCMD' \
            $BORG --rsh=\"sh -c 'exec $SOCAT STDIO UNIX-CONNECT:$SOCKET_REMOTE'\" \
            create --progress ${REPO}::backup-${TIMESTAMP} $DIRS"
    )
fi

if ! "${SSH_CMD[@]}"; then
  MSG="❌ Backup *${CLIENT}* failed at ${TIMESTAMP}"
  notify_slack "$MSG"
  exit 1
else
  MSG="✅ Backup *${CLIENT}* succeeded at ${TIMESTAMP}"
  notify_slack "$MSG"
fi

exit 0