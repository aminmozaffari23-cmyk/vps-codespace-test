FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

# =============================================================================
# 1. Install System Init, Networking, VPN, and Sysadmin Packages
# =============================================================================
RUN apt-get update && apt-get install -y --no-install-recommends \
    # System init & process management
    systemd \
    systemd-sysv \
    procps \
    cron \
    supervisor \
    # Networking & Firewalls
    iptables \
    iproute2 \
    ufw \
    net-tools \
    iputils-ping \
    dnsutils \
    traceroute \
    tcpdump \
    # VPN & Tunneling dependencies (WireGuard, TUN/TAP tools)
    wireguard-tools \
    kmod \
    openvpn \
    # Storage & Userspace Filesystems (FUSE, Loop devices)
    fuse3 \
    libfuse2t64 \
    sshfs \
    util-linux \
    # Common Utilities
    curl \
    wget \
    rsync \
    unzip \
    nano \
    vim \
    tmux \
    htop \
    sudo \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# =============================================================================
# 2. Fix Systemd for Container Boot
# =============================================================================
# Remove Microsoft's mock systemctl shim so genuine /bin/systemctl is used
RUN rm -f /usr/local/bin/systemctl

# Mask hardware-only systemd services to prevent container startup delays
RUN systemctl mask \
    dev-mqueue.mount \
    sys-kernel-tracing.mount \
    getty.target \
    getty@tty1.service \
    console-getty.service \
    systemd-udevd.service \
    systemd-udev-trigger.service \
    systemd-modules-load.service

# =============================================================================
# 3. Prepare Persistent Mountpoints & TUN Device Directory
# =============================================================================
RUN mkdir -p /dev/net /data /mnt/storage

# Set stop signal for clean systemd shutdowns
STOPSIGNAL SIGRTMIN+3

# Run genuine systemd as PID 1
CMD ["/sbin/init"]
