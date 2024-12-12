#!/usr/bin/env bash
set -euo pipefail

# Detect the Linux distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    echo "Cannot detect OS distribution"
    exit 1
fi

# Install Python3 and pip if not present
install_python() {
    case $OS in
        "ubuntu"|"debian")
            sudo apt update
            sudo apt install -y python3 python3-pip
            ;;
        "fedora")
            sudo dnf install -y python3 python3-pip
            ;;
        "arch")
            sudo pacman -Sy python python-pip
            ;;
        *)
            echo "Unsupported distribution: $OS"
            exit 1
            ;;
    esac
}

# Install Ansible
install_ansible() {
    python3 -m pip install --user ansible

    # Add local bin to PATH temporarily if not already there
    export PATH="$HOME/.local/bin:$PATH"
}

# Main
echo "Installing Python and pip if needed..."
install_python

echo "Installing Ansible..."
install_ansible

echo "Ansible installation complete!"
ansible --version
