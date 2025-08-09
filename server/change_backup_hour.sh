#!/bin/bash

if [ "$#" -eq 0 ]; then
    echo "Backup hours for all clients:"
    for TIMER_FILE in /etc/systemd/system/backup@*.timer; do
        CLIENT=$(basename "$TIMER_FILE" .timer | sed 's/backup@//')
        BACKUP_TIME=$(grep -oP '(?<=^OnCalendar=).*' "$TIMER_FILE")
        echo "Client: $CLIENT, Backup time: $BACKUP_TIME"
    done
    exit 0
elif [ "$#" -ne 2 ]; then
    echo "Use: $0 <clientX> <HH:MM:SS>"
    exit 1
fi

CLIENT=$1
TIME=$2
TIMER_FILE="/etc/systemd/system/backup@${CLIENT}.timer"

if [ ! -f "$TIMER_FILE" ]; then
    echo "Error: file ${TIMER_FILE} does not exist"
    exit 1
fi

sudo sed -i "s|^OnCalendar=.*|OnCalendar=*-*-* $TIME|" "$TIMER_FILE"

sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl restart backup@${CLIENT}.timer

echo "Timer for ${CLIENT} was changed to ${TIME}"
