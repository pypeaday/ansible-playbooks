# Ansible Playbooks

Modern Ansible playbooks for configuring development machines and servers with improved reliability, Python management via uv, and SSH key management.

## 🚀 Quick Start

### 1. Set up SSH Authentication

Before starting, ensure you have access to your SSH keys. You have two options:

#### Option A: Using existing SSH keys
If you have your SSH keys already set up, the bootstrap script will detect and use them automatically.

#### Option B: Using a temporary key from a server
If you need to download a key from a server, set the `SSH_KEY_URL` environment variable:

```bash
export SSH_KEY_URL="https://your-server.com/ssh-key"
```

### 2. Run the Dotfiles Bootstrap

The `dotfiles-bootstrap.sh` script will handle cloning your dotfiles and running the installation:

```bash
# Make the script executable
chmod +x dotfiles-bootstrap.sh

# Run the bootstrap script (customize the REPO if needed)
REPO="git@github.com:yourusername/dotfiles.git" ./dotfiles-bootstrap.sh
```

The script will:
1. Check for existing SSH keys
2. Attempt to clone your dotfiles repository
3. If needed, download a temporary SSH key from the specified URL
4. Run the dotfiles installation script

### 3. Bootstrap the System

```bash
# Run the Ansible bootstrap to set up the environment
./bootstrap.sh

# Configure everything
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
- `just base` - Install base system packages (includes Homebrew and Neovim)
- `just brew` - Setup Homebrew
- `just neovim` - Install Neovim editor

### Utilities
- `just check` - Check syntax only
- `just ubuntu` - Test with Ubuntu
- `just fedora` - Test with Fedora
- `just arch` - Test with Arch Linux

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
just neovim  # Install Neovim editor from GitHub releases
```

### Testing

Test the playbooks in Docker containers:
```bash
just ubuntu  # Test on Ubuntu
just fedora  # Test on Fedora
just arch    # Test on Arch Linux
```

## Role Dependencies

The roles are executed in the following order by `site.yml` to ensure proper dependencies:
1. `homebrew`: Package manager (optional, used for additional tools and formulae)
2. `neovim`: Text editor installation (from GitHub releases)
3. `base-system`: Core system packages
4. Other roles (git, ssh-keys, tailscale, python-uv, shell, dotfiles, development, docker, cockpit)

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
- `install_development_tools` – enable development tools (`development` role)
- `install_docker` – enable Docker roles (`geerlingguy.docker` and `docker` roles)
- `setup_shell` – enable shell configuration (`shell-setup` role)
- `setup_ssh_keys` – enable SSH key management (`ssh-keys` role)
- `setup_tailscale` – enable Tailscale (`tailscale` role)
- `install_python_uv` – enable Python via uv (`python-uv` role)
- `setup_dotfiles` – enable dotfiles setup (`dotfiles` role)
- `install_cockpit` – enable Cockpit (`cockpit` role)

## Requirements

- Ansible 2.9+
- Python 3.x
- `just` command runner (installed via bootstrap)

## Notes

- The playbooks are designed to be idempotent and can be run multiple times
- Docker installation requires root privileges
- Some roles (like development) are opt-in and need to be explicitly enabled
- The bootstrap script installs all necessary dependencies
- Neovim is installed from the official GitHub releases tarball into `/usr/local` to ensure consistency across systems and containers
