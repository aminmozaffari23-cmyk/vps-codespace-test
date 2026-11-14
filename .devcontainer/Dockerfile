FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

# =============================================================================
# 1. Install System Init, Networking, VPN, and Sysadmin Packages
# =============================================================================
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Python runtime (needed for systemctl replacement)
    python3 \
    # Process management & monitoring
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
    # VPN & Tunneling dependencies (WireGuard, OpenVPN)
    wireguard-tools \
    kmod \
    openvpn \
    # Storage & Userspace Filesystems (FUSE, Loop devices)
    fuse3 \
    libfuse2t64 \
    sshfs \
    util-linux \
    # Utilities & Editors
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
# 2. Install systemctl replacement (Allows systemctl start/status in containers)
# =============================================================================
RUN curl -fsSL https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl3.py -o /usr/local/bin/systemctl && \
    chmod 755 /usr/local/bin/systemctl

# =============================================================================
# 3. Prepare Directories
# =============================================================================
RUN mkdir -p /dev/net /data /mnt/storage
