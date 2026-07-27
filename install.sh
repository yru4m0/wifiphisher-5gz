#!/usr/bin/env bash
set -euo pipefail

WIFIPHISHER_REPO="https://github.com/yru4m0/wifiphisher-5gz.git"
ROGUEHOSTAPD_REPO="https://github.com/yru4m0/roguehostapd-5gz.git"
INSTALL_DIR="/opt/wifiphisher-5gz"
ROGUE_DIR="$INSTALL_DIR/roguehostapd-5gz"

if [ "$EUID" -ne 0 ]; then
    echo "[!] Please run as root"
    exit 1
fi

detect_pkg_manager() {
    if command -v apt &>/dev/null; then
        PKG_MANAGER="apt"
        PKG_INSTALL="apt install -y"
        PKGS=(dnsmasq iw hostapd libnl-3-dev libnl-genl-3-dev libssl-dev python3-pip python3-dev)
    elif command -v dnf &>/dev/null; then
        PKG_MANAGER="dnf"
        PKG_INSTALL="dnf install -y"
        PKGS=(dnsmasq iw hostapd libnl3-devel libnl3-genl-devel openssl-devel python3-pip python3-devel)
    elif command -v pacman &>/dev/null; then
        PKG_MANAGER="pacman"
        PKG_INSTALL="pacman -S --noconfirm"
        PKGS=(dnsmasq iw hostapd libnl openssl python-pip)
    else
        echo "[!] Unsupported package manager. Install dependencies manually."
        exit 1
    fi
}

echo "[*] Detecting package manager..."
detect_pkg_manager

echo "[*] Installing system dependencies..."
$PKG_INSTALL "${PKGS[@]}"

# Handle PEP 668 (externally-managed-environment)
PIP_OPTS=""
if python3 -c "import pip" 2>/dev/null && pip --version 2>/dev/null; then
    if ! pip install --dry-run setuptools 2>&1 | grep -qi "error.*externally-managed"; then
        : # normal pip
    else
        PIP_OPTS="--break-system-packages"
        echo "[*] Detected externally-managed environment, using $PIP_OPTS"
    fi
fi

echo "[*] Installing Python dependencies..."
pip3 install $PIP_OPTS pyric scapy tornado pbkdf2

echo "[*] Cloning roguehostapd-5gz..."
if [ -d "$ROGUE_DIR" ]; then
    git -C "$ROGUE_DIR" pull
else
    git clone "$ROGUEHOSTAPD_REPO" "$ROGUE_DIR"
fi

echo "[*] Installing roguehostapd..."
pip3 install $PIP_OPTS -e "$ROGUE_DIR"

echo "[*] Cloning wifiphisher-5gz..."
if [ -d "$INSTALL_DIR/wifiphisher-5gz" ]; then
    git -C "$INSTALL_DIR/wifiphisher-5gz" pull
else
    git clone "$WIFIPHISHER_REPO" "$INSTALL_DIR/wifiphisher-5gz"
fi

echo "[*] Installing wifiphisher..."
pip3 install $PIP_OPTS -e "$INSTALL_DIR/wifiphisher-5gz"

echo "[+] Installation complete!"
echo "[+] Run: wifiphisher --help"
