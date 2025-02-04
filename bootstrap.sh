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

# Install Python3, pip, and pipx if not present
install_python() {
  case $OS in
  "ubuntu" | "debian")
    sudo apt update
    sudo apt install -y python3 python3-pip python3-venv pipx
    ;;
  "fedora")
    sudo dnf install -y python3 python3-pip pipx
    ;;
  "arch")
    sudo pacman -Sy --noconfirm python python-pip python-pipx
    ;;
  *)
    echo "Unsupported distribution: $OS"
    exit 1
    ;;
  esac
}

# Install Ansible
install_ansible() {
  # Ensure pipx is in PATH
  export PATH="$HOME/.local/bin:$PATH"

  # check if /usr/bin/python exists
  if [ ! -f /usr/bin/python ]; then
    echo "Error: /usr/bin/python does not exist"
    # this is not actually changing the python interpreter
    # PIPX_DEFAULT_PYTHON="/usr/bin/python3" pipx install --force ansible-core
    # symlink /usr/bin/python to /usr/bin/python3
    sudo ln -s /usr/bin/python3 /usr/bin/python
    # install ansible-core using pipx
    pipx install --force ansible-core
  else
    # Install ansible-core using pipx
    pipx install --force ansible-core
  fi

  # Ensure ansible is in PATH by reloading it
  hash -r

  # Verify ansible is available
  if ! command -v ansible >/dev/null 2>&1; then
    echo "Error: ansible not found in PATH after installation"
    echo "PATH=$PATH"
    exit 1
  fi

  # Install required collections
  ansible-galaxy collection install community.general
  ansible-galaxy collection install community.crypto
  ansible-galaxy install -r requirements.yml
}

# Install just command runner
install_just() {
  echo "Installing just..."
  TEMP_DIR=$(mktemp -d)
  curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to "$TEMP_DIR"
  sudo mv "$TEMP_DIR/just" /usr/local/bin/
  rm -rf "$TEMP_DIR"
}

# Main
echo "Installing Python and dependencies..."
install_python

echo "Installing Ansible..."
install_ansible

echo "Installing just..."
install_just

echo "Add to .local/bin to path for ansible/-playbook to be available"
export PATH=/.local/bin:$PATH

echo "Ansible installation complete!"
ansible --version
