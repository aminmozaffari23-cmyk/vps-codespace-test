#!/usr/bin/env bash
# =============================================================================
# start-services.sh: Runs via "postStartCommand" on every Codespace boot
# =============================================================================

set -e

echo "[VPS Boot] Starting system initialization..."

# 1. Ensure /dev/net/tun exists (for WireGuard, OpenVPN, Tailscale)
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

# 3. Enable IP Forwarding at runtime (since --privileged is active)
sysctl -w net.ipv4.ip_forward=1 2>/dev/null || true

# 4. Initialize firewall rules
if [ -f .devcontainer/init-firewall.sh ]; then
    bash .devcontainer/init-firewall.sh || true
fi

# 5. Start background daemons via systemctl or service
systemctl start cron 2>/dev/null || service cron start 2>/dev/null || true
systemctl start ssh 2>/dev/null || service ssh start 2>/dev/null || true
if command -v nginx >/dev/null 2>&1; then
    systemctl start nginx 2>/dev/null || service nginx start 2>/dev/null || true
fi

echo "[VPS Boot] Capabilities and devices verified:"
echo " - TUN device: $(ls -l /dev/net/tun 2>/dev/null || echo 'Missing')"
echo " - FUSE device: $(ls -l /dev/fuse 2>/dev/null || echo 'Missing')"
echo " - IP Forwarding: $(cat /proc/sys/net/ipv4/ip_forward 2>/dev/null || echo 'Unknown')"
echo "[VPS Boot] VPS Environment is ready!"
