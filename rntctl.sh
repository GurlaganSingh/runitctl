#!/bin/sh
# rntctl - Minimal Runit service manager for Void & Artix Linux
# License: MIT
# I am a lazy programmer and don't add much comments so it is onto you to understand the code

# Auto-detect service and supervision directories
if [ -d /etc/sv ] && [ -d /var/service ]; then
    SV_DIR="/etc/sv"
    RUNSVDIR="/var/service"
elif [ -d /etc/runit/sv ] && [ -d /run/runit/service ]; then
    SV_DIR="/etc/runit/sv"
    RUNSVDIR="/run/runit/service"
else
    echo "Error: Unsupported Runit layout."
    echo "Please manually edit SV_DIR and RUNSVDIR in the script."
    exit 1
fi

usage() {
    echo "Usage: $0 [start|enable|disable|status] <service>"
    exit 1
}

[ "$#" -ne 2 ] && usage

ACTION="$1"
SERVICE="$2"
SERVICE_PATH="$SV_DIR/$SERVICE"
ENABLED_PATH="$RUNSVDIR/$SERVICE"

# Check service exists
[ ! -d "$SERVICE_PATH" ] && {
    echo "Service '$SERVICE' not found in $SV_DIR."
    exit 2
}

case "$ACTION" in
    start)
        echo "Starting $SERVICE (without enabling at boot)..."
        runsv "$SERVICE_PATH" &
        ;;
    enable)
        rm -f "$SERVICE_PATH/down" 2>/dev/null
        if [ ! -e "$ENABLED_PATH" ]; then
            ln -s "$SERVICE_PATH" "$ENABLED_PATH"
            echo "Enabled $SERVICE to run on boot."
        else
            echo "Service '$SERVICE' is already enabled."
        fi
        ;;
    disable)
        touch "$SERVICE_PATH/down"
        if [ -L "$ENABLED_PATH" ]; then
            rm "$ENABLED_PATH"
            echo "Disabled $SERVICE from boot and marked it 'down'."
        else
            echo "Marked $SERVICE as 'down', not symlinked anyway."
        fi
        ;;
    status)
        if [ -L "$ENABLED_PATH" ]; then
            echo "Enabled: yes"
        else
            echo "Enabled: no"
        fi
        sv status "$SERVICE_PATH" 2>/dev/null || echo "Not running or no supervision info."
        ;;
    *)
        usage
        ;;
esac
