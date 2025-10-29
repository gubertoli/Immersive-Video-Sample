#!/bin/bash
set -e

echo "Running init-all.sh..."
echo "no" | ./bin/init-all.sh

echo "Running start-all.sh..."
./bin/start-all.sh

echo "Server processes started by start-all.sh."
echo "Tailing portal log to keep container alive and show output..."

sleep 5

LOG_FILE="logs/portal.stdout"
if [ -f "$LOG_FILE" ]; then
    tail -f "$LOG_FILE"
else
    echo "Warning: Log file $LOG_FILE not found. Falling back to sleep infinity."
    sleep infinity
fi
