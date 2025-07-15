#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Użycie: $0 <clientX> <HH:MM:SS>"
    exit 1
fi

CLIENT=$1
TIME=$2
TIMER_FILE="/etc/systemd/system/backup@${CLIENT}.timer"

if [ ! -f "$TIMER_FILE" ]; then
    echo "Błąd: plik ${TIMER_FILE} nie istnieje"
    exit 1
fi

sudo sed -i "s|^OnCalendar=.*|OnCalendar=*-*-* $TIME|" "$TIMER_FILE"

sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl restart backup@${CLIENT}.timer

echo "Zmieniono godzinę timera ${CLIENT} na ${TIME}"