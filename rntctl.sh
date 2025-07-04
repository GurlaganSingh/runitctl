#!/bin/sh
# rntctl - Minimal Runit service manager
# License: MIT
# Made by Gurlagan Singh Linux Guru Lagan
SV_DIR="/etc/sv"
RUNSVDIR="/var/service"

usage() {
    echo "Usage: $0 [start|enable|disable|status] <service>"
    exit 1
}

[ "$#" -ne 2 ] && usage

ACTION="$1"
SERVICE="$2"
SERVICE_PATH="$SV_DIR/$SERVICE"
ENABLED_PATH="$RUNSVDIR/$SERVICE"

[ ! -d "$SERVICE_PATH" ] && {
    echo "Service '$SERVICE' not found in $SV_DIR."
    exit 2
}

case "$ACTION" in
    start)
        echo "Starting $SERVICE (without enabling)..."
        runsv "$SERVICE_PATH" &
        ;;
    enable)
        if [ ! -e "$ENABLED_PATH" ]; then
            ln -s "$SERVICE_PATH" "$ENABLED_PATH"
            echo "Enabled $SERVICE to run on boot."
        else
            echo "Service '$SERVICE' is already enabled."
        fi
        ;;
    disable)
        if [ -L "$ENABLED_PATH" ]; then
            rm "$ENABLED_PATH"
            echo "Disabled $SERVICE from boot."
        else
            echo "Service '$SERVICE' is not enabled."
        fi
        ;;
    status)
        if [ -L "$ENABLED_PATH" ]; then
            echo "Enabled: yes"
        else
            echo "Enabled: no"
        fi
        sv status "$SERVICE" 2>/dev/null || echo "Not running or no supervision data."
        ;;
    *)
        usage
        ;;
esac
