#!/bin/bash

if [ "$#" -ne 2 ]; then
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

echo "Timer hour ${CLIENT} to ${TIME} was changed"