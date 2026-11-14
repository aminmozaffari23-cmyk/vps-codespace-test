#!/usr/bin/env bash
# =============================================================================
# setup.sh: Runs via "postCreateCommand" ONCE when the Codespace is created.
# Perfect for automatically installing the latest version of tools like OpenCode.
# =============================================================================

set -e

echo "[Setup] Installing latest version of OpenCode..."
curl -fsSL https://opencode.ai/install | bash

# Create a system-wide symlink so 'opencode' is immediately available in all shells & paths
if [ -f "$HOME/.opencode/bin/opencode" ]; then
    sudo ln -sf "$HOME/.opencode/bin/opencode" /usr/local/bin/opencode || ln -sf "$HOME/.opencode/bin/opencode" /usr/local/bin/opencode
    echo "[Setup] OpenCode installed successfully to /usr/local/bin/opencode!"
    /usr/local/bin/opencode --version || true
elif [ -f "/root/.opencode/bin/opencode" ]; then
    ln -sf "/root/.opencode/bin/opencode" /usr/local/bin/opencode
    echo "[Setup] OpenCode installed successfully to /usr/local/bin/opencode!"
    /usr/local/bin/opencode --version || true
fi

# Make sure all scripts in .devcontainer are executable
chmod +x .devcontainer/*.sh 2>/dev/null || true

echo "[Setup] Initial provisioning complete!"
