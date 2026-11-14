#!/usr/bin/env bash
# =============================================================================
# setup.sh: Runs via "postCreateCommand" ONCE when Codespace is created.
# =============================================================================

set -e

echo "[Setup] 1. Installing latest version of OpenCode..."
curl -fsSL https://opencode.ai/install | bash

# Create system-wide symlink for OpenCode
if [ -f "$HOME/.opencode/bin/opencode" ]; then
    ln -sf "$HOME/.opencode/bin/opencode" /usr/local/bin/opencode
elif [ -f "/root/.opencode/bin/opencode" ]; then
    ln -sf "/root/.opencode/bin/opencode" /usr/local/bin/opencode
fi

echo "[Setup] 2. Installing intelligent systemctl compatibility layer..."
cat << 'EOF' > /usr/local/bin/systemctl
#!/usr/bin/env bash
# Intelligent systemctl shim for container environments
set -e

if [ -d "/run/systemd/system" ]; then
    exec /bin/systemctl "$@"
fi

ACTION="$1"
UNIT="$2"
SERVICE="${UNIT%.service}"

case "$ACTION" in
    start|stop|restart|reload|force-reload)
        if [ -n "$SERVICE" ]; then
            exec service "$SERVICE" "$ACTION"
        fi
        ;;
    status)
        if [ -n "$SERVICE" ]; then
            exec service "$SERVICE" status
        else
            exec service --status-all
        fi
        ;;
    is-active)
        if service "$SERVICE" status >/dev/null 2>&1; then
            echo "active"
            exit 0
        else
            echo "inactive"
            exit 3
        fi
        ;;
    is-enabled)
        echo "enabled"
        exit 0
        ;;
    enable)
        if command -v update-rc.d >/dev/null 2>&1 && [ -n "$SERVICE" ]; then
            update-rc.d "$SERVICE" defaults >/dev/null 2>&1 || true
        fi
        echo "Synchronizing state of $SERVICE with SysV service script."
        exit 0
        ;;
    disable)
        if command -v update-rc.d >/dev/null 2>&1 && [ -n "$SERVICE" ]; then
            update-rc.d "$SERVICE" disable >/dev/null 2>&1 || true
        fi
        echo "Disabled $SERVICE."
        exit 0
        ;;
    daemon-reload)
        exit 0
        ;;
    list-units|list-unit-files)
        exec service --status-all
        ;;
    *)
        if [ -n "$SERVICE" ]; then
            exec service "$SERVICE" "$ACTION"
        else
            exec service --status-all
        fi
        ;;
esac
EOF
chmod 755 /usr/local/bin/systemctl

echo "[Setup] 3. Importing GitHub SSH keys for passwordless root SSH..."
mkdir -p /root/.ssh && chmod 700 /root/.ssh
if [ -n "$GITHUB_USER" ]; then
    USER_TO_FETCH="$GITHUB_USER"
else
    USER_TO_FETCH="aminmozaffari23-cmyk"
fi

if curl -fsSL "https://github.com/${USER_TO_FETCH}.keys" -o /tmp/gh_keys 2>/dev/null; then
    cat /tmp/gh_keys >> /root/.ssh/authorized_keys
    sort -u /root/.ssh/authorized_keys -o /root/.ssh/authorized_keys
    chmod 600 /root/.ssh/authorized_keys
    rm -f /tmp/gh_keys
    echo "[Setup] Imported SSH public keys for ${USER_TO_FETCH}!"
fi

# Ensure all scripts are executable
chmod +x .devcontainer/*.sh 2>/dev/null || true

echo "[Setup] Provisioning complete! OpenCode version: $(/usr/local/bin/opencode --version 2>/dev/null || echo 'Installed')"
