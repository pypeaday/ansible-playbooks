# Ansible Playbooks

Modern Ansible playbooks for configuring development machines and servers with improved reliability, Python management via uv, and SSH key management.

## 🚀 Quick Start

1. **Bootstrap the environment:**
   ```bash
   ./bootstrap.sh
   ```
   This installs Python, Ansible, and the `just` command runner with improved error handling.

2. **Configure everything:**
   ```bash
   just all
   ```

## 📋 Available Commands

### Main Configurations
- `just all` - Configure everything (development machine with Python/uv, SSH keys, etc.)
- `just server` - Configure as server (base + docker + git + shell + cockpit + Python + SSH)
- `just dev` - Install development tools with modern Python management

### Individual Components
- `just python` - Setup Python with uv package manager
- `just ssh` - Setup SSH key management
- `just shell` - Setup shell configuration (Zsh + Oh My Zsh)
- `just git` - Setup git configuration
- `just base` - Install base system packages
- `just brew` - Setup homebrew
- `just neovim` - Setup neovim

### Utilities
- `just check` - Check syntax only
- `just ubuntu` - Test with Ubuntu
- `just fedora` - Test with Fedora

## 🔧 Roles

### Base System
- **Multi-distro support**: Ubuntu/Debian, Fedora/RHEL, Arch Linux
- Essential packages and utilities
- Improved error handling and distribution detection

### Python with uv (NEW)
- **Modern Python management** using [uv](https://github.com/astral-sh/uv) instead of pyenv
- Faster, lighter, and more reliable than traditional Python version managers
- Automatic Python version installation and management
- Global package management with uv

### SSH Key Management (NEW)
- **Automated SSH key generation** (Ed25519)
- **SSH config management** with GitHub/GitLab defaults
- **SKM integration** for multiple key management
- **FastAPI-based key sharing service** (see `ssh-key-manager/`)

### Development
- Node.js and npm
- Rust and Cargo
- Zellij terminal multiplexer
- Tree-sitter
- Kubernetes tools:
  - kubectl
  - Helm
  - k9s
  - kubecm
- Infrastructure tools:
  - Terraform

### Docker (`docker`)
- Installs Docker using geerlingguy.docker role
- Adds user to docker group
- Installs lazydocker

## Usage

### Common Commands

```bash
just dev     # Setup development environment (base + brew + neovim + git + shell + dev tools)
just server  # Basic server setup (base + brew + neovim + git + shell + docker)
just all     # Install everything
```

### Individual Components

```bash
just base    # Install base system packages (includes brew and neovim)
just git     # Setup git configuration
just shell   # Setup shell configuration (includes brew and neovim)
just brew    # Install Homebrew
just neovim  # Install Neovim via Homebrew
```

### Testing

Test the playbooks in Docker containers:
```bash
just ubuntu  # Test on Ubuntu
just fedora  # Test on Fedora
just arch    # Test on Arch Linux
```

## Role Dependencies

The roles are executed in the following order to ensure proper dependencies:
1. `base-system`: Core system packages
2. `homebrew`: Package manager (required for Neovim)
3. `neovim`: Text editor installation
4. Other roles (git, shell, development, docker)

## Inventory Structure

- `workstations`: Development machines
  - `localhost`: Local development machine
  - `babyblue`: Additional workstation

- `servers`: Remote servers (via Tailscale)
  - `ghost`: Main server
  - `ghost-vault`: Vault server

- `development`: Group containing all workstations
- `homelab`: Group containing all servers

## Variables

Key variables that control role execution:
- `install_development_tools`: Enable development tools installation
- `install_docker`: Enable Docker installation
- `setup_shell`: Enable shell configuration
- `setup_monitoring`: Enable system monitoring tools

## Requirements

- Ansible 2.9+
- Python 3.x
- `just` command runner (installed via bootstrap)

## Notes

- The playbooks are designed to be idempotent and can be run multiple times
- Docker installation requires root privileges
- Some roles (like development) are opt-in and need to be explicitly enabled
- The bootstrap script installs all necessary dependencies
- Neovim is installed via Homebrew to ensure consistency across systems and containers
