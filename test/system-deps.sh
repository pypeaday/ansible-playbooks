#!/usr/bin/env bash
set -euo pipefail

# Install minimal system dependencies needed for Ansible and bootstrap.sh
# This script is intended to be run as root inside test containers,
# but it can also serve as a reference for host setup.

if [ -f /etc/os-release ]; then
  . /etc/os-release
  OS=$ID
else
  echo "[system-deps] Cannot detect OS distribution" >&2
  exit 1
fi

case "$OS" in
  ubuntu|debian)
    echo "[system-deps] Installing system packages for Debian/Ubuntu..."
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install -y \
      python3 \
      python3-pip \
      python3-venv \
      python3-apt \
      sudo \
      git \
      curl
    rm -rf /var/lib/apt/lists/*
    ;;

  fedora)
    echo "[system-deps] Installing system packages for Fedora..."
    dnf install -y \
      python3 \
      python3-pip \
      sudo \
      git \
      curl
    dnf clean all
    ;;

  arch)
    echo "[system-deps] Installing system packages for Arch..."
    pacman -Syu --noconfirm \
      python \
      python-pip \
      sudo \
      git \
      curl
    pacman -Scc --noconfirm
    ;;

  *)
    echo "[system-deps] Unsupported distribution: $OS" >&2
    exit 1
    ;;

esac
