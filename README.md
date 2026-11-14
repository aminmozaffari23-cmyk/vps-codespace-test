# Ultimate VPS GitHub Codespace Template (with OpenCode)

This template transforms a standard GitHub Codespace into a fully equipped, low-level Linux virtual server with:
- **Systemd & `systemctl`** running as PID 1
- **Firewall & packet filtering** (`iptables`, `ufw`, `nftables`)
- **Auto-installed latest OpenCode** (`opencode` AI coding agent)
- **TUN/TAP virtual network device** (`/dev/net/tun`) for WireGuard, OpenVPN, and Tailscale
- **FUSE support** (`/dev/fuse`) for mounting cloud storage (`rclone`, `sshfs`) and AppImages
- **Expanded Shared Memory** (`--shm-size=4g`) & High file limits (`ulimit nofile=65535`)
- **Sysctl IP forwarding** (`net.ipv4.ip_forward=1`) for router / VPN gateway capabilities
- **Persistent named volumes** (`/data`, `/var/lib/docker`) that survive full container rebuilds
- **Embedded Docker Engine** (Docker-in-Docker)
- **OpenSSH Daemon** on port `2222`

---

## 📁 Repository Structure

```text
.
├── .devcontainer/
│   ├── Dockerfile           # Base image with systemd, iptables, TUN, FUSE, WireGuard
│   ├── devcontainer.json    # Privileged runtime args, mounts, port forwards, features
│   ├── setup.sh             # postCreateCommand: Auto-installs latest OpenCode
│   ├── init-firewall.sh     # Safe iptables rules for Codespaces
│   └── start-services.sh    # Boot script that initializes /dev/net/tun & daemons
└── README.md
```

---

## 🤖 Automatic Installation of Programs (OpenCode)

In `devcontainer.json`, the `"postCreateCommand"` hook is configured to run `.devcontainer/setup.sh`:

```bash
# Contents of .devcontainer/setup.sh:
curl -fsSL https://opencode.ai/install | bash
ln -sf "$HOME/.opencode/bin/opencode" /usr/local/bin/opencode
```

When your Codespace is created, it automatically downloads and installs the **latest release of OpenCode** and links it to `/usr/local/bin/opencode`.

### Testing OpenCode:
Inside the Codespace terminal:
```bash
opencode --version
opencode
```

---

## 🔬 Remaining VPS Features Added

### 1. Expanded Shared Memory (`--shm-size=4g`)
Standard Docker containers are restricted to a tiny **64 MB** of shared memory (`/dev/shm`). This crashes Chromium, PyTorch, multi-threaded compilers, and database workers with "Bus error (core dumped)". We increased this to **4GB**.

### 2. High Ulimits (`nofile=65535:65535`)
Standard containers often inherit low file descriptor limits (1024), causing `EMFILE: too many open files`. We set both `nofile` and `nproc` to 65535.

### 3. GPU Passthrough Ready (`"gpu": "optional"`)
If you launch a GPU-enabled Codespace instance, the container runtime automatically enables CUDA and NVIDIA GPU passthrough.

### 4. TUN/TAP Device (`/dev/net/tun`)
Enables WireGuard, OpenVPN, Tailscale, Cloudflare WARP, and ZeroTier.

### 5. FUSE Support (`/dev/fuse`)
Allows mounting AWS S3 buckets, Google Drive, or WebDAV via `rclone mount`.

### 6. Kernel Sysctl IP Forwarding
Enables `net.ipv4.ip_forward=1`, allowing the Codespace to act as a router or VPN exit node.

### 7. Persistent Named Volumes
Data stored in `/data` and `/var/lib/docker` is preserved across container rebuilds.

---

## ⚡ Quick Test Commands

```bash
# Check OpenCode
opencode --version

# Check systemd PID 1
systemctl is-system-running

# Check shared memory
df -h /dev/shm

# Check open file limit
ulimit -n

# Check iptables
iptables -L -n -v

# Check TUN and FUSE
ls -l /dev/net/tun /dev/fuse
```
