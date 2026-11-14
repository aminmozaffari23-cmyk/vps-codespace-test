FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

# =============================================================================
# 1. Install System Init, Networking, VPN, Web Server, and Sysadmin Packages
# =============================================================================
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Python runtime
    python3 \
    python3-pip \
    # Web server & Reverse proxy
    nginx \
    # Process management & scheduling
    procps \
    cron \
    supervisor \
    # Networking, Firewalls & Diagnostics
    iptables \
    iproute2 \
    ufw \
    net-tools \
    iputils-ping \
    dnsutils \
    traceroute \
    tcpdump \
    socat \
    netcat-openbsd \
    lsof \
    mtr-tiny \
    iperf3 \
    jq \
    # VPN & Tunneling dependencies (WireGuard, userspace wireguard-go, DNS resolvconf)
    wireguard-tools \
    wireguard-go \
    resolvconf \
    kmod \
    openvpn \
    # Storage & Userspace Filesystems (FUSE, Loop devices)
    fuse3 \
    libfuse2t64 \
    sshfs \
    util-linux \
    # Editors, Shells & Common Utilities
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
# 2. Prepare Directories
# =============================================================================
RUN mkdir -p /dev/net /data /mnt/storage /root/.ssh && chmod 700 /root/.ssh
