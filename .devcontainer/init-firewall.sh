#!/usr/bin/env bash
# =============================================================================
# init-firewall.sh: Safe iptables / UFW firewall configuration for Codespaces
# =============================================================================

set -e

echo "[Firewall] Configuring iptables rules..."

# 1. Allow all loopback (essential for Codespaces internal proxy & VS Code IPC)
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# 2. Allow established and related connections (so outgoing web requests work)
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# 3. Allow incoming traffic on forwarded service ports (e.g., 80, 443, 3000, 2222)
iptables -A INPUT -p tcp --dport 2222 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -p tcp --dport 3000 -j ACCEPT
iptables -A INPUT -p tcp --dport 8080 -j ACCEPT

# 4. Optional: Log dropped packets (uncomment for debugging)
# iptables -A INPUT -m limit --limit 5/min -j LOG --log-prefix "[IPTABLES REJECT]: " --log-level 7

echo "[Firewall] Current iptables rules:"
iptables -L -n -v
