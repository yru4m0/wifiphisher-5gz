#!/usr/bin/env bash
set -euo pipefail

echo "[*] Installing system dependencies..."
if command -v apt &>/dev/null; then
    apt install -y dnsmasq iw hostapd libnl-3-dev libnl-genl-3-dev libssl-dev
elif command -v dnf &>/dev/null; then
    dnf install -y dnsmasq iw hostapd libnl3-devel libnl3-genl-devel openssl-devel
elif command -v pacman &>/dev/null; then
    pacman -S --noconfirm dnsmasq iw hostapd libnl openssl
else
    echo "[!] Unsupported package manager. Install dependencies manually."
    echo "    Required: dnsmasq iw hostapd libnl-3-dev libssl-dev"
    exit 1
fi

echo "[*] Installing roguehostapd (editable)..."
uv pip install -e ../roguehostapd-5gz

echo "[*] Installing wifiphisher (editable)..."
uv sync

echo "[+] Installation complete!"
echo "[+] Run: wifiphisher --help"
