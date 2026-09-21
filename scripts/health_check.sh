#!/bin/bash

LOG_DATE=$(date)
HOST=$(hostname)
OVERALL="HEALTHY"

echo "=================================="
echo " CloudLearn Server Health Report"
echo "=================================="
echo "Date: $LOG_DATE"
echo "Hostname: $HOST"

echo
echo "---- Server Uptime ----"
uptime

echo
echo "---- Memory Usage ----"
free -h

MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
MEM_AVAILABLE=$(free -m | awk '/Mem:/ {print $7}')
MEM_PERCENT=$(( MEM_AVAILABLE * 100 / MEM_TOTAL ))

echo "Available memory: ${MEM_PERCENT}%"

if [ "$MEM_PERCENT" -lt 15 ]; then
    echo "Memory: WARNING - Low available memory"
    OVERALL="WARNING"
else
    echo "Memory: HEALTHY"
fi

echo
echo "---- Root Disk Usage ----"
df -h /

DISK_PERCENT=$(df / | awk 'NR==2 {gsub("%","",$5); print $5}')

if [ "$DISK_PERCENT" -ge 80 ]; then
    echo "Disk: WARNING - Root disk usage ${DISK_PERCENT}%"
    OVERALL="WARNING"
else
    echo "Disk: HEALTHY - Root disk usage ${DISK_PERCENT}%"
fi

echo
echo "---- Apache Service ----"

if systemctl is-active --quiet httpd; then
    echo "Apache: HEALTHY"
else
    echo "Apache: CRITICAL - Not running"
    OVERALL="CRITICAL"
fi

echo
echo "---- Website HTTP Check ----"

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" \
--max-time 5 http://localhost/)

if [ "$HTTP_CODE" = "200" ]; then
    echo "Website: HEALTHY (HTTP 200)"
else
    echo "Website: WARNING (HTTP $HTTP_CODE)"
    if [ "$OVERALL" != "CRITICAL" ]; then
        OVERALL="WARNING"
    fi
fi

echo
echo "---- Overall Health ----"
echo "Overall Status: $OVERALL"
echo "=========== Check Complete ==========="
