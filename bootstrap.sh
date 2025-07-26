#!/usr/bin/env bash
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Detect the Linux distribution
if [ -f /etc/os-release ]; then
  . /etc/os-release
  OS=$ID
  log_info "Detected OS: $OS ($VERSION_ID)"
else
  log_error "Cannot detect OS distribution"
  exit 1
fi

# Install Python3, pip, and pipx if not present
install_python() {
  log_info "Installing Python and dependencies..."
  
  case $OS in
  "ubuntu" | "debian")
    log_info "Updating package lists..."
    sudo apt update
    log_info "Installing Python packages..."
    sudo apt install -y python3 python3-pip python3-venv curl git
    ;;
  "fedora")
    log_info "Installing Python packages..."
    sudo dnf install -y python3 python3-pip curl git
    ;;
  "arch")
    log_info "Installing Python packages..."
    sudo pacman -Sy --noconfirm python python-pip curl git
    ;;
  *)
    log_error "Unsupported distribution: $OS"
    log_info "Supported distributions: Ubuntu, Debian, Fedora, Arch"
    exit 1
    ;;
  esac
  
  log_info "Python installation complete"
}

# Install uv (Python package manager)
install_uv() {
  log_info "Installing uv Python package manager..."
  
  # Install uv
  if ! command -v uv >/dev/null 2>&1; then
    log_info "Downloading and installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    
    # Add uv to PATH for current session
    export PATH="$HOME/.local/bin:$PATH"
  else
    log_info "uv is already installed"
  fi
  
  # Verify uv installation
  if ! command -v uv >/dev/null 2>&1; then
    log_error "uv installation failed"
    exit 1
  fi
  
  log_info "uv installation complete: $(uv --version)"
}

# Install Ansible
install_ansible() {
  log_info "Installing Ansible with uv..."
  
  # Ensure uv is in PATH
  export PATH="$HOME/.local/bin:$PATH"
  
  # Check if /usr/bin/python exists, create symlink if needed
  if [ ! -f /usr/bin/python ]; then
    log_warn "/usr/bin/python does not exist, creating symlink to python3"
    sudo ln -sf /usr/bin/python3 /usr/bin/python
  fi
  
  # Install ansible-core using uv tool
  log_info "Installing ansible-core via uv tool..."
  uv tool install ansible-core
  
  # Add uv tools to PATH
  export PATH="$HOME/.local/bin:$PATH"
  
  # Reload PATH
  hash -r
  
  # Verify ansible is available
  if ! command -v ansible >/dev/null 2>&1; then
    log_error "ansible not found in PATH after installation"
    log_info "Current PATH: $PATH"
    log_info "Trying to locate ansible..."
    find $HOME/.local -name ansible 2>/dev/null || true
    exit 1
  fi
  
  log_info "Installing Ansible collections and roles..."
  
  # Install required collections with error handling
  if ! ansible-galaxy collection install community.general; then
    log_warn "Failed to install community.general collection, continuing..."
  fi
  
  if ! ansible-galaxy collection install community.crypto; then
    log_warn "Failed to install community.crypto collection, continuing..."
  fi
  
  # Install requirements if file exists
  if [ -f "requirements.yml" ]; then
    if ! ansible-galaxy install -r requirements.yml; then
      log_warn "Failed to install some requirements, continuing..."
    fi
  else
    log_warn "requirements.yml not found, skipping role installation"
  fi
  
  log_info "Ansible installation complete"
}

# Install just command runner
install_just() {
  log_info "Installing just command runner..."
  
  # Check if just is already installed
  if command -v just >/dev/null 2>&1; then
    log_info "just is already installed: $(just --version)"
    return 0
  fi
  
  TEMP_DIR=$(mktemp -d)
  
  if curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to "$TEMP_DIR"; then
    sudo mv "$TEMP_DIR/just" /usr/local/bin/
    log_info "just installed successfully"
  else
    log_error "Failed to install just"
    rm -rf "$TEMP_DIR"
    exit 1
  fi
  
  rm -rf "$TEMP_DIR"
}

# Main execution
main() {
  log_info "Starting Ansible playbooks bootstrap process..."
  log_info "This script will install Python, Ansible, and just command runner"
  
  # Create temp directory for downloads
  mkdir -p /tmp/ansible-playbooks-setup
  
  install_python
  install_uv
  install_ansible
  install_just
  
  # Update PATH for current session
  export PATH="$HOME/.local/bin:$PATH"
  
  log_info "Bootstrap complete! Verifying installations..."
  
  # Verify installations
  if command -v ansible >/dev/null 2>&1; then
    log_info "Ansible version: $(ansible --version | head -n1)"
  else
    log_error "Ansible verification failed"
  fi
  
  if command -v just >/dev/null 2>&1; then
    log_info "Just version: $(just --version)"
  else
    log_error "Just verification failed"
  fi
  
  log_info "\nNext steps:"
  log_info "1. Add paths to your shell profile permanently:"
  log_info "   echo 'export PATH=\"\$HOME/.local/bin:\$HOME/.cargo/bin:\$PATH\"' >> ~/.bashrc"
  log_info "   # or for zsh:"
  log_info "   echo 'export PATH=\"\$HOME/.local/bin:\$HOME/.cargo/bin:\$PATH\"' >> ~/.zshrc"
  log_info "\n2. Run the playbooks:"
  log_info "   just all    # Configure everything"
  log_info "   just dev    # Development tools only"
  log_info "   just python # Python/uv setup only"
  log_info "   just ssh    # SSH key management only"
}

# Run main function
main "$@"
