#!/usr/bin/env bash
# =============================================================================
# start-services.sh: Runs via "postStartCommand" on every Codespace boot
# =============================================================================

set -e

echo "[VPS Boot] Starting system initialization..."

# 1. Ensure /dev/net/tun device exists (for WireGuard, OpenVPN, Tailscale)
if [ ! -c /dev/net/tun ]; then
    echo "[VPS Boot] Initializing /dev/net/tun..."
    mkdir -p /dev/net
    mknod /dev/net/tun c 10 200 || true
    chmod 0666 /dev/net/tun || true
fi

# 2. Ensure FUSE permissions (for rclone, sshfs, AppImage)
if [ -c /dev/fuse ]; then
    chmod 0666 /dev/fuse || true
fi

# 3. Initialize firewall rules
if [ -f .devcontainer/init-firewall.sh ]; then
    bash .devcontainer/init-firewall.sh || true
fi

# 4. Check if systemd is active as PID 1
if [ -d /run/systemd/system ]; then
    echo "[VPS Boot] Systemd is active as PID 1!"
    systemctl is-system-running || true
    systemctl start cron.service || true
    systemctl start ssh.service || true
    if command -v nginx >/dev/null 2>&1; then
        systemctl start nginx.service || true
    fi
else
    echo "[VPS Boot] Running in container fallback mode (service/SysV)..."
    service cron start || true
    service ssh start || true
    if command -v nginx >/dev/null 2>&1; then
        service nginx start || true
    fi
fi

echo "[VPS Boot] Capabilities and devices verified:"
echo " - TUN device: $(ls -l /dev/net/tun 2>/dev/null || echo 'Missing')"
echo " - FUSE device: $(ls -l /dev/fuse 2>/dev/null || echo 'Missing')"
echo " - IP Forwarding: $(cat /proc/sys/net/ipv4/ip_forward 2>/dev/null || echo 'Unknown')"
echo "[VPS Boot] VPS Environment is ready!"
