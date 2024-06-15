#!/bin/bash

URL="http://65.0.124.97/"

LOG_FILE="/var/log/app_health.log"

TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" $URL)

if [ "$RESPONSE" -eq 200 ]; then
    STATUS="OK"
else
    STATUS="DOWN"
fi

echo "$TIMESTAMP - $URL - $STATUS (HTTP $RESPONSE)" >> $LOG_FILE

